require 'faker'
require 'factory_girl_rails'

NUM_USERS = 30
NUM_TECHS = 15
NUM_ADMINS = 3
NUM_TAGS = 100
NUM_QUESTIONS = 200

users = []
norm_users = []
tech_users = []
admin_users = []

superUser = FactoryGirl.create(:account, username: 'tim', bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: 'Tim', last_name: 'Guibord', email: 'tim@email.com'), role: :super)
admin_users << FactoryGirl.create(:account, username: 'admin', bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: 'Admin', last_name: 'User', email: 'admin@email.com'), role: :admin)
tech_users << FactoryGirl.create(:account, username: 'tech', bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: 'Tech', last_name: 'User', email: 'tech@email.com'), role: :tech)
norm_users << FactoryGirl.create(:account, username: 'user', bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: 'Normal', last_name: 'User', email: 'user@email.com'), role: :user)

26.times do |i|
  norm_users << FactoryGirl.create(:account, username: "user#{i+3}", bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "user#{i+3}@topgunhq.com"), role: :user)
end

users += norm_users

15.times do |i|
  tech_users << FactoryGirl.create(:account, username: "techie#{i+3}", bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "techie#{i+3}@topgunhq.com"), role: :tech)
end

users += tech_users

4.times do |i|
  admin_users << FactoryGirl.create(:account, username: "admin#{i+3}", bio: Faker::Lorem.paragraph, user: FactoryGirl.create(:user, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "admin#{i+3}@topgunhq.com"), role: :admin)
end

users += admin_users

groups = []

groups << FactoryGirl.create(:group, name: 'UC group', code: 'uc', accounts: [superUser])
groups << FactoryGirl.create(:group, name: 'IT group', code: 'it', accounts: [superUser])
groups << FactoryGirl.create(:group, name: 'CECH group', code: 'cech', accounts: [superUser])

admin_users.each do |i|
  3.times {groups << FactoryGirl.create(:group, accounts: [i])}
end

groups.each do |i|
  i.accounts << norm_users.sample(10)
  i.accounts << tech_users.sample(4)
end

tags = []
200.times { tags << FactoryGirl.create(:tag, name: Faker::Internet.slug, description: Faker::Lorem.sentence) }

questions = []
100.times { questions << FactoryGirl.create(:public_question, title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, account: norm_users.sample, tags: tags.sample(3)) }

comments = []
answers = []

questions.each do |i|
  3.times { comments << FactoryGirl.create(:comment, content: Faker::Lorem.sentence, account: users.sample, commentable_id: i.id, commentable_type: 'Question') }
  3.times { answers << FactoryGirl.create(:answer, content: Faker::Lorem.paragraph, account: tech_users.sample, question: i) }
end

answers.each do |i|
  3.times { comments << FactoryGirl.create(:comment, content: Faker::Lorem.sentence, account: users.sample, commentable_id: i.id, commentable_type: 'Answer') }
end
