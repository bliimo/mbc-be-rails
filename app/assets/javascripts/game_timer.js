let seconds = 60

const initTimer = () => {
  let countdownContainer = $("#countdown-timer")
  if(countdownContainer.length > 0){
    let remainingSeconds = parseFloat(countdownContainer.data("remaining-seconds"))
    let time = new Date()
    time.setSeconds(time.getSeconds() + remainingSeconds);   
    let interval = setInterval(() => {
      let totalSeconds = (time.getTime() - new Date().getTime()) / 1000;
      if (totalSeconds < 0) {
        totalSeconds = 0
        console.log("Triggering click")
        document.getElementById("start-game-btn").click()
        clearInterval(interval)
      }
      const minutes = Math.floor(totalSeconds / 60)
      const seconds = Math.floor(totalSeconds - (minutes * 60))
      console.log({minutes, seconds})
      $("#countdown-timer").html(`Remaining time: ${minutes} minutes ${seconds} seconds`)
    }, 1000);
  }
}

const initGameSocketListener = () => {
  const gameId = $("#game_id").val()
  if(gameId) {
    let socket = new WebSocket(`ws://${window.location.host}/cable`);
    console.info('%cConnecting to Socket', 'color: blue');

    socket.onopen = async () => {
      const msg = {
        command: 'subscribe',
        identifier: JSON.stringify({
          id: gameId,
          channel: 'GameChannel',
        }),
      };
      socket.send(JSON.stringify(msg));
    };

    socket.onmessage = async e => {
      const response = e.data;
      const msg = JSON.parse(response);
      if (msg.type === 'ping') {
        return;
      }
      console.log({msg});
      if (msg.message?.type == 'PLAYER_JOIN') {
       
      }
      if (msg.message?.type == 'FINISHED') {
        window.location.reload();
      }
    };

    socket.onerror = e => {
      console.log({socketError: e.message});
    };

    socket.onclose = e => {
      console.log('Socket closed');
      console.log({socketCode: e.code, socketClose: e.reason});
    };
  }
  
}

const renderClock = () => {

  $("#input-seconds").val(seconds)
  const displayMinute = Math.floor(seconds / 60)
  const displaySeconds = seconds - (displayMinute * 60)

  $("#timer-minutes").html(('0' + displayMinute).slice(-2))
  $("#timer-seconds").html(('0' + displaySeconds).slice(-2))
}

const initTimeChooser = () => {
  renderClock()
  $("#button-up").on("click", () => {
    seconds = seconds + 30
    renderClock()
  })
  $("#button-down").on("click", () => {
    if(seconds < 60) return
    seconds = seconds - 30
    renderClock()
  })
}

const initLobby = () => {
  initGameSocketListener()
  initTimeChooser()
  initTimer()
}