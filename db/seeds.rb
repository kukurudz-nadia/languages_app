require 'json'

file = File.read(Rails.root.join('db', 'languages.json'))
data = JSON.parse(file)
data.each do |language|
  Language.create!(name: language['Name'], type: language['Type'],
                   designed_by: language['Designed by'])
end
