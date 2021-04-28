module DashboardHelper
  def get_margin(purchases, current_price)
    @margin = purchases.sum do |purchase|
      purchase.margin_at(current_price)
    end
  end

  def format_number(number)
    if number.positive?
      "+$#{number_with_delimiter(sprintf("%.2f", number))}"
    else
      "-$#{number_with_delimiter(sprintf("%.2f", number.abs))}"
    end
  end

  def format_number_to_price(number)
    "$#{number_with_delimiter(sprintf("%.2f", number))}"
  end

end
