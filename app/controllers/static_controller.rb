class StaticController < ApplicationController
  def home
    render json: { status: "Blog APP running!" }
  end
end
