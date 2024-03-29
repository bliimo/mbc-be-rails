ActiveAdmin.register AdminUser do
  menu parent: 'Users'
  permit_params :email, :name, :role, :status, :password, :password_confirmation, :image, network_ids: []

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column :status
    column :networks
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

  before_save do |admin_user|
    if current_admin_user.admin?
      admin_user.role = "DJ"
    end
  end

  form do |f|
    if current_admin_user.super_admin?
      networks = Network.all
    else
      networks = Network.where(id: current_admin_user.network_ids)
    end
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :image, as: :file
      f.input :email
      f.input :name
      f.input :role if current_admin_user.super_admin?
      f.input :networks, :as => :select, :input_html => {:multiple => true}, member_label: :name, collection: networks if !current_admin_user.dj?
      f.input :status if !current_admin_user.dj?
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  
  show do
    panel admin_user.name do
      tabs do
        tab 'General' do
          columns do
            column span: 3 do
              attributes_table_for admin_user do
                row :id
                row :name
                row :role
                row :networks
                row :email
                row :status
              end
            end
            if admin_user.image.attached?
              column do
                image_tag admin_user.image, class: 'width-100'
              end
            end
          end
        end
      end
    end
  end

end
