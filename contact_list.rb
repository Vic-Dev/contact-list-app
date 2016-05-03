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
    Contact.create(name, email)
  elsif ARGV[0] == "show"
    puts "Please give me a contact ID"
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
      puts "#{index + 1}: #{row[0]} (#{row[1]})"
    end
    puts "---"
    puts "#{search_results.length} record total"
  else
    puts "idk"
  end
end

# contact_list = ContactList.new(ARGV[0])

# require 'csv'

# array = []

# thing = CSV.foreach('customers.csv', col_sep: ', ') do |name, email|
#   email = " (#{email})"
#   array << name + email
# end

# # p array.count

# array.each_with_index do |row, index|
#   puts "#{index + 1}: #{row}"
# end

# puts "----"
# puts "#{array.count} records total"