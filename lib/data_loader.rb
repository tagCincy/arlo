require 'faker'

class DataLoader

  def load

    user_roles = [2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]

    puts "Creating 50 extra users"
    50.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.safe_email("#{first_name}.#{last_name}")
      username = Faker::Internet.user_name

      Account.create!({
                          username: username,
                          bio: Faker::Lorem.paragraph,
                          role: user_roles.sample,
                          user_attributes: {
                              first_name: first_name,
                              last_name: last_name,
                              email: email,
                              password: 'password',
                              password_confirmation: 'password'
                          }})


    end

    puts "Getting normal users"
    @norms = Account.where(role: 0)

    puts "Getting tech users"
    @techs = Account.where(role: 1)

    puts "Getting admin users"
    @admins = Account.where(role: 2)

    @all_users = Account.all

    puts "Loading Super User"
    @super_user = Account.create!({
                                      username: 'god',
                                      bio: 'God of ArloHD.com.',
                                      role: :super,
                                      user_attributes: {
                                          first_name: 'The',
                                          last_name: 'One',
                                          email: 'god@email.com',
                                          password: 'password',
                                          password_confirmation: 'password'
                                      }
                                  }
    )

    puts "Loading Tim"
    @tim = Account.create!({
                               username: 'timguibs',
                               bio: 'Creator of ArloHD.com.',
                               role: :admin,
                               user_attributes: {
                                   first_name: 'Tim',
                                   last_name: 'Guibord',
                                   email: 'tim@email.com',
                                   password: 'password',
                                   password_confirmation: 'password'
                               }
                           }
    )

    puts "Loading Tech User"
    @tech_user = Account.create!({
                                     username: 'techUser',
                                     bio: 'Generic Tech User.',
                                     role: :tech,
                                     user_attributes: {
                                         first_name: 'Tech',
                                         last_name: 'User',
                                         email: 'tech@email.com',
                                         password: 'password',
                                         password_confirmation: 'password'
                                     }
                                 }
    )

    puts "Loading Normal User"
    @norm_user = Account.create!({
                                     username: 'normUser',
                                     bio: 'Generic User.',
                                     role: :user,
                                     user_attributes: {
                                         first_name: 'Norm',
                                         last_name: 'User',
                                         email: 'user@email.com',
                                         password: 'password',
                                         password_confirmation: 'password'
                                     }
                                 }
    )

    groups = []

    puts "Creating IT group"
    groups << Group.create!({
                                name: 'School of Information Technology',
                                code: 'it',
                                description: 'UC IT school',
                                accounts: [@tim, @tech_user, @norm_user]
                            })

    puts "Creating UC group"
    groups << Group.create!({
                                name: 'University of Cincinnati',
                                code: 'uc',
                                description: 'University of Cincinnati',
                                accounts: [@tim, @tech_user, @norm_user]
                            })

    puts "Creating CECH group"
    groups << Group.create!({
                                name: 'UC CECH',
                                code: 'cech',
                                description: 'UC CECH',
                                accounts: [@tim, @tech_user, @norm_user]
                            })

    puts "Creating 5 general groups"
    5.times do
      name = Faker::Company.name
      code = Faker::Internet.domain_word
      description = Faker::Company.catch_phrase
      groups << Group.create!({name: name, code: code, description: description})
    end

    puts "populating groups with accounts"
    groups.each do |i|
      i.accounts << @norms.sample(5)
      i.accounts << @techs.sample(3)
      i.accounts << @admins.sample
    end

    puts "creates tags"
    @tags =[]
    100.times do
      @tags << Tag.create!({name: Faker::Internet.slug, description: Faker::Lorem.sentence})
    end

    puts "create public questions"
    public_questions = []
    25.times do
      public_questions << Question.create!({
                                               title: Faker::Lorem.sentence,
                                               content: Faker::Lorem.paragraph,
                                               account: @norms.sample,
                                               tags: @tags.sample(3)
                                           })
    end

    puts "creates public question comments"
    public_questions.each do |i|
      2.times { i.comments.create!({content: Faker::Lorem.sentence, account: @all_users.sample}) }
      answers = i.answers.create!({content: Faker::Lorem.paragraph, account: @techs.sample})
      2.times { answers.comments.create!({content: Faker::Lorem.sentence, account: @all_users.sample}) }
    end

    puts "creating group questions, answers, and comments"
    groups.each do |i|
      users = i.accounts.all
      norm = i.accounts.where(role: 0)
      tech = i.accounts.where(role: 1)
      questions = []
      10.times do
        questions << Question.create!({
                                          title: Faker::Lorem.sentence,
                                          content: Faker::Lorem.paragraph,
                                          account: norm.sample,
                                          public: [true, false, false, false, false, false].sample,
                                          tags: @tags.sample(3),
                                          group: i
                                      })
      end

      questions.each do |i|
        2.times { i.comments.create!({content: Faker::Lorem.sentence, account: users.sample}) }
        answers = i.answers.create!({content: Faker::Lorem.paragraph, account: tech.sample})
        2.times { answers.comments.create!({content: Faker::Lorem.sentence, account: users.sample}) }
      end
    end

  end

end