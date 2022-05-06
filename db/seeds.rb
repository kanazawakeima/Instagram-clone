50.times do |n|
  name = Faker::Games::Pokemon.name
  email = Faker::Internet.email
  image = Faker::Avatar.image
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               image: image,
               )
end
