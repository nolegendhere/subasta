class Investment < ActiveRecord::Base
	belongs_to :user
	belongs_to :bid
	belongs_to :wallet

	validates_numericality_of :amount, :only_integer => true, presence: true
	validates :user_id, presence: true
	validates :bid_id, presence: true

	#before_create :correct_amount

end
