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
			if @investment.amount>@bid.max_amount
				@bid.max_amount=@investment.amount
				@bid.actual_amount=@investment.amount
				@bid.actual_amount_id=@investment.id
				@bid.save
				flash[:success] = "Investment made, you have made the larger amount"
				redirect_to auctions_url
			elsif @investment.amount<=@bid.max_amount && @investment.amount>@bid.actual_amount
				@bid.actual_amount=@investment.amount
				@bid.save
				flash[:success] = "you didn't make the larger amount"
				redirect_to auctions_url
			else @investment.amount<=@bid.actual_amount
				@auctions = Auction.paginate(page: params[:page])
				flash[:success] = "you didn't make the larger amount"
				redirect_to auctions_url 
			end
		else
			@auctions = Auction.paginate(page: params[:page])
			render 'auctions/index'
		end
	end

#	def update
		#@bid = Bid.find(params[:id])
		#if @bid.update(bid_params)
		#	flash[:success] = "Bid updated"
		#	redirect_to auctions_url
		#else
		#	render 'edit'
		#end
#	end

	private

		def investment_params
			params.require(:investment).permit(:amount,:bid_id)
		end

		def correct_user
			@investment = current_user.investments.find_by(id: params[:id])
			redirect_to root_url if @investment.nil?
		end

		#def correct_amount
		#	@actual_amout=
		#	@amount=investment_params[:amount]

		#	if 

		#end

		def admin?(user)
		    if not user.nil?
		      return user.admin
		    end
		    return false
	  	end
end
