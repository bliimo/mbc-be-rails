
//= require arctic_admin/base
//= require select2
//= require select2-full
//= require jquery
//= require jquery_ujs

jQuery(function() { 
  $("#quiz_game_status, #quiz_game_city_id, #quiz_game_sponsor_id, #quiz_game_radio_station_id").select2({
    height: "1000px"
  })
  $("#user_region_id").select2()
  $("#user_province_id").select2()
  $("#user_city_id").select2()
})