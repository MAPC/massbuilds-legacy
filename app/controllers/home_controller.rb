class HomeController < ApplicationController

  def index
    if signed_in?
      redirect_to :developments
    else
      render 'index.html', layout: false
    end
  end

end
