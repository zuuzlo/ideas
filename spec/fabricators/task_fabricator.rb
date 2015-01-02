Fabricator(:task) do
  name { Faker::Lorem.word }
  description { Faker::Lorem.sentence( word_count = 5 ) }
  status { %w(Hold Active Complete).sample }
  percent_complete 25
  start_date { Time.now }
  finish_date { Time.now + 5.days }
end