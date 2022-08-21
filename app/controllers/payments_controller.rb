class PaymentsController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    payments = if params[:loan_id].present?
                 Payment.where(loan_id: params[:loan_id]).all
               else
                 Payment.all
               end
    render json: payments
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      render json: payment, status: :created
    else
      render json: payment.errors.full_messages, status: :unprocessable_entity
    end
  rescue Exception => e
    render json: e.message, status: :unprocessable_entity
  end

  private

  def payment_params
    params.permit(:loan_id, :date, :amount)
  end
end
