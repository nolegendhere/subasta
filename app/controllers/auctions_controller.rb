class AuctionsController < ApplicationController

	before_action :signed_in_user, only: [:create, :destroy,:edit, :update]
	#before_action :correct_user, only: [:destroy,:edit, :update]
	before_action :admin_user, only: [:create,:destroy,:edit, :update]
	
	def index
		@auctions = Auction.paginate(page: params[:page])
	end

	def create
		@auction = current_user.auctions.build(auction_params)
		if @auction.save
			flash[:success] = "Auction created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		Auction.find(params[:id]).destroy
		redirect_to root_url
	end

	def edit
		@auction = Auction.find(params[:id])
	end

	def update
		@auction = Auction.find(params[:id])
		if @auction.update(auction_params)
			flash[:success] = "Auction updated"
			redirect_to root_url
		else
			render 'edit'
		end
	end

	private

		def auction_params
			params.require(:auction).permit(:title,:content)
		end

		def correct_user
			@auction = current_user.auctions.find_by(id: params[:id])
			redirect_to root_url if @auction.nil?
		end
end
