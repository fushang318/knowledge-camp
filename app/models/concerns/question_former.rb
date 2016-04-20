module QuestionFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionMod::Question" do
      field :id, ->(instance) {instance.id.to_s}
      field :title
      field :content
      field :answered
      field :creator, ->(instance) {
        DataFormer.new(instance.creator).data
      }
      field :created_at
      field :updated_at

      url :show_url, ->(instance){
        question_path(instance)
      }

      url :update_url, ->(instance){
        question_path(instance)
      }

      url :delete_url, ->(instance){
        question_path(instance)
      }
    end

  end
end
