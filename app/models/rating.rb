class Rating < ApplicationRecord
  belongs_to :picture, touch: true, counter_cache: true

  validates :score, inclusion: { in: 1..5 }
end
