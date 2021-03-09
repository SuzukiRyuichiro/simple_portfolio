class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def dashboard?
    true
  end

  def connect_to_bitflyer?
    update?
  end

  def update?
    record == user
  end
end
