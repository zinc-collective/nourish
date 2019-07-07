class PagesController < ApplicationController
  def show
    render params[:id]
  rescue ActionView::MissingTemplate => _
    render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
  end
end