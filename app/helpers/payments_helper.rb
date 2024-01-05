module PaymentsHelper

  def payment_options
    Payment.translated_payment_methods.map do |label, key, _value|
      [label, key]
    end
  end
  
end
