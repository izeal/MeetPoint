User.create(
    name:'Ivan',
    email: 'foo@bar.baz',
    password: 'foobar',
)

100.times do |n|
  name = Faker::LordOfTheRings.character.gsub(" ", "_")
  User.create(
    name: "#{name}_#{n}",
    email: "#{name}#{n}@bar.baz",
    password: 'foobar'
  )
end

users = User.all
users.each do |user|
  rand(0..4).times do
    description = Faker::HeyArnold.quote
    address = Faker::Address.city
    title = Faker::StarTrek.villain
    datetime = Time.at(rand(50.years.ago.to_f..(Time.now + 20.years).to_f))
    user.events.create(description: description,
                       title: title,
                       address: address,
                       datetime: datetime)
  end
end
