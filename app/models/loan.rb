class Loan < ActiveRecord::Base
  has_many :payments

  before_create :assign_outstanding_balance

  def assign_outstanding_balance
    self.outstanding_balance = self.funded_amount
  end
end
