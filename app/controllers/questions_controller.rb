class QuestionsController < ApplicationController

  before_action :find_question!, only: %i[show edit update destroy]

  def index
    @pagy, @questions = pagy(Question.order(created_at: :desc), items: 10)
    @questions = @questions.decorate
    # @questions = Question.order(created_at: :desc).page params[:page] kaminary variation
  end

  def new
    @question = Question.new
  end

  def show
    @question = @question.decorate
    @answer = @question.answers.build
    # @answers = @question.answers.order(created_at: :desc).page(params[:page]).per(5) kaminary variation
    @pagy, @answers =  pagy(@question.answers.order(created_at: :desc), items: 5)
    @answers = @answers.decorate
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = "Question created!"
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @question.update(question_params)
      flash[:success] = "Question updated!"
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "Question deleted!"
    redirect_to questions_path
  end
  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question!
    @question = Question.find(params[:id])
  end
end