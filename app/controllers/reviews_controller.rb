class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :create, :destroy]
  before_action :find_review_and_check_permission, only: [:edit, :update, :destroy]

  def new
    @movie = Movie.find(params[:movie_id])
    @review = Review.new
  end

  def edit
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.movie = @movie

    if @review.save
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to movie_path(@movie), notice:"Review Updated"
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
      redirect_to movie_path(@movie), alert: "Review Deleted"
  end

  private

  def find_review_and_check_permission
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])

    if current_user != @review.user
      redirect_to root_path, alert:"You Have No Permission"
    end
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
