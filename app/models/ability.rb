class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.editor?
      can :index, User
      can :manage, Entry 
      can :edit, Comment 
      can :create, Comment
      can :update, Comment 
      can :destroy, Comment
    elsif user.author?
      can :index, User
      can :index, Entry
      can :show, Entry
      can :new, Entry
      can :edit, Entry
      can :create, Entry do |entry| # Author creates an entry only for herself
        entry.user_id == user.id
      end
      can :update, Entry do |entry| # Author updates only own entries
        entry.user_id == user.id
      end
      can :destroy, Entry do |entry| # Author deletes only own entries
        entry.user_id == user.id
      end
      can :create, Comment
      can :edit, Comment do |comment| 
        comment.try(:user) == user
      end
      can :update, Comment do |comment| # Author updates only own comments
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
      can :edit, Comment do |comment| 
        comment.try(:user) == user
      end
      can :update, Comment do |comment| # Commentator updates only own entries
        comment.try(:user) == user
      end
      can :destroy, Comment do |comment| # Commentator deletes only own entries
        comment.try(:user) == user
      end
    else
      can :index, Entry
      can :show, Entry do |entry| # Guests sees only pubished entries
        entry.freigeschaltet
      end
    end
  end
end
