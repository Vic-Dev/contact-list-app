require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize(input)
    @input = input
  end

  if ARGV.empty?
    puts "Here is a list of available commands:"
    puts "    new    - Create a new contact"
    puts "    list   - List all contacts"
    puts "    show   - Show a contact"
    puts "    search - Search contacts"
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
    created = Contact.create(name, email)
    puts created
  elsif ARGV[0] == "show"
    puts "Please give me a contact ID:"
    id = STDIN.gets.to_i
    contact = Contact.find(id)
    if contact.nil? || id < 1
      puts "Contact with id: #{id} cannot be found"
    else
      puts contact.name
      puts contact.email
    end
  elsif ARGV[0] == "search"
    puts "Please enter a search term:"
    term = STDIN.gets.chomp
    search_results = Contact.search(term)
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
    contact = Contact.find(id)
    contact.name = new_name
    contact.email = new_email
    contact.save
  elsif ARGV[0] == "destroy"
    puts "Please enter a contact ID:"
    id = STDIN.gets.to_i
    puts "Are you sure?"
    answer = STDIN.gets.chomp
    answer.downcase!
    if answer == "y" || answer == "yes"
      contact = Contact.find(id)
      contact.destroy
    end
  else
    puts "idk"
  end
end
