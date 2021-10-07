ActiveAdmin.register RadioStation do
  menu parent: ["Stations"], priority: 1
  
  permit_params :network_id, :city_id, :name, :description, :frequency, :audio_streaming_link, :video_string_link, :status, :admin_user_id, :image, :priority
  
  
  form do |f|
    f.semantic_errors *f.object.errors.keys
    if current_admin_user.super_admin?
      networks = Network.all
      djs = AdminUser.djs
    else
      networks = Network.where(id: current_admin_user.network_ids)
      djs = AdminUser.djs.joins(:networks).where(networks: {id: current_admin_user.network_ids})
    end
    f.input :image, as: :file
    f.input :network, collection: networks
    f.input :city, input_html: {class: 'station_city_select'}
    f.input :name
    f.input :description, input_html: { rows: "2" }
    f.input :frequency
    f.input :audio_streaming_link
    f.input :video_string_link
    f.input :priority
    f.input :status
    f.input :admin_user, collection: djs
    f.actions
  end
end
