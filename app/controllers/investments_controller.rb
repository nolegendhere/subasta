class InvestmentsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy,:edit, :update]
	before_action :correct_user, only: [:destroy,:edit, :update]
	#before_action :correct_amount, only: [:create,:update]

  	def create
		@investment= Investment.create(investment_params)
		@investment.user_id = current_user.id
		#@bid=Bid.where( :id => @investment.bid_id).first
		@bid=Bid.find_by_id(investment_params[:bid_id])
		if  @investment.save
			if @investment.amount>@bid.max_amount && @investment.amount>@bid.price
				@bid.max_amount=@investment.amount
				@bid.actual_amount=@bid.actual_amount+1
				@bid.actual_amount_id=@investment.id
				@bid.save
				flash[:success] = "Investment made, you have made the larger amount"
				redirect_to auctions_url
			elsif @investment.amount<=@bid.max_amount && @investment.amount>@bid.actual_amount && @investment.amount>@bid.price
				@auctions = Auction.paginate(page: params[:page])
				@bid.actual_amount=@bid.actual_amount+1
				@bid.save
				flash.now[:error] = "you didn't make the larger amount"
				render 'auctions/index'
			elsif @investment.amount<=@bid.actual_amount && @investment.amount>@bid.price
				@auctions = Auction.paginate(page: params[:page])
				flash.now[:error] = "you didn't make the larger amount"
				render 'auctions/index'
			else
				@auctions = Auction.paginate(page: params[:page])
				flash.now[:error] = "your amount is inferior to the retail price"
				render 'auctions/index'  
			end
		else
			@auctions = Auction.paginate(page: params[:page])
			render 'auctions/index'
		end	
	end

	def update
		@investment = Investment.find(params[:id])
		@bid=Bid.find_by_id(investment_params[:bid_id])
		if @investment.update(investment_params)
			if @investment.amount>@bid.max_amount && @investment.amount>@bid.price
				@bid.max_amount=@investment.amount
				@bid.actual_amount=@bid.actual_amount+1
				@bid.actual_amount_id=@investment.id
				@bid.save
				flash[:success] = "Investment made, you have made the larger amount"
				redirect_to auctions_url
			elsif @investment.amount<=@bid.max_amount && @investment.amount>@bid.actual_amount && @investment.amount>@bid.price
				@auctions = Auction.paginate(page: params[:page])
				@bid.actual_amount=@bid.actual_amount+1
				@bid.save
				flash.now[:error] = "you didn't make the larger amount"
				render 'auctions/index'
			elsif @investment.amount<=@bid.actual_amount && @investment.amount>@bid.price
				@auctions = Auction.paginate(page: params[:page])
				flash.now[:error] = "you didn't make the larger amount"
				render 'auctions/index'
			else
				@auctions = Auction.paginate(page: params[:page])
				flash.now[:error] = "your amount is inferior to the retail price"
				render 'auctions/index' 
			end
		else
			@auctions = Auction.paginate(page: params[:page])
			render 'auctions/index'
		end
	end

	private

		def investment_params
			params.require(:investment).permit(:amount,:bid_id)
		end

		def correct_user
			@investment = current_user.investments.find_by(id: params[:id])
			redirect_to root_url if @investment.nil?
		end

		def admin?(user)
		    if not user.nil?
		      return user.admin
		    end
		    return false
	  	end
end
