require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

registratrion_hours=[]
registratrion_days=[]

def most_frequent(vector)
  most_frequent_things=[]  
  counter=vector.map{|item| vector.count(item)}.max
  vector.tally.each do |key,value|
    most_frequent_things.push(key) if value==counter
  end
  most_frequent_things
end

def peak_days(dayyz)
  time=Time.strptime(dayyz,"%m/%d/%Y %k:%M")
  time.strftime("%A")
end

def peak_hours(hours)
  time=Time.strptime(hours,'%m/%d/%Y %k:%M')
  time.strftime('%k')
end

def clean_numbers(numbers)

  if numbers.nil?
    '0000000000'
  elsif numbers.length==10
    numbers
  elsif phone.length == 11 && phone.start_with?('1')
    numbers[1..10]
  else
    'No bueno!'
  end

  numbers

end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  numbers=clean_numbers(row[:HomePhone])
  reg_date=row[:regdate]
  reg_week=row[:regdate]
  registratrion_days.push(peak_days(reg_week))
  registratrion_hours.push(peak_hours(reg_date))
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)

end

most_frequent_hours=most_frequent(registratrion_hours)

puts "The most frequent registration hours are:#{most_frequent_hours}"

most_frequent_days=most_frequent(registratrion_days)

puts "The most frequent days on the week:#{most_frequent_days}"