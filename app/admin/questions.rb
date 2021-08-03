ActiveAdmin.register Question do
  menu false
  permit_params :quiz_game_id, :question, :countdown_in_seconds
  
end
