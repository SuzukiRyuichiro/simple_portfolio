class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def show
<<<<<<< HEAD
    @user = current_user
  #  authorize @user
    @share = Purchase.all.select{|purchase| purchase.product_id == @product.id}[0].shares
=======
    @articles = Polygon.new(@product.ticker).run
>>>>>>> master
  end

  def index
    if params[:query].present?
      @products = policy_scope(Product).search_by_name_and_ticker(params[:query])
    else
      @products = policy_scope(Product)
    end
<<<<<<< HEAD
    @products = @products.paginate(page: params[:page], per_page: 20)
    
=======
    @producs = policy_scope(@products)
>>>>>>> master
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
