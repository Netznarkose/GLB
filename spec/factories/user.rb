FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "normal_user#{n}@example.com" }
    sequence(:name) { |n| "normal_user#{n}" }
    password 'anything'
    password_confirmation 'anything'
    role 'user'
  end

  factory :admin, parent: :user do
    role 'admin'
    sequence(:email) { |n| "admin_#{n}@example.com" }
    sequence(:name) { |n| "admin#{n}" }
  end

  factory :editor, parent: :user do
    sequence(:email) { |n| "editor_#{n}@example.com" }
    sequence(:name) { |n| "editor#{n}" }
    role 'editor'
  end

  factory :author, parent: :user do
    sequence(:email) { |n| "author#{n}@example.com" }
    sequence(:name) { |n| "author#{n}" }
    role 'author'
  end

  factory :commentator, parent: :user do
    sequence(:email) { |n| "commentator_#{n}@example.com" }
    sequence(:name) { |n| "commentator#{n}" }
    role 'commentator'
  end

  factory :guest, parent: :user do
    role 'guest'
  end
end
