class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def show
   
  end

  def index
    if params[:query].present?
      @products = Product.search_by_name_and_ticker(params[:query])
    else
      @products = Product.all
    end
    @producs = policy_scope(@products)
    
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
