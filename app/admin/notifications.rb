ActiveAdmin.register Notification do
  permit_params :title, :description, :game_id, :schedule, :user_id
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :description
    end
    f.actions
  end
end
