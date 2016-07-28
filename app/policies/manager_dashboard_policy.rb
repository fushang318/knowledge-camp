class ManagerDashboardPolicy < ManagerPolicy
  def index?
    admin? or supervisor?
  end
end
