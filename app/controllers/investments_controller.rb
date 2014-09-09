class InvestmentsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy,:edit, :update]
	before_action :auth_requirements_one, only: :update
	before_action :admin_user, only: [:edit,:destroy]
	#before_action :correct_amount, only: [:create,:update]


	def create
		if current_user.investments.find_by(bid_id: investment_params[:bid_id]).nil?
			@investment= Investment.create(investment_params)
			@investment.user_id = current_user.id
			#@bid=Bid.where( :id => @investment.bid_id).first
			@bid=Bid.find_by_id(investment_params[:bid_id])
			@wallet= Wallet.find_by(user_id: current_user.id)
			@investment.wallet_id=@wallet.id
			if  @investment.save
				if (@wallet.actual_cash-@investment.amount)>=0
					if @investment.amount>@bid.max_amount && @investment.amount>=@bid.price
						if !Investment.find_by(id: @bid.actual_amount_id).nil?
							@otherinvestment = Investment.find_by(id: @bid.actual_amount_id)
							@otherwallet =  Wallet.find_by(id: @otherinvestment.wallet_id)
							@otherwallet.actual_cash=@otherwallet.actual_cash+@bid.max_amount
							@otherwallet.save
						end
						@bid.actual_amount=@bid.max_amount+1
						@bid.max_amount=@investment.amount
						@bid.actual_amount_id=@investment.id
						@bid.save
						@wallet.actual_cash=@wallet.actual_cash-@investment.amount
						@wallet.save 
						flash[:success] = "Investment made, you have made the larger amount"
						redirect_to auctions_url
					elsif @investment.amount<=@bid.max_amount && @investment.amount>@bid.actual_amount && @investment.amount>=@bid.price
						@auctions = Auction.paginate(page: params[:page])
						@bid.actual_amount=@investment.amount+1
						@bid.save
						flash.now[:error] = "you didn't make the larger amount"
						render 'auctions/index'
					elsif @investment.amount<=@bid.actual_amount && @investment.amount>=@bid.price
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
					flash.now[:error] = "you don't have enough cash"
					render 'auctions/index'
				end
			else
				@auctions = Auction.paginate(page: params[:page])
				render 'auctions/index'
			end
		else
			@auctions = Auction.paginate(page: params[:page])
			@investment=current_user.investments.find_by(bid_id: investment_params[:bid_id])
			@bid=Bid.find_by_id(investment_params[:bid_id])
			render 'auctions/index'
		end
	end


=begin
  	def create
		@investment= Investment.create(investment_params)
		@investment.user_id = current_user.id
		#@bid=Bid.where( :id => @investment.bid_id).first
		@bid=Bid.find_by_id(investment_params[:bid_id])
		@wallet= Wallet.find_by(user_id: current_user.id)
		@investment.wallet_id=@wallet.id
		if  @investment.save
			if (@wallet.actual_cash-@investment.amount)>=0
				if @investment.amount>@bid.max_amount && @investment.amount>@bid.price
					@bid.max_amount=@investment.amount
					@bid.actual_amount=@investment.amount
					@bid.actual_amount_id=@investment.id
					@bid.save
					@wallet.actual_cash=@wallet.actual_cash-@investment.amount
					@wallet.save 
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
				flash.now[:error] = "you don't have enough cash"
				render 'auctions/index'
			end
		else
			@auctions = Auction.paginate(page: params[:page])
			render 'auctions/index'
		end	
	end
=end


=begin
	def update
		@investment = Investment.find(params[:id])
		@bid=Bid.find_by_id(investment_params[:bid_id])
		@wallet= Wallet.find_by(user_id: current_user.id)
		if @investment.update(investment_params)
			if (@wallet.actual_cash-@investment.amount)>=0
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
				flash.now[:error] = "you don't have enough cash"
				render 'auctions/index'
			end
		else
			@auctions = Auction.paginate(page: params[:page])
			render 'auctions/index'
		end
	end
