#encoding: utf-8
FactoryGirl.define do

  factory :user do
    sequence(:email){|n| "normal_user#{n}@example.com"}
    sequence(:name){|n| "normal_user#{n}"}
    password "anything"
    password_confirmation "anything"
    role "user"
  end

  factory :admin, parent: :user do
    role "admin"
    sequence(:email){|n| "admin_#{n}@example.com"}
    sequence(:name){|n| "admin#{n}"}
  end

  factory :editor, parent: :user do
    sequence(:email){|n| "editor_#{n}@example.com"}
    sequence(:name){|n| "editor#{n}"}
    role "editor"
  end

  factory :author, parent: :user do
    sequence(:email){|n| "editor_#{n}@example.com"}
    sequence(:name){|n| "editor#{n}"}
    role "author"
  end

  factory :commentator, parent: :user do
    sequence(:email){|n| "commentator_#{n}@example.com"}
    sequence(:name){|n| "commentator#{n}"}
    role "commentator"
  end

  factory :guest, parent: :user do
    role "guest"
  end




  factory :entry, class: Entry do
    user_id { FactoryGirl.create(:admin).id }
    kennzahl "981:1"
    japanische_umschrift "chi {muchi}"
    deutsche_uebersetzung "Torheit, Dummheit {Nicht-Torheit}"
  end


  factory :published_entry, parent: :entry do
    freigeschaltet true
  end

  factory :comment, class: Comment do
    user_id { FactoryGirl.create(:admin).id }
    entry_id { FactoryGirl.create(:entry).id }
    comment "Test comment!"
  end
end
