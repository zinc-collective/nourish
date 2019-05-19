class HomeController < ApplicationController
  def index
    @nourish_community = Community.find_by(slug: 'nourish')
  end

  helper_method def communities
    Community.all
  end
end