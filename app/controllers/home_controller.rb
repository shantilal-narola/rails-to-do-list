class HomeController < ApplicationController
  before_action :authenticate_user!

  def api_list
  end
end
