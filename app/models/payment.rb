class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :date, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  after_validation :check_payment_for_loan

  after_create_commit :calculate_outstanding_balance_when_create
  before_destroy :calculate_outstanding_balance_when_destroy

  def check_payment_for_loan
    errors[:base] << 'A payment should not be able to be created that exceeds the outstanding balance of a loan.' if (loan.payments.sum(:amount) + self.amount) > loan.funded_amount
  end

  def calculate_outstanding_balance_when_create
    loan.update(outstanding_balance: (loan.outstanding_balance - self.amount))
  end

  def calculate_outstanding_balance_when_destroy
    loan.update(outstanding_balance: (loan.outstanding_balance + self.amount))
  end
end
