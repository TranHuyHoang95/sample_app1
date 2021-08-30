puts "Start create seed data"
User.create!(name: "Hoang Nhan",
  email: "tranhuyhoangvct@gmail.com",
  password: "password",
  password_confirmation: "password",
  admin: true)
# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, password: password,  password_confirmation: password)
end
puts "Create completed!"