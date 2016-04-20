module NoteFormer
  extend ActiveSupport::Concern

  included do
    former "NoteMod::Note" do
      field :id, ->(instance) {instance.id.to_s}
      field :title
      field :content
      field :creator, ->(instance) {
        DataFormer.new(instance.creator).data
      }
      field :created_at
      field :updated_at

      url :show_url, ->(instance){
        note_path(instance)
      }

      url :update_url, ->(instance){
        note_path(instance)
      }

      url :delete_url, ->(instance){
        note_path(instance)
      }
    end

  end
end
