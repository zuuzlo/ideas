Fabricator(:idea_link) do
  name { Faker::Lorem.sentence(3) }
  link_url { Faker::Internet.url }
end