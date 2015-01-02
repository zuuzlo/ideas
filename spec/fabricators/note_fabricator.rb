Fabricator(:note) do
  title { Faker::Lorem.word }
  text { Faker::Lorem.sentence( word_count = 5 ) }
end