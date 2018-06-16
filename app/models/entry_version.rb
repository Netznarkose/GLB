class EntryVersion < PaperTrail::Version

  scope :filter_versions_without_objects, -> { where.not(object: nil) }

  def user
    User.find_by(id: self.whodunnit) || User.new(name: 'Unbekannt')
  end
end
