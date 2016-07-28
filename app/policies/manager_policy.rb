class ManagerPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? and scope.where(:id => record.id).exists?
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def admin?
    user.admin?
  end

  def supervisor?
    user.supervisor?
  end

  def method_missing(method_sym, *arguments, &block)
    if /.+?/.match(method_sym)
      admin?
    end
  end
end
