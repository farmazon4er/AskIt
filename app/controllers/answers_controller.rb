class AnswersController < ApplicationController
  before_action :find_question!

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      flash[:success] = "Answer created!"
      redirect_to question_path(@question)
    else
      @answers = @question.answers.order created_at: :desc
      render 'questions/show'
    end
  end

  def destroy
    answer = @question.answers.find(params[:id])
    answer.destroy
    flash[:success] = "Answer destroy!"
    redirect_to question_path(@question)
  end

  def edit
    # render plain: params
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.update(answer_params)
      flash[:success] = "Answer updated!"
      redirect_to question_path(@question)
    else
      @answers = @question.answers.order created_at: :desc
      render 'answers/edit'
    end
  end

  private

  def find_question!
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end