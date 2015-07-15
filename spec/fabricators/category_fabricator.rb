Fabricator(:category) do
  name { Faker::Lorem.sentence(3) }
  description { Faker::Lorem.sentence( word_count = 5 ) }
end