require 'csv'


puts "How many questions do you need?"
count = gets.chomp.to_i
raise "Sorry, that's not a valid number of questions" unless count.to_i == count && count > 0

puts "You just asked for #{count} question(s)."
puts "Here is your quiz: "

questions = []
CSV.foreach("./questions.csv", :headers => true) do |row|
  question = {}
  question[:strand_id] = row[0] 
  question[:strand_name] = row[1] 
  question[:standard_id] = row[2] 
  question[:standard_name] = row[3] 
  question[:question_id] = row[4] 
  question[:difficulty] = row[5]
  questions << question
end

output = []

puts output