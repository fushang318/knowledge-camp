class BusinessCategoriesPolicy < ApplicationPolicy
  def my?
    user.teller?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
