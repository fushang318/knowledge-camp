module UserFormer
  extend ActiveSupport::Concern

  included do

    former "User" do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :email
      field :created_at
      field :updated_at
      field :avatar, ->(instance){
        {
          url: "/assets/default_avatars/avatar_200.png",
          large:{ url: "/assets/default_avatars/large.png"},
          normal:{ url: "/assets/default_avatars/normal.png"},
          small:{ url: "/assets/default_avatars/small.png"}
        }
      }

      logic :role, ->(instance) {
        instance.role
      }

      logic :phone_number, ->(instance){
        instance.phone_number
      }

      logic :read_percent, ->(instance){
        instance.read_percent
      }

      logic :post, ->(instance){
        post = instance.post
        {
          id: post.id.to_s,
          name: post.name
        }
      }

      url :user_dashboard_url, ->(instance) {
        user_dashboard_path
      }

      url :manager_supervisors_edit_url, ->(instance) {
        edit_manager_supervisor_path(instance)
      }

      url :supervisor_teller_show_url, ->(instance) {
        manager_supervisor_teller_path(instance)
      }

    end

  end
end
