class ConsultationsController < ApplicationController

  def index
    @consultations = Consultation.order(date: :desc)
  end

  def show
    @consultation = Consultation.find params[:id]
    @act_item = ActItem.new resource: @consultation
    @product_item = ProductItem.new resource: @consultation
  end

  def new
    @consultation = Consultation.new
  end
  
  def create
    @consultation = Consultation.new consultation_params
    if @consultation.save
      redirect_to @consultation, notice: "Consultation created"
    else
      render :new
    end
  end

  private

  def consultation_params
    params.require(:consultation).permit(:date, :client_id, :clinic_id, :motive)
  end
  
end
