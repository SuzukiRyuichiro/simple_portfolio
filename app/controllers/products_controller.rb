class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def show
  end

  private

  def set_product
    @product = Product.find(params[:id])
    authorize @product
  end

  def product_params
    params.require(:product).permit(:name)
  end
end
