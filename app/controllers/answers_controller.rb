# frozen_string_literal: true

class AnswersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :find_question!
  before_action :find_answer!, only: %i[edit update destroy]

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      flash[:success] = 'Answer created!'
      redirect_to question_path(@question)
    else
      @question = @question.decorate
      @pagy, @answers = pagy(@question.answers.order(created_at: :desc), items: 5)
      @answers = @answers.decorate
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = 'Answer destroy!'
    redirect_to question_path(@question)
  end

  def edit
    # render plain: params
  end

  def update
    if @answer.update(answer_params)
      flash[:success] = 'Answer updated!'
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      @answers = @question.answers.order created_at: :desc
      render :edit
    end
  end

  private

  def find_question!
    @question = Question.find(params[:question_id])
  end

  def find_answer!
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
