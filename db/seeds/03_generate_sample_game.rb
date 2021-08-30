roulette = Roulette.new(
  radio_station: RadioStation.first,
  dj: AdminUser.djs.first,
  sponsor: Sponsor.first,
  name: "ExampleGame_00#{Roulette.all.count + 1}",
  number_of_winner: 1,
  price: "Sample Price",
  schedule: DateTime.now + 1.hours,
  redemption_details: "Sample Redemption Details",
  dti_permit: "DTI_123456789",
  winner_prompt: "Sample Winner Prompt",
  popper_visible: true,
  banderitas_visible: true,
  status: "pending",
)

if roulette.save
  roulette.pies << Pie.new(name: "Winner", color: "#%06x" % (rand * 0xffffff))
  11.times do 
    roulette.pies << Pie.new(name: "Bokya", color: "#%06x" % (rand * 0xffffff))
  end
else
  puts roulette.errors.full_messages.join("\n")
  puts "Couldn't save the roulette"
end