every 1.day, at: '4:30 am' do
  rake 'db:label_bearbeitungsstand'
  rake 'db:expired_assignment'
  rake 'db:reminder_assignment'
end
