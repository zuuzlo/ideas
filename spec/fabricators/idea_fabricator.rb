Fabricator(:idea) do
  name { Faker::Lorem.sentence(3) }
  description { Faker::Lorem.sentence( word_count = 5 ) }
  benefits { Faker::Lorem.sentence( word_count = 5 ) }
  problem_solves { Faker::Lorem.sentence( word_count = 5 ) }
  status 'Hold'
end
