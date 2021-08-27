const initTimer = () => {
  let countdownContainer = $("#countdown-timer")
  if(countdownContainer.length > 0){
    let remainingSeconds = parseFloat(countdownContainer.data("remaining-seconds"))
    let time = new Date()
    time.setSeconds(time.getSeconds() + remainingSeconds);   
    setInterval(() => {
      let totalSeconds = (time.getTime() - new Date().getTime()) / 1000;
      if (totalSeconds < 0) totalSeconds = 0
      const minutes = Math.floor(totalSeconds / 60)
      const seconds = Math.floor(totalSeconds - (minutes * 60))
      $("#countdown-timer").html(`Remaining time: ${minutes} minutes ${seconds} seconds`)
    }, 1000);
  }
}