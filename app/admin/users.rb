ActiveAdmin.register User do
  menu parent: 'Users', label: "End Users"

  permit_params :email, 
                :username, 
                :contact_number, 
                :first_name, 
                :last_name, 
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

  member_action :verify, method: :post do
    resource.verified_at = DateTime.now
    resource.save
    redirect_to resource_path, notice: "Verified"
  end
  
  member_action :unverify, method: :post do
    resource.verified_at = nil
    resource.save
    redirect_to resource_path, notice: "Unveried"
  end

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :contact_number
    column "Name", :first_name do |user|
      user.name
    end
    column :gender
    column :birthday
    column :login_type do |user|
      status_tag user.login_type
    end
    column :verified do |user|
      status_tag user.verified?
    end
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
    f.input :first_name
    f.input :last_name
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
                row :first_name 
                row :last_name 
                row :gender 
                row :birthday 
                row :role 
                row :country
                row :region
                row :province
                row :city
                row :verified_at do 
                  div do
                    if user.verified_at.present?
                      status_tag user.verified?
                      a "Unverify", href: unverify_admin_user_path(user.id), "data-method": :post, rel: 'nofollow', class: 'text-danger'
                    else
                      status_tag user.verified?
                      a "Verify", href: verify_admin_user_path(user.id), "data-method": :post, rel: 'nofollow', class: 'text-success'
                    end
                  end
                end
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
