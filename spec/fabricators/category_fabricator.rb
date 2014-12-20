Fabricator(:category) do
  name { Faker::Lorem.word }
  description { Faker::Lorem.sentence( word_count = 5 ) }
  user
end