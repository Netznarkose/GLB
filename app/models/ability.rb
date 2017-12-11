class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.editor?
      can :index, User
      can :manage, Entry
      can :manage, Comment
      can :destroy, Task
    elsif user.author?
      can :index, User
      can [:index,:show, :new], Entry
      can [:edit, :update, :create, :destroy], Entry do |entry| # Author updates only own entries
        entry.user_id == user.id
      end
      can :create, Comment
      can [:edit, :update, :destroy], Comment do |comment|
        comment.user_id == user.id
      end
    elsif user.commentator?
      can :index, Entry
      can :show, Entry do |entry| # Commentator sees only pubished entries
        entry.freigeschaltet
      end
      can :create, Comment
      can [:edit, :update, :destroy], Comment do |comment|
        comment.user_id == user.id
      end
    else
      can :index, Entry
      can :show, Entry do |entry| # Guests sees only pubished entries
        entry.freigeschaltet
      end
    end
  end
end
