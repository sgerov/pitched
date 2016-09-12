class Pitch < ApplicationRecord
  enum status: [:uploaded, :in_review, :reviewed]
end
