class HomeController < ApplicationController

  def index
    if signed_in?
      redirect_to :developments
    else
      redirect_to page_path('home')
    end
  end

end
