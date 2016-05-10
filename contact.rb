require 'csv'
require 'pg'

class Contact

  attr_accessor :name, :email
  
  def initialize(name, email)
    @name = name
    @email = email
  end

  class << self

    def connection
      PG.connect(
        host: 'localhost'
        dbname: 'contact_list'
        user: 'development'
        password: 'development'
      )
    end

    def all
      array = []
      CSV.foreach('customers.csv') do |name, email|
        array << Contact.new(name, email)
      end
      array
    end

    def create(name, email)
      if email_exists?(email)
        "Error: contact already exists"
      else
        contact = Contact.new(name, email)
        CSV.open('customers.csv', "a") do |csv|
          csv << [contact.name, contact.email]
        end
        return "Added user."
      end
    end

    def email_exists?(email)
      CSV.read('customers.csv').any? {|x| x.include? email}
    end
    
    def find(id)
      id_index = id - 1
      Contact.all[id_index]
    end
    
    def search(term)
      array = []
      search = CSV.read('customers.csv')
      thing1 = search.each do |contact| 
        contact_string = contact.join(" ")
        if contact_string.downcase.include? term.downcase
          array << contact
        end
      end      
      array
    end

  end

end
