class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @movie = Movie.find(params[:movie_id])
    @review = Review.new
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.movie = @movie
    
    if @review.save
      redirect_to movie_path(movie)
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end
end
