class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def show
    @user = current_user
  #  authorize @user
    @purchases = current_user.purchases.where(product: @product)
    @articles = Polygon.new(@product.ticker).run
  end

  def index
    if params[:query].present?
      @products = policy_scope(Product).search_by_name_and_ticker(params[:query])
    else
      @products = policy_scope(Product)
    end
    @products = @products.paginate(page: params[:page], per_page: 20)
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
