class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]

  def index
    @pictures = Picture.all
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  def edit
    redirect_to pictures_path unless current_user.id == @picture.user_id
  end

  def create
    @picture = current_user.pictures.build(picture_params)

    respond_to do |format|
      if @picture.save
        PictureMailer.picture_mail(@picture).deliver
        format.html { redirect_to picture_url(@picture), notice: "Picture was successfully created." }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to picture_url(@picture), notice: "Picture was successfully updated." }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.id == @picture.user_id
      @picture.destroy
      redirect_to pictures_path, notice:"Picture was successfully destroyed"
    else
      redirect_to pictures_path
    end
  end

  private
    def set_picture
      @picture = Picture.find(params[:id])
    end

    def picture_params
      params.require(:picture).permit(:tittle, :image, :image_cache,)
    end
end
