if Rails.env.development?
  # admin user
  admin = Author.create!(name: 'Albert',
                         surname: 'Einstein',
                         email: 'genius@example.com',
                         biography: "Albert Einstein is one of humanity's most prized geniuses",
                         password: 'password', 
                         password_confirmation: 'password',
                         created_at: 40.days.ago,
                         updated_at: 40.days.ago,
                         admin: true, 
                         activated: true, 
                         activated_at: Time.zone.now,
                         author: true)

  admin.column = Column.create!(author: admin)
  admin.save!

  # normal users
  79.times do |n|
    name = Faker::Name.first_name
    surname = Faker::Name.last_name
    email = "example-#{n+1}@example.com"
    password = "password"
    User.create!(name: name, 
                 surname: surname, 
                 email: email,
                 password: password, 
                 password_confirmation: password,
                 admin: false,
                 activated: true, 
                 activated_at: Time.zone.now,
                 author: false)
  end

  # Topics
  Faker::Lorem.words(20).uniq.each { |word| Topic.create!(name: word) }

  # authors, columns, articles, comments
  20.times do |n|
    name = Faker::Name.first_name
    surname = Faker::Name.last_name
    email = "author-#{n+1}@example.com"
    password = "password"
    biography = Faker::Lorem.sentence
    author = Author.create!(name: name, 
                            surname: surname, 
                            email: email,
                            biography: biography,
                            password: password, 
                            password_confirmation: password,
                            created_at: 40.days.ago,
                            updated_at: 40.days.ago,
                            admin: false,
                            activated: true, 
                            activated_at: Time.zone.now,
                            author: true)
    
    column = Column.create!(author: author)

    20.times do |_|
      article = Article.create!(title: Faker::Lorem.word,
                                content: Faker::Lorem.sentence,
                                views: Random.rand(1000),
                                column: column)
      article.topics << Topic.order("RANDOM()").limit(2)

      10.times do |_|
        article.comments << Comment.create!(user: User.order("RANDOM()").first,
                                            article: article,
                                            content: Faker::Lorem.sentence)
      end
      article.save!
      column.articles << article
    end
    column.save!

    author.column = column
    author.save!
  end
end

