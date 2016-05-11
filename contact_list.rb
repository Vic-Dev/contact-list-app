require_relative 'setup.rb'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize(input)
    @input = input
  end

  if ARGV.empty?
    puts "Here is a list of available commands:"
    puts "    new     - Create a new contact"
    puts "    list    - List all contacts"
    puts "    show    - Show a contact"
    puts "    search  - Search contacts"
    puts "    update  - Update contact"
    puts "    destroy - Destroy contact"
  elsif ARGV[0] == "list"
    Contact.all.each_with_index do |row, index|
      puts "#{index + 1}: #{row.name} (#{row.email})"
    end
    puts "---"
    puts "#{Contact.all.count} records total"
  elsif ARGV[0] == "new"
    puts "Please give me a name:"
    name = STDIN.gets.chomp
    puts "Please give me a valid email:"
    email = STDIN.gets.chomp
    created = Contact.create(name: name, email: email)
    if created.errors[:email].any?
      puts "Could not create contact: email address already exists"
    else
      puts "Contact created!"
    end
  elsif ARGV[0] == "show"
    puts "Please give me a contact ID:"
    id = STDIN.gets.to_i
    begin
      contact = Contact.find(id)
    rescue ActiveRecord::RecordNotFound
      contact = false
    end
    if contact
      puts "Here is your contact:"
      puts contact.name
      puts contact.email
    else
      puts "Contact with id: #{id} cannot be found"
    end
  elsif ARGV[0] == "search"
    puts "Please enter a search term:"
    term = STDIN.gets.chomp
    search_results = Contact.where("name LIKE ('%' || ? || '%') OR email LIKE ('%' || ? || '%')", term, term)
    search_results.each_with_index do |row, index|
      puts "#{index + 1}: #{row.name} (#{row.email})"
    end
    puts "---"
    puts "#{search_results.length} record total"
  elsif ARGV[0] == "update"
    puts "Please enter a contact ID:"
    id = STDIN.gets.to_i
    puts "Please enter a new name:"
    new_name = STDIN.gets.chomp
    puts "Please enter a new email:"
    new_email = STDIN.gets.chomp
    begin
      contact = Contact.find(id)
    rescue ActiveRecord::RecordNotFound
      contact = false
    end
    if contact
      contact.name = new_name
      contact.email = new_email
      contact.save
      puts "Contact added"
    else
      puts "Contact with id: #{id} cannot be found"
    end
  elsif ARGV[0] == "destroy"
    puts "Please enter a contact ID:"
    id = STDIN.gets.to_i
    begin
      contact = Contact.find(id)
    rescue ActiveRecord::RecordNotFound
      contact = false
    end
    if contact
      puts "Are you sure?"
      answer = STDIN.gets.chomp
      answer.downcase!
      if answer == "y" || answer == "yes"
        contact.destroy
        puts "Contact was deleted :)"
      else
        puts "Contact was not deleted"
      end
    else
      puts "Contact with id: #{id} cannot be found"
    end
  else
    puts "idk"
  end
end
