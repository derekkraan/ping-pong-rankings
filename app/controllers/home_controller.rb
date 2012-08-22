class HomeController < ApplicationController
  def index
    render layout: 'home'
  end

  def rankings
    render 'rankings', layout: 'application'
  end
end
