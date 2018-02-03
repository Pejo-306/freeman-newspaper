if Rails.env.development?
  User.create!(name: 'Albert',
               surname: 'Einstein',
               email: 'genius@example.com',
               password: 'password', 
               password_confirmation: 'password',
               admin: true, 
               activated: true, 
               activated_at: Time.zone.now)

  99.times do |n|
    name = Faker::Name.first_name
    surname = Faker::Name.last_name
    email = "example-#{n+1}@example.com"
    password = 'password'
    User.create!(name: name, 
                 surname: surname, 
                 email: email,
                 password: password, 
                 password_confirmation: password,
                 admin: false,
                 activated: true, 
                 activated_at: Time.zone.now)
  end
end

