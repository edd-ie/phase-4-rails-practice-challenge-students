class Student < ApplicationRecord
    belongs_to :instructor

    validates :name, :major, :age, :instructor_id, presence: true
    validates :age, numericality: { only_integer: true, 
        greater_than_or_equal_to: 18
    }
end
