class QuestionsController < ApplicationController
  layout "new_version_base"

  def ware
    ware = KcCourses::Ware.find params[:ware_id]

    questions = ware.questions.page(params[:page]).per(15)

    data = questions.map do |question|
      DataFormer.new(question)
        .url(:show_url)
        .url(:update_url)
        .url(:delete_url)
        .data
    end

    result = {
      questions: data,
      paginate: DataFormer.paginate_data(questions),
      create_url: questions_path
    }

    render json: result
  end

  def create
    question = QuestionMod::Question.new question_params
    question.creator = current_user
    _process_targetable(question)

    save_model(question) do |q|
      DataFormer.new(q)
        .url(:show_url)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def show
    question = QuestionMod::Question.find params[:id]
    @page_name = "question_show"
    @component_data = DataFormer.new(question)
      .url(:show_url)
      .url(:update_url)
      .url(:delete_url)
      .data
  end

  def update
    question = QuestionMod::Question.find params[:id]

    update_model(question, question_params) do |_question|
      DataFormer.new(_question)
        .url(:show_url)
        .url(:update_url)
        .url(:delete_url)
        .data
    end
  end

  def destroy
    question = QuestionMod::Question.find params[:id]
    question.destroy
    render :status => 200, :json => {:status => 'success'}
  end

  private
  def _process_targetable(question)
    if params[:ware_id].present?
      question.targetable = KcCourses::Ware.find params[:ware_id]
    end
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
