ActiveAdmin.register RadioStation do
  menu parent: ["Stations"], priority: 1
  
  permit_params :network_id, :city_id, :name, :description, :frequency, :audio_streaming_link, :video_string_link, :status, :admin_user_id, :image
  
  
  form do |f|
    f.input :image, as: :file
    f.input :network
    f.input :city, input_html: {class: 'station_city_select'}
    f.input :name
    f.input :description, input_html: { rows: "2" }
    f.input :frequency
    f.input :audio_streaming_link
    f.input :video_string_link
    f.input :status
    f.input :admin_user
    f.actions
  end
end
