class PurchasesController < ApplicationController

  def new
    @purchase = Purchase.new
    authorize @purchase
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = current_user
    authorize @purchase
    if @purchase.save
      BitFlyerOrderJob.perform_now(params, purchase_params) if params[:api_order] == 'bitflyer'
      redirect_to product_path(@purchase.product)
    else
      render 'fail'
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:shares, :date, :price_at_purchase, :product_id, :platform_id)
  end
end
