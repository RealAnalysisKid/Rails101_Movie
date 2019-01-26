class MoviesController < ApplicationController
  before_action :authenticate_user!, only:[:new, :create, :edit, :update, :destroy, :add, :remove]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @movies = Movie.all
  end

  def new
    @movie = Movie.new
  end

  def edit
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user

    if @movie.save
      redirect_to movies_path
    else
      render :new
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Movie Updated"
    else
      render :edit
    end
  end

  def destroy
    @movie.destroy
      redirect_to movies_path, alert: "Movie Deleted"
  end

  def add
    @movie = Movie.find(params[:id])
    if !current_user.is_favorite_of?(@movie)
      current_user.add!(@movie)
      flash[:notice] = "成功收藏电影！"
    else
      flash[:warning] = "已经收藏该电影！"
    end
    redirect_to movie_path(@movie)
  end

  def remove
    @movie = Movie.find(params[:id])
    if current_user.is_favorite_of?(@movie)
      current_user.remove!(@movie)
      flash[:alert] = "已取消收藏该电影！"
    else
      flash[:warning] = "没收藏该电影怎么取关 XD"
    end
    redirect_to movie_path(@movie)
  end

  private

  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])
    if current_user != @movie.user
      redirect_to root_path, alert: "You Have No Permission"
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description)
  end
end
