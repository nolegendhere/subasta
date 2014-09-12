class ChoicesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy,:edit, :update]
	before_action :admin_user, only: [:create,:destroy,:edit, :update]


	def new
		@user=User.find(params[:user_id])
		@choice=Choice.new(user: @user)
	end

	def create
	    @choice = Choice.new(choice_params)
	    @user = User.find_by_id(choice_params[:user_id])
	    if @choice.save
	      	flash[:success] = "Choice created for the user!"
	      	redirect_to @user
	    else
	      	render 'new'
	    end
    end

    def edit
		@choice = Choice.find(params[:id])
		@user = User.find(params[:user_id])
	end

	def update
		@choice = Choice.find(params[:id])
		@user = User.find_by(id: @choice.user_id)
		if @choice.update(choice_params)
			flash[:success] = "Choice updated"
			redirect_to auctions_url
		else
			render 'edit'
		end
	end

	def destroy
		@choice=Choice.find(params[:id])
		@user = User.find_by(id: @choice.user_id)
		@choice.destroy
		redirect_to @user
	end

    def show
    	@choice = Choice.find(params[:id])
    	#@user = User.find_by(id: @wallet.user_id)
    	@user = User.find(params[:user_id])
  	end

    private

    	def choice_params
      		params.require(:choice).permit(:all_objects,:pg, :sg, :sf, :pf, :ce, :team, :player, :max_amount, :min_amount, :max_time, :min_time,  :user_id)
      	end
end
