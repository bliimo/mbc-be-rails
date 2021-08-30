
//= require arctic_admin/base
//= require select2
//= require select2-full
//= require jquery
//= require jquery_ujs
//= require game_timer

jQuery(function() { 
  $("#quiz_game_status, #quiz_game_city_id, #quiz_game_sponsor_id, #quiz_game_radio_station_id").select2({
    height: "1000px"
  })
  $("#user_region_id").select2()
  $("#user_province_id").select2()
  $("#user_city_id").select2()
  $("#radio_station_city_id").select2()
  $(".station_city_select").select2()
  $("#roulette_city_id").select2()
  $("#roulette_radio_station_id").select2()
  $("#roulette_dj_id").select2()
  $("#roulette_sponsor_id").select2()
  $("#roulette_city_ids").select2()
})


document.addEventListener("DOMContentLoaded", function() {

  $("#notify-user").on("change", (e) => {
    const checked = $("#notify-user").is(':checked')
    console.log({checked})
    if(checked){
      $("#force-update").removeClass("hide")
    }else{
      $("#force-update").addClass("hide")
    }
  })

  $("#roulette_location_restriction").on("change", (e) => {
    if($("#roulette_location_restriction").is(':checked')){
      $("#roullete_location_restriction").removeClass("hide")
    }else{
      $("#roullete_location_restriction").addClass("hide")
    }
  })
  
  initLobby()
});