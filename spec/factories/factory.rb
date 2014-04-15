FactoryGirl.define do

  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.sequence(:email) { |n| "user#{n}@email.com" }
    f.password 'password'
    f.password_confirmation 'password'
  end

  factory :account do |f|
    f.sequence(:username) { |n| "username#{n}" }
    f.bio { Faker::Lorem.paragraph }
    f.avatar { Faker::Avatar.image }
    f.role :user
    f.association :user, factory: :user
  end

  factory :group do |f|
    f.sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
    f.code { Array(2..10).sample.times.map { Array('a'..'z').sample }.join('') }
    f.description { Faker::Company.bs }
  end

  factory :membership do |f|
    f.association :account, factory: :account
    f.association :group, factory: :group
    f.admin { [true, false].sample }
  end

  factory :question do |f|
    f.title { Faker::Lorem.sentence }
    f.content { Faker::Lorem.paragraph }
    f.public true
    f.association :account, factory: :account
    f.association :group, factory: :group
    f.accepted_answer nil
    f.tags { Array(1..4).sample.times.map { create :tag } }
  end

  factory :public_question, class: Question do |f|
    f.title { Faker::Lorem.sentence }
    f.content { Faker::Lorem.paragraph }
    f.public true
    f.association :account, factory: :account
    f.accepted_answer nil
    f.tags { Array(1..4).sample.times.map { create :tag } }
  end

  factory :tag do |f|
    f.sequence(:name) { |n| "tag#{n}" }
    f.description { Faker::Lorem.sentence }
  end

  factory :question_tag do |f|
    f.association :question, factory: :question
    f.association :tag, factory: :tag
  end

  factory :answer do |f|
    f.content { Faker::Lorem.sentence }
    f.association :account, factory: :account
    f.association :question, factory: :question
  end

  factory :category do |f|
    f.sequence(:name) { |n| "category#{n}" }
    f.sequence(:display_order) { |n| n }
  end

  factory :status do |f|
    f.sequence(:name) { |n| "status#{n}" }
    f.sequence(:display_order) { |n| n }
  end

  factory :priority do |f|
    f.sequence(:name) { |n| "priority#{n}" }
    f.sequence(:display_order) { |n| n }
  end

  factory :ticket do |f|
    f.subject { Faker::Lorem.sentence }
    f.content { Faker::Lorem.paragraph }
    f.association :account, factory: :account
    f.association :assignee, factory: :account
    f.association :category, factory: :category
    f.association :status, factory: :status
    f.association :priority, factory: :priority
  end

  factory :comment do |f|
    f.content { Faker::Lorem.sentence }
    f.association :account, factory: :account
    f.association :commentable, factory: :question
  end

  factory :account_params, class: Account do |f|
    f.sequence(:username) { |n| "username#{n}" }
    f.user_attributes {
      attributes_for :user
    }
  end

  factory :question_params, class: Question do |f|
    f.title { Faker::Lorem.sentence }
    f.content { Faker::Lorem.paragraph }
    f.public true
    f.accepted_answer nil
    f.tag_ids { Array(1..4).sample.times.map { create(:tag).id } }
  end

  factory :comment_params, class: Comment do |f|
    f.content {Faker::Lorem.sentence }
  end

  factory :answer_params, class: Answer do |f|
    f.content { Faker::Lorem.paragraph }
  end

end