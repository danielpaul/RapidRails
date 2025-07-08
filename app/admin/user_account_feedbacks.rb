ActiveAdmin.register UserAccountFeedback do
  actions :all, except: %i[update destroy]
  menu parent: "Metadata", priority: 10

  index do
    selectable_column
    id_column
    column :user
    column :feedback
    column :created_at
    actions
  end

  filter :feedback
  filter :created_at
end
