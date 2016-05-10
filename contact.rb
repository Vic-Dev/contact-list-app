require 'csv'
require 'pg'
require 'pry'

class Contact

  attr_accessor :name, :email
  attr_reader :id
  
  def initialize(name, email, id=nil)
    @name = name
    @email = email
    @id = id
  end

  class << self

    def connection
      PG.connect(
        host: 'localhost',
        dbname: 'contact_list'
      )
    end

    def all
      connection.exec('SELECT * FROM contacts;') do |results|
        results.map do |c|
          Contact.new(c["name"], c["email"])
        end
      end
    end

    def create(name, email)
      if email_exists?(email)
        "Error: contact already exists"
      else
        contact = Contact.new(name, email)
        contact.save
      end
    end

    def email_exists?(email)
      result = connection.exec_params('SELECT * FROM contacts WHERE email = $1', [email])
      if result.num_tuples.zero?
        false
      else
        true
      end
    end
    
    def find(id)
      result = connection.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id])
      c = result[0]
      p contact = Contact.new(c["name"], c["email"], c["id"])
    end
    
    def search(term)
      result = connection.exec_params('SELECT * FROM contacts WHERE name LIKE (\'%\' || $1 || \'%\') OR email LIKE (\'%\' || $1 || \'%\');', [term]) do |results| 
        results.map do |c|
          Contact.new(c["name"], c["email"])
        end
      end
    end
  end

  def saved?
    self.id ? true : false
  end

  def save
    if saved?
      Contact.connection.exec_params('UPDATE contacts SET name=$1, email=$2 WHERE id=$3', [name, email, id])
    else
      Contact.connection.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id', [@name, @email]) do |results|
        @id = results[0]["id"]
      end
    end
  end

  def destroy
    Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1::int', [@id])
  end

end

binding.pry
