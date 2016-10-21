require 'csv'
require 'byebug'

puts "How many questions do you need?"
count = gets.chomp.to_i
raise "Sorry, that's not a valid number of questions" unless count.to_i == count && count > 0

puts "You just asked for #{count} question(s)."
puts "Here is your quiz: "

all_questions = []
CSV.foreach("./questions.csv", :headers => true) do |row|
  question = {}
  question[:strand_id] = row[0].to_i
  question[:strand_name] = row[1] 
  question[:standard_id] = row[2].to_i
  question[:standard_name] = row[3] 
  question[:question_id] = row[4].to_i
  question[:difficulty] = row[5].to_i
  all_questions << question
end

stat_options = {}
stat_options[:strand_ids] = all_questions.map{|question| question[:strand_id] }.uniq!
stat_options[:standard_ids] = all_questions.map{|question| question[:standard_id] }.uniq!
stat_options[:question_ids] = all_questions.map{|question| question[:question_id] }

# I would change get_stats to update_stats, where a new hash isn't recreated every single time, but appended.
def get_stats(questions)
  output = Hash.new
  output[:strand_ids] = questions.map{ |question| question[:strand_id] }
  output[:standard_ids] = questions.map{ |question| question[:standard_id] }
  output[:question_ids] = questions.map{ |question| question[:question_id] }
  output  
end

def valid_question?(id, current_ids, possible_ids)
  return true if current_ids.uniq.length == possible_ids.length
  return false if current_ids.include?(id)
  true
end

def select_question(question_bank, current_stats, stat_options)
  viable_questions = question_bank.select do |question|
    valid_question?(question[:strand_id], current_stats[:strand_ids], stat_options[:strand_ids]) && 
    valid_question?(question[:standard_id], current_stats[:standard_ids], stat_options[:standard_ids]) && 
    valid_question?(question[:question_id], current_stats[:question_ids], stat_options[:question_ids])
  end
  return viable_questions.sample
end

# Here's the meat of the operation
selected_questions = []
while selected_questions.count < count
  stats = get_stats(selected_questions)
  selected_questions.push(select_question(all_questions, stats, stat_options))
end


# this returns the answer
puts selected_questions.map {|question| question[:question_id] }