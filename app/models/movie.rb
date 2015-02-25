class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director
  def self.ratings
    ['G','PG','PG-13','R','NC-17']
  end

  def self.under_same_director(director)
    Movie.where(:director => director)
  end
end
