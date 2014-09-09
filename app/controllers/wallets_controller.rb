class WalletsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy,:edit, :update]
	before_action :admin_user, only: [:create,:destroy,:edit, :update]


	def new
		@user=User.find(params[:user_id])
		@wallet=Wallet.new(user: @user)
	end

	def create
	    @wallet = Wallet.new(wallet_params)
	    @user = User.find_by_id(wallet_params[:user_id])
	    if @wallet.save
	      	flash[:success] = "Wallet created for the user!"
	      	redirect_to @user
	    else
	      	render 'new'
	    end
    end

    def edit
		@wallet = Wallet.find(params[:id])
		@user = User.find(params[:user_id])
	end

	def update
		@wallet = Wallet.find(params[:id])
		@user = User.find_by(id: @wallet.user_id)
		if @wallet.update(wallet_params)
			flash[:success] = "Wallet updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		@wallet=Wallet.find(params[:id])
		@user = User.find_by(id: @wallet.user_id)
		@wallet.destroy
		redirect_to @user
	end

    def show
    	@wallet = Wallet.find(params[:id])
    	#@user = User.find_by(id: @wallet.user_id)
    	@user = User.find(params[:user_id])
  	end

    private

    	def wallet_params
      		params.require(:wallet).permit(:initial_cash, :actual_cash, :user_id)
      	end
end
