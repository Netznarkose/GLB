class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.chief_editor?
      can :index, User
      can :create, Entry # create for herself and somebody else
      can :update, Entry
      can :destroy, Entry
      can :show, Entry
      can :new, Entry
      can :edit, Entry
      can :index, Entry
      can :create, Comment
      can :update, Comment
      can :destroy, Comment
      can :edit, Comment
    elsif user.editor?
      can :index, User
      can :create, Entry
      can :update, Entry
      can :destroy, Entry
      can :show, Entry
      can :new, Entry
      can :edit, Entry
      can :index, Entry
      can :create, Comment
      can :update, Comment
      can :destroy, Comment
      can :edit, Comment
    elsif user.commentator?
      can :show, Entry
      can :index, Entry
      can :create, Comment
      can :update, Comment
      can :destroy, Comment
      can :edit, Comment
    else
      can :show, Entry
      can :index, Entry
    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
