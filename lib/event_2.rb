def most_frequent(vector)
  most_frequent_things=[]  
  counter=vector.map{|item| vector.count(item)}.max
  vector.tally.each do |key,value|
    most_frequent_things.push(key) if value==counter
  end
  most_frequent_things
end


most_frequent_hours=[]
counter=registratrion_hours.map{|item| registratrion_hours.count(item)}.max
registratrion_hours.tally.each do |key,value|
  most_frequent_hours.push(key) if value==counter
end

puts "The most frequent registration hours are:#{most_frequent_hours}"

most_frequent_days=[]
counter=registratrion_days.map{|item| registratrion_days.count(item)}.max
registratrion_days.tally.each do |key,value|
  most_frequent_days.push(key) if value==counter
end

puts "The most frequent days on the week:#{most_frequent_days}"