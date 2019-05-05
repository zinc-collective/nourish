class HomeController < ApplicationController
  def index

  end

  helper_method def communities
    Community.all
  end
end