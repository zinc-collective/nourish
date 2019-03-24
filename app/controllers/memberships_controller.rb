class MembershipsController < ApplicationController
  def new
    @community = Community.find_by(slug: params[:community_id])
    render file: 'public/404.html' , status: :not_found unless @community
  end

  def create

  end
end
