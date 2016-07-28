class ManagerSupervisorPolicy < ApplicationPolicy
  def index?
    supervisor?
  end

  def show?
    supervisor?
  end

  def create?
    supervisor?
  end

  def update?
    supervisor?
  end

  def destroy?
    supervisor?
  end

  def supervisor?
    user.supervisor?
  end

  def method_missing(method_sym, *arguments, &block)
    if /.+?/.match(method_sym)
      supervisor?
    end
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
