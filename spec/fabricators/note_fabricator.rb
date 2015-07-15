Fabricator(:note) do
  title { Faker::Lorem.sentence(3) }
  text { Faker::Lorem.sentence( word_count = 5 ) }
end