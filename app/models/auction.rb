class Auction < ActiveRecord::Base
	belongs_to :user
	has_many :bids, dependent: :destroy
	default_scope -> { order('created_at DESC') }
	validates :title, presence: true
	validates :user_id, presence: true
end
