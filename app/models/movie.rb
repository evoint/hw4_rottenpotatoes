class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.similar_movies(movie_id)
  	movie = Movie.find(movie_id)
    if (director = movie.director) != nil
    	movies = Movie.find_all_by_director(director)
    end
  end
end
