// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
import "bootstrap"
import $ from 'jquery'; 

document.addEventListener("turbolinks:load", $(function () {
    $('[data-toggle="popover"]').popover()
  })
);


let seconds = 60

const initTimer = () => {
  console.log("initTimer")
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
      $("#countdown-timer").html(`${String(minutes)?.padStart(2, "0")} : ${String(seconds)?.padStart(2, "0")} `)
    }, 1000);
  }
}


const renderParticipantRow = (participants) => {
  const countLabel = $("#player-count");
  if(countLabel){
    countLabel.html(participants.length)
  }else{
    console.log("No player count label")
  }
  let content = ""
  participants.map(item => {
    content = content + `
      <p>${item.user.first_name + " " + item.user.last_name}</p>
    `
  })
  const playerListContainer = $("#player-list-container")
  if(playerListContainer){
    playerListContainer.html(content)
  }else{
    console.log("No player list container")
  }
}

const initGameSocketListener = () => {
  console.log("initGameSocketListener")
  const game = $("#game_id")
  console.log({game})
  const gameId = game.val()

  console.log({gameId})
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
      if (msg.message?.type == 'GAME_UPDATED') {
        window.location.reload();
      }
      if (msg.message?.type == 'PLAYER_JOIN') {
        renderParticipantRow(msg.message.participants)
      }
      if (msg.message?.type == 'PLAYER_SPIN') {
        renderParticipantRow(msg.message.participants)
      }
      if (msg.message?.type == 'FINISHED') {
        window.location.reload();
      }
      console.log({msg});
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


document.addEventListener("DOMContentLoaded", function() {
  initLobby();
});
