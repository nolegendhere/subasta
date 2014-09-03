class Bid < ActiveRecord::Base
	belongs_to :auction
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :auction_id, presence: true
	validates :name, presence: true
	validates :category, presence: true
	#validates :subcategory, presence: true
	validates_numericality_of :price, :only_integer => true, presence: true
end
