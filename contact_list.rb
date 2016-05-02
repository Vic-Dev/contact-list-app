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
  end
end

contact_list = ContactList.new(ARGV[0])

