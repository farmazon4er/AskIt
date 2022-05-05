class Question < ApplicationRecord
  validates :title, :body, presence: :true, length: { minimum: 2}

  def formated_created_at
    created_at.strftime('%Y-%m-%d %H-%M-%S')
  end
end
