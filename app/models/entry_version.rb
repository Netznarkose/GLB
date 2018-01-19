class EntryVersion < PaperTrail::Version
  def user_name
    User.all.map { |user| user.id == whodunnit.to_i ? user.name : nil }.first
  end
end
