# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :body
      t.belongs_to :question, null: false, foreign_keys: true

      t.timestamps
    end
  end
end
