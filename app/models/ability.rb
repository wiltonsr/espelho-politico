#This class verifys the roles for each user and limits their access.

class Ability
  include CanCan::Ability
   def initialize(user)
    
    user ||= User.new #guest user

    # if user.current_user.admin? :user
    #   can :create, Atendimento
    # end

    # if user.admin? :admin
    #   can :manage, :all
    # end
  end
end