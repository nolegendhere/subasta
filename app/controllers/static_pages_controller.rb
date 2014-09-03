class StaticPagesController < ApplicationController
  def home
		if signed_in?
			@auction = current_user.auctions.build
			@feed_items = current_user.feed.paginate(page: params[:page])
		end
	end
end
