class EntryVersion < PaperTrail::Version

  scope :filter_versions_without_objects, -> { where.not(object: nil) }
  def user_name
    User.all.map { |user| user.id == whodunnit.to_i ? user.name : nil }.first
  end
end
