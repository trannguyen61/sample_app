User.create!(name: Settings.user.admin.name,
            email: Settings.user.admin.email,
            password: Settings.user.admin.password,
            password_confirmation: Settings.user.admin.password,
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "#{Settings.user.faker.email1}#{n+1}#{Settings.user.faker.email2}"
  User.create!(name: name,
              email: email,
              password: Settings.user.faker.password,
              password_confirmation: Settings.user.faker.password,
              activated: true,
              activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