=end


	def update

		if admin?(current_user)
			@investment = Investment.find(params[:id])
			@bid=Bid.find_by(id: @investment.bid_id)
			@wallet= Wallet.find_by(id: @investment.wallet_id)
			if @investment.update(investment_params)
				if (@wallet.actual_cash-@investment.amount)>=0
					if @investment.amount>@bid.max_amount && @investment.amount>=@bid.price
						if @investment.id == @bid.actual_amount_id
							@wallet.actual_cash=@wallet.actual_cash-(@investment.amount-@bid.max_amount)
						elsif !@bid.actual_amount_id.nil?
							@wallet.actual_cash=@wallet.actual_cash-@investment.amount
							@otherinvestment = Investment.find_by(id: @bid.actual_amount_id)
							@otherwallet =  Wallet.find_by(id: @otherinvestment.wallet_id)
							@otherwallet.actual_cash=@otherwallet.actual_cash+@bid.max_amount
							@otherwallet.save
						else
							@wallet.actual_cash=@wallet.actual_cash-@investment.amount
						end
						@wallet.save
						@bid.actual_amount=@bid.max_amount+1
						@bid.max_amount=@investment.amount
						@bid.actual_amount_id=@investment.id
						@bid.save
						flash[:success] = "Investment update, is the largest amount"
						redirect_to auctions_url
					elsif @investment.amount<=@bid.max_amount && @investment.amount>@bid.actual_amount && @investment.amount>=@bid.price
						@bid.actual_amount=@investment.amount+1
						@bid.save
						flash[:succes] = "Investment update, but it isn't the largest amount"
						redirect_to auctions_url
					elsif @investment.amount<=@bid.actual_amount && @investment.amount>=@bid.price
						flash[:succes] = "Investment update, but it isn't the largest amount and it didn't rise the actual amount"
						redirect_to auctions_url
					else
						flash[:succes] = "Investment update, but the amount is inferior to the retail price"
						redirect_to auctions_url 
					end
				else
					flash.now[:error] = "Not enough cash"
					render 'edit'
				end
			else
				render 'edit'
			end
		else
			@investment = current_user.investments.find_by(bid_id: investment_params[:bid_id])
			@bid=Bid.find_by_id(investment_params[:bid_id])
			@wallet= Wallet.find_by(user_id: current_user.id)
			if @investment.update(investment_params)
				if (@wallet.actual_cash-@investment.amount)>=0
					if @investment.amount>@bid.max_amount && @investment.amount>=@bid.price
						if @investment.id == @bid.actual_amount_id
							@wallet.actual_cash=@wallet.actual_cash-(@investment.amount-@bid.max_amount)
						elsif !@bid.actual_amount_id.nil?
							@wallet.actual_cash=@wallet.actual_cash-@investment.amount
							@otherinvestment = Investment.find_by(id: @bid.actual_amount_id)
							@otherwallet =  Wallet.find_by(id: @otherinvestment.wallet_id)
							@otherwallet.actual_cash=@otherwallet.actual_cash+@bid.max_amount
							@otherwallet.save
						else
							@wallet.actual_cash=@wallet.actual_cash-@investment.amount
						end
						@wallet.save
						@bid.actual_amount=@bid.max_amount+1
						@bid.max_amount=@investment.amount
						@bid.actual_amount_id=@investment.id
						@bid.save
						flash[:success] = "Investment made, you have made the largest amount"
						redirect_to auctions_url
					elsif @investment.amount<=@bid.max_amount && @investment.amount>@bid.actual_amount && @investment.amount>=@bid.price
						@auctions = Auction.paginate(page: params[:page])
						@bid.actual_amount=@investment.amount+1
						@bid.save
						flash.now[:error] = "you didn't make the largest amount"
						render 'auctions/index'
					elsif @investment.amount<=@bid.actual_amount && @investment.amount>=@bid.price
						@auctions = Auction.paginate(page: params[:page])
						flash.now[:error] = "you didn't make the largest amount and it didn't rise the actual amount"
						render 'auctions/index'
					else
						@auctions = Auction.paginate(page: params[:page])
						flash.now[:error] = "your amount is inferior to the retail price"
						render 'auctions/index' 
					end
				else
					@auctions = Auction.paginate(page: params[:page])
					flash.now[:error] = "you don't have enough cash"
					render 'auctions/index'
				end
			else
				@auctions = Auction.paginate(page: params[:page])
				render 'auctions/index'
			end
		end
	end

	def edit
		@investment = Investment.find(params[:id])
	end

	def destroy
		@investment=Investment.find(params[:id])
		@wallet= Wallet.find_by(user_id: current_user.id)
		@bid=Bid.find_by(id: @investment.bid_id)

		if @investment.id == @bid.actual_amount_id
			@wallet.actual_cash=@wallet.actual_cash+@bid.max_amount
		end
		@wallet.save

		@bid.max_amount=@bid.price
		@bid.actual_amount=@bid.price
		@bid.actual_amount_id=nil
		@bid.save
		if @bid.actual_amount_id.nil?
			flash[:success] = "Investment erased"
		end
		@investment.destroy

		redirect_to auctions_url
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

	  	def auth_requirements_one
        @actualuser = User.find(params[:id])
        if admin?(current_user) || current_user?(@actualuser)
          return true
        else
          redirect_to root_url
        end
      end
end
