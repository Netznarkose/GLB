class ConvertUlrichToSuperuser < ActiveRecord::Migration
  def up
    user = User.find_by_email('ulrich.apel@uni-tuebingen.de')
    user.update_attributes(role: 'superadmin') if user
  end
  def down
    user = User.find_by_email('ulrich.apel@uni-tuebingen.de')
    user.update_attributes(role: 'admin') if user
  end
end
