class Choice < ActiveRecord::Base
	belongs_to :user

	validates :user_id, presence: true
	validates_inclusion_of :all_objects, in: [true, false]
	validates_inclusion_of :team, in: [true, false]  
	validates_inclusion_of :player, in: [true, false]
	validates_inclusion_of :pg, in: [true, false]  
	validates_inclusion_of :sg, in: [true, false]  
	validates_inclusion_of :sf, in: [true, false]  
	validates_inclusion_of :pf, in: [true, false]  
	validates_inclusion_of :ce, in: [true, false]  
	validates_inclusion_of :max_amount, in: [true, false]  
	validates_inclusion_of :min_amount, in: [true, false]  
	validates_inclusion_of :max_time, in: [true, false]  
	validates_inclusion_of :min_time, in: [true, false]  
end
