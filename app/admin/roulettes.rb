ActiveAdmin.register Roulette do
  menu parent: ["Games"], priority: 1

  permit_params :radio_station_id, :location_restriction, :city_id, :location_restriction_type, :text_description, :dj_id, :sponsor_id, :name, :number_of_winner, :price, :schedule, :redemption_details, :dti_permit, :winner_prompt, :popper_visible, :banderitas_visible
  
end
