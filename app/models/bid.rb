class Bid < ActiveRecord::Base
	belongs_to :auction
	belongs_to :user
	has_many :investments, dependent: :destroy


	default_scope -> { order('created_at DESC') }
	scope :by_team, where(category: 'team')
	scope :by_player, where(category: 'player')
	scope :by_pg, where(subcategory: 'pg')
	scope :by_sg, where(subcategory: 'sg')
	scope :by_sf, where(subcategory: 'sf')
	scope :by_pf, where(subcategory: 'pf')
	scope :by_ce, where(subcategory: 'ce')



	validates :user_id, presence: true
	validates :auction_id, presence: true
	validates :name, presence: true
	validates :category, presence: true
	#validates :actual_amount_id, allow_nil: true
	#validates :subcategory, presence: true
	validates_numericality_of :price, :only_integer => true, presence: true
	validates_numericality_of :max_amount, :only_integer => true, presence: true
	validates_numericality_of :actual_amount, :only_integer => true, presence: true
end
