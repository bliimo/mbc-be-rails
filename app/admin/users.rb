ActiveAdmin.register User do
  menu parent: 'Users', label: "End Users"

  permit_params :email, 
                :username, 
                :contact_number, 
                :name, 
                :gender, 
                :birthday, 
                :role, 
                :status,
                :password,
                :password_confirmation,
                :image,
                :country,
                :region_id,
                :province_id,
                :city_id

    
  index do
    selectable_column
    id_column
    column :email
    column :username
    column :contact_number
    column :name
    column :gender
    column :birthday
    column :status do |user|
      status_tag user.status
    end
    actions
  end   
  
  form do |f|  
    f.semantic_errors *f.object.errors.keys
    f.input :image, as: :file

    f.input :username
    f.input :contact_number
    f.input :name
    f.input :email
    f.input :country, as: :string
    f.input :gender
    f.input :region
    f.input :province
    f.input :city
    f.input :birthday
    f.input :role
    f.input :status
    f.input :password
    f.input :password_confirmation
    f.actions
  end

  show do
    panel user.name do
      tabs do
        tab 'General' do
          columns do
            column span: 3 do
              attributes_table_for user do
                row :id
                row :email
                row :username 
                row :contact_number 
                row :name 
                row :gender 
                row :birthday 
                row :role 
                row :country
                row :region
                row :province
                row :city
                row :status do
                  status_tag user.status.present? ? user.status : 'Inactive'
                end
              end
            end
            if user.image.attached?
              column do
                image_tag user.image, class: 'width-100'
              end
            end
          end
        end

      end
    end
  end

end
