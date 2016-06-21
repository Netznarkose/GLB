class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.chief_editor?
      can :index, User
      can :manage, Entry 
      can :edit, Comment
      can :create, Comment
      can :update, Comment do |comment| # Chiefeditor updates only own comments 
        comment.try(:user) == user
      end
      can :destroy, Comment
    elsif user.author?
      can :index, User
      can :index, Entry
      can :show, Entry
      can :new, Entry
      can :edit, Entry
      can :create, Entry do |entry| # Editor creates an entry only for herself
        entry.user_id == user.id
      end
      can :update, Entry do |entry| # Editor updates only own entries
        entry.user_id == user.id
      end
      can :destroy, Entry do |entry| # Editor deletes only own entries
        entry.user_id == user.id
      end
      can :edit, Comment
      can :create, Comment
      can :update, Comment do |comment| # Editor updates only own comments
        comment.try(:user) == user
      end
      can :destroy, Comment do |comment| # Editor deletes only own comments
        comment.try(:user) == user
      end
    elsif user.commentator?
      can :index, Entry
      can :show, Entry do |entry| # Commentator sees only pubished entries
        entry.freigeschaltet
      end
      can :create, Comment
      can :update, Comment do |comment| # Commentator updates only own entries
        comment.try(:user) == user
      end
      can :destroy, Comment do |comment| # Commentator deletes only own entries
        comment.try(:user) == user
      end
      can :edit, Comment
    else
      can :index, Entry
      can :show, Entry do |entry| # Guests sees only pubished entries
        entry.freigeschaltet
      end
    end
  end
end
