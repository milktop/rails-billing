Sale.destroy_all
Consultation.destroy_all
Act.destroy_all
Product.destroy_all
Client.destroy_all
Clinic.destroy_all

Clinic.create name: "Villereal"
Clinic.create name: "Castillonnes"
Clinic.create name: "SLDV"
Clinic.create name: "Mouleydier"

100.times do
  Client.create(name: Faker::Name.name)
end

20.times do
  Sale.create clinic: Clinic.all.sample, client: Client.all.sample, date: Faker::Date.between(from: 1.year.ago, to: Date.today)
end

200.times do
  Consultation.create clinic: Clinic.all.sample, client: Client.all.sample, date: Faker::Date.between(from: 1.year.ago, to: Date.today), motive: Faker::Lorem.sentence(word_count: 3)
end

100.times do
  Act.create name: Faker::Lorem.sentence(word_count: 3), unit_price_cents: Faker::Number.between(from: 1000, to: 100000), tax_rate: 20
end

200.times do
  Product.create name: Faker::Lorem.sentence(word_count: 3), unit_price_cents: Faker::Number.between(from: 1000, to: 100000), tax_rate: 20
end

