require 'csv'

array = []

thing = CSV.foreach('customers.csv', col_sep: ', ') do |name, email|
  email = " (#{email})"
  array << name + email
end

# p array.count

array.each_with_index do |row, index|
  puts "#{index + 1}: #{row}"
end

puts "----"
puts "#{array.count} records total"



# average_money_spent = Array.new
# CSV.foreach('customers.csv', converters: :numeric) do |row|
#   average_money_spent << row[2] / row[1]
# end

# customers_array = CSV.read('customers.csv')


# CSV.open('our-new-customers-file.csv', 'w') do |csv_object|
#   customers_array.each do |row_array|
#     csv_object << row_array
#   end
# end