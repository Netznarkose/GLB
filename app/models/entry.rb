class Entry < ActiveRecord::Base
  include Label
  include Validations
  include Search
  include Params
  include Assignable
  has_paper_trail class_name: 'EntryVersion'

  belongs_to :user
  has_many :comments
  has_many :entry_docs
  has_many :entry_htmls

  before_save :cleanup
  before_destroy :destroy_related_assignment

  scope :published, -> { where(freigeschaltet: true) }

  def cleanup
    substituter = Substituter.new
    self.romaji_order = substituter.substitute(japanische_umschrift).downcase if japanische_umschrift
  end
end
