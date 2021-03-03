class UsersController < ApplicationController

  def dashboard
    @puchases = current_user.purchases
  end
end
