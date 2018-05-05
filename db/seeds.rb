User.create(
    name:'Ivan',
    email: 'foo@bar.baz',
    password: 'foobar',
)

Faker::UniqueGenerator.clear

12.times do |n|
  name = Faker::Friends.unique.character.gsub(" ", "_")
  user = User.create(
    name: name,
    email: "#{name}@bar.baz",
    password: 'foobar'
  )
end

26.times do |n|
  name = Faker::LordOfTheRings.unique.character.gsub(" ", "_")
  User.create(
    name: name,
    email: "#{name}@bar.baz",
    password: 'foobar'
  )
end

35.times do |n|
  name = Faker::Hobbit.unique.character.gsub(" ", "_")
  User.create(
    name: name,
    email: "#{name}@bar.baz",
    password: 'foobar'
  )
end

30.times do |n|
  name = Faker::Simpsons.unique.character.gsub(" ", "_")
  User.create(
    name: name,
    email: "#{name}@bar.baz",
    password: 'foobar'
  )
end

users = User.all
users.each do |user|
  rand(0..4).times do
    description = Faker::Friends.quote
    address = Faker::Address.city
    title = Faker::Kpop.ii_groups
    datetime = Time.at(rand(10.years.ago.to_f..(Time.now + 10.years).to_f))
    user.events.create(description: description,
                       title: title,
                       address: address,
                       datetime: datetime)
  end
end

events = Event.all
events.each do |event|
  rand(0..6).times do
    event.comments.create(body: Faker::Simpsons.quote, user_id: User.all.sample.id)
  end
  rand(0..10).times do
    event.subscriptions.create(user_id: User.all.sample.id)
  end
end

# events.each do |event|
#     if event.subscriptions.any?
#     rand(0..3).times do
#       event.photos.create(remote_photo_url: Faker::LoremPixel.image, user_id: event.subscriptions.sample.user_id)
#     end
#   end
# end
