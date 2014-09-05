class BidsController < ApplicationController
   	before_action :signed_in_user, only: [:create, :destroy,:edit, :update]
	#before_action :correct_user, only: [:destroy,:edit, :update]
	#before_action :auth_requirements_one, only: [:create,:destroy,:edit, :update]
	before_action :admin_user, only: [:create,:destroy,:edit, :update]
	
	def create
		@bid= Bid.create(bid_params)
		@bid.actual_amount=@bid.price
		@bid.max_amount=@bid.price
		@bid.user_id = current_user.id
		if @bid.save
			flash[:success] = "Bid created!"
			redirect_to auctions_url
		else
			@auctions = Auction.paginate(page: params[:page])
			#@investment = current_user.investments.build
			render 'auctions/index'
		end
	end

	def destroy
		Bid.find(params[:id]).destroy
		redirect_to auctions_url
	end

	def index
	end

	def edit
		@bid = Bid.find(params[:id])
	end

	def update
		@bid = Bid.find(params[:id])
		if @bid.update(bid_params)
			flash[:success] = "Bid updated"
			redirect_to auctions_url
		else
			render 'edit'
		end
	end

	private

		def bid_params
			params.require(:bid).permit(:name,:category,:subcategory,:price,:auction_id)
		end

		def correct_user
			@bid = current_user.bids.find_by(id: params[:id])
			redirect_to root_url if @bid.nil?
		end

		def admin?(user)
		    if not user.nil?
		      return user.admin
		    end
		    return false
	  	end

#		def auth_requirements_one
#			@biduser = current_user.bids.find_by(id: params[:id])
#			if admin?(current_user) || current_user?(@biduser)
#				return true
#			else
#				redirect_to root_url
#			end
#		end
end
