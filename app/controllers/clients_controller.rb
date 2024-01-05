class ClientsController < ApplicationController

  def index
    @clients = Client.order :name
  end

  def show
    @client = Client.find params[:id]
  end
  
end
