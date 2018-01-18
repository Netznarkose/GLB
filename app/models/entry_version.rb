class EntryVersion < PaperTrail::Version
  def user_name
    User.find(self.whodunnit).name rescue nil
  end
end
