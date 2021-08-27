ActiveAdmin.register AdminUser do
  menu parent: 'Users'
  permit_params :email, :name, :role, :status, :password, :password_confirmation, :image

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :status
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select
  filter :status, as: :select
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :image, as: :file
      f.input :email
      f.input :name
      f.input :role
      f.input :status
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
