# frozen_string_literal: true

class AnswerDecorator < Draper::Decorator
  delegate_all

  def formated_created_at
    created_at.strftime('%Y-%m-%d %H-%M-%S')
  end
end
