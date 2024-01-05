class CreditNotesController < ApplicationController

  def index
    @credit_notes = CreditNote.order date: :desc
  end
  
  def show
    @credit_note = CreditNote.find params[:id]
  end
  
  def new
  end

  def create
    @invoice = Invoice.find_by id: params[:invoice_id]
    if @invoice
      credit_note = @invoice.issue_credit_note!
      if credit_note
        redirect_to credit_note, notice: "Credit note created successfully"
      else
        redirect_back_or_to @invoice, alert: "Credit note could not be created"
      end
    else
      credit_note = CreditNote.new credit_note_params
      if credit_note.save
        redirect_to credit_note, notice: "Credit note created successfully"
      else
        render :new
      end
    end
  end

  private

  def credit_note_params
    params.require(:credit_note).permit(:client_id, :clinic_id, :date, :description)
  end
  
end
