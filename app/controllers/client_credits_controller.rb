class ClientCreditsController < ApplicationController

  def index
    @client_credits = ClientCredit.order date: :desc  
  end

  def show
    @client_credit = ClientCredit.find params[:id]
  end

end
