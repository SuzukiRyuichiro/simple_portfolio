class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @purchases = current_user.purchases
    @products = @user.products
    authorize @user

  end
end
