class ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  # layout "words"
  # layout :user_layout
  def index
    render :layout => "words"
  end

  def new
    image = Image.new
    image.width = params[:width]
    image.height = params[:height]
    image.remote_image_url = params[:remote_image_url]
    image.save
    render json: {"url" => image.image_url(:thumb)}
  end

  def check
    result = AfterTheDeadline.check params[:words]
    render json: result
  end

  protected

  def user_layout
    if current_user.admin?
      "words"
    else
      "application"
    end
  end
end
