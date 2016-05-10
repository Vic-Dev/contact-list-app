require 'csv'
require 'pg'
require 'pry'

class Contact

  attr_accessor :name, :email
  
  def initialize(name, email)
    @name = name
    @email = email
  end

  class << self

    def connection
      PG.connect(
        host: 'localhost',
        dbname: 'contact_list',
        user: 'development',
        password: 'development'
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
      # if email_exists?(email)
      #   "Error: contact already exists"
      # else
        contact = Contact.new(name, email)
        contact.save
      # end
    end

    def email_exists?(email)
      CSV.read('customers.csv').any? {|x| x.include? email}
    end
    
    def find(id)
      result = connection.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id])
      c = result[0]
      contact = Contact.new(c["name"], c["email"])
    end
    
    def search(term)
      # array = []
      # search = CSV.read('customers.csv')
      # thing1 = search.each do |contact| 
      #   contact_string = contact.join(" ")
      #   if contact_string.downcase.include? term.downcase
      #     array << contact
      #   end
      # end      
      # array
      result = connection.exec_params('SELECT * FROM contacts WHERE name LIKE (\'%\' || $1 || \'%\') OR email LIKE (\'%\' || $1 || \'%\');', [term]) do |results| 
        results.map do |c|
          Contact.new(c["name"], c["email"])
        end
      end
    end
  end

  def save
    Contact.connection.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id', [@name, @email])
  end

end

binding.pry
