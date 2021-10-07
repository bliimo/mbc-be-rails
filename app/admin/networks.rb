ActiveAdmin.register Network do
  menu parent: ["Stations"], priority: 1

  permit_params :name, 
                :admin_user_id, 
                :image, 
                :background_color, 
                admin_user_ids: [],
                radio_stations_attributes: [
                  :id,
                  :image,
                  :city_id,
                  :name,
                  :description,
                  :frequency,
                  :audio_streaming_link,
                  :video_string_link,
                  :status,
                  :admin_user_id,
                  :_destroy
                ]

  form do |f|
    f.semantic_errors *f.object.errors.keys
    tabs do
      tab 'Network' do

          f.input :image, as: :file
          f.input :name
          f.input :background_color
          f.input :admin_users, :as => :select, :input_html => {:multiple => true}, member_label: :name, collection: AdminUser.Admin

      end
      tab 'Radio stations' do
        f.has_many :radio_stations,
        new_record: 'Add Station',
        remove_record: 'Remove Station',
        allow_destroy: ->(_u) { current_admin_user.present? } do |b|
          b.input :image, as: :file
          b.input :city, input_html: {class: 'station_city_select'}
          b.input :name
          b.input :description, input_html: { rows: "2" }
          b.input :frequency
          b.input :audio_streaming_link
          b.input :video_string_link
          b.input :status
          b.input :admin_user, label: 'DJ'
        end
      end
    end
    f.actions
  end

  show do 
    panel network.name do
      tabs do
        tab 'General' do
          if network.image.attached?
              img src: url_for(network.image), style: 'width: 300px; margin: 16px auto; display: block'
          end
          columns do
            column span: 3 do
              attributes_table_for network do
                row :id
                row :name
                row :background_color
                row :assigned_to do 
                  network.admin_users
                end
              end
            end
          end
        end
        tab 'Radio Stations' do
          table_for network.radio_stations do
            column :name do |radio_station|
              radio_station
            end
            column :city
            column :frequency
            column :status do |radio_station|
              status_tag radio_station.status
            end
            column :assigned_to do |radio_station|
              radio_station.admin_user
            end
          end
        end
      end
    end
  end
end
