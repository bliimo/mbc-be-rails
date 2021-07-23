ActiveAdmin.register Question do
  menu parent: ["Games"], priority: 2
  permit_params :quiz_game_id, :question, :countdown_in_seconds
  
end
