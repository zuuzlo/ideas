Fabricator(:jot) do
  context { Faker::Lorem.sentence(3) }
  status { %w(Hold Active Complete).sample }
end