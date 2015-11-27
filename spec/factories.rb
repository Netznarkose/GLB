#encoding: utf-8
FactoryGirl.define do

  factory :user do
    sequence(:email){|n| "editor_#{n}@example.com"}
    sequence(:name){|n| "editor#{n}"}
    password "anything"
    password_confirmation "anything"
  end

  factory :admin, parent: :user do
    role "admin"
  end

  factory :editor, parent: :user do
    role "editor"
  end

  factory :entry, class: Entry do
    user_id { FactoryGirl.create(:admin).id }
    namenskuerzel "ES"
    kennzahl "981:1"
    spaltenzahl "17"
    japanische_umschrift "chi {muchi}"
    kanji "癡 (無癡)"
    chinesisch "chi {wuchi}"
    deutsche_uebersetzung "Torheit, Dummheit {Nicht-Torheit}"
    uebersetzung "Torheit, Dummheit {Nicht-Torheit}"
  end

  factory :published_entry, parent: :entry do
    freigeschaltet true
  end

  factory :comment, class: Comment do
    entry {create :entry}
    user {create :editor}
    comment "Test comment!"
  end
end
