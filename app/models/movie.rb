class Movie < ActiveRecord::Base
    def self.get_ratings
    self.distinct.pluck(:rating)
    end
end
