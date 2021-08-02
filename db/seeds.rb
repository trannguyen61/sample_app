User.create!(name: Settings.user.admin.name,
            email: Settings.user.admin.email,
            password: Settings.user.admin.password,
            password_confirmation: Settings.user.admin.password,
            admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "#{Settings.user.faker.email1}#{n+1}#{Settings.user.faker.email2}"
  User.create!(name: name,
              email: email,
              password: Settings.user.faker.password,
              password_confirmation: Settings.user.faker.password)
end
