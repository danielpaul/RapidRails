ActiveAdmin.register User do
  menu priority: 1
  actions :all, except: [:destroy]

  permit_params :email, :password, :password_confirmation, :full_name

  scope :all, default: true
  scope("Active") { |users| users.where(discarded_at: nil) }
  scope("Onboarded") { |users| users.where.not(onboarding_completed_at: nil) }
  scope("Not Onboarded") { |users| users.where(onboarding_completed_at: nil) }
  scope("Deleted") { |users| users.where.not(discarded_at: nil) }

  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :full_name
  filter :email
  filter :onboarding_completed_at
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :full_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  member_action :discard, method: :put do
    resource.discard
    redirect_to resource_path, notice: "User discarded"
  end

  member_action :undiscard, method: :put do
    resource.undiscard
    redirect_to resource_path, notice: "User restored"
  end

  action_item :discard, only: :show do
    if resource.discarded_at
      link_to "Restore User", undiscard_admin_user_path(resource), method: :put, class: "action-item-button"
    else
      link_to "Discard User", discard_admin_user_path(resource), method: :put, class: "action-item-button"
    end
  end
end
