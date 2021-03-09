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
      redirect_to dashboard_path
    else
      render :new
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:shares, :date, :price_at_purchase, :product_id, :platform_id)
  end
end
