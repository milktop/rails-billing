module PaymentsHelper

  def payment_options client: nil
    payment_methods = Payment.translated_payment_methods

    unless client && client.available_credits.any?
      payment_methods.pop
    end

    payment_methods.map do |label, key, _value|
      [label, key]
    end
  end
  
end
