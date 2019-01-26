class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :movies
  has_many :reviews
  has_many :movie_favorites
  has_many :fancied_movies, through: :movie_favorites, source: :movie

  def is_favorite_of?(movie)
    favorite_movie.include?(@movie)
  end
end
