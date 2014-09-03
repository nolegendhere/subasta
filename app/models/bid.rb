class Bid < ActiveRecord::Base
	belongs_to :auction
	belongs_to :user

	validates :user_id, presence: true
	validates :auction_id, presence: true
end
