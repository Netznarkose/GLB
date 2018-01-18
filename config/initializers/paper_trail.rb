PaperTrail::Rails::Engine.eager_load!
PaperTrail.config.track_associations = false
module PaperTrail
  class Version < ActiveRecord::Base
    def user_name
      # User.find self.whodunnit.to_i
      User.find(self.whodunnit).name rescue nil
    end
  end
end
