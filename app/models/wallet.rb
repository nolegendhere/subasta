class Wallet < ActiveRecord::Base
	belongs_to 	:user
	has_many 	:investments, dependent: :destroy
	
	validates :user_id, presence: true
	validates_numericality_of :initial_cash, :only_integer => true, presence: true
	validates_numericality_of :actual_cash, :only_integer => true, presence: true
end
