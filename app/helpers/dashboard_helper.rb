module DashboardHelper
  def get_margin(purchases, price)
    @margin = purchases.sum do |purchase|
      purchase.margin_at(price)
    end.round(2)
  end

  def format_number(number)
    if number.positive?
      "+$#{number_with_delimiter(sprintf("%.2f", number))}"
    else
      "-$#{number_with_delimiter(sprintf("%.2f", number))}"
    end
  end

end
