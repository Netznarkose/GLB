class ConvertUlrichToSuperuser < ActiveRecord::Migration
  def up
    user = User.find_by_email('ulrich.apel@uni-tuebingen.de')
    user.update_attributes(role: 'superadmin')
  end
  def down
    user = User.find_by_email('ulrich.apel@uni-tuebingen.de')
    user.update_attributes(role: 'admin')
  end
end
