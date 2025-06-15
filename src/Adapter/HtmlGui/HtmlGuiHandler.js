const BUTTONS_NAMES = ["btnRollDice", "btnStudy", "btnWork", "btnDoRandomEvent", "btnLeaveJob"]
// // const buttons = range(1, N_BUTTONS).map((i) => document.getElementById("btn"+i));


// function range(firstN, lastN) {
//   const size = lastN - firstN + 1;
//   return [...Array(size).keys()].map(i => i + firstN);
// }


export function _waitForClick() {
  // document.addEventListener('DOMContentLoaded', function() {
    return new Promise((resolve) => {

      // const buttons = document.querySelectorAll('button');
      const buttons = BUTTONS_NAMES.map((btnName) => document.getElementById(btnName));

      const handlers = Array.from(buttons).map((btn) => (() => cleanup(btn)));
          
      function cleanup(btn) {
        buttons.forEach((b, i) => b.removeEventListener("click", handlers[i]));
        const buttonName = btn.name || btn.id || btn.textContent || 'Unnamed Button';
        resolve(buttonName);
      }
      buttons.forEach((btn, i) => btn.addEventListener("click", handlers[i]));
    });
  // })
}


// export const _hideButton = function (btnIdx){
//   return function () {
//     document.getElementById(btnIdx).hidden = true;
//   }
// }

export const _hideAllButtons = function(){
    console.log("_hideAllButtons");
    BUTTONS_NAMES.forEach(button => {
      console.log(button);
      document.getElementById(button).hidden = true;
    });
}

export const _displayButton = function(btnIdx){
  return function(){
    document.getElementById(btnIdx).hidden = false;
  }
}

// export const _setButtonText = function(btnIdx){
//   return function(text){
//     return () => document.getElementById(btnIdx).value = text;
//   }
// }

export const _printGameMessage = function(msg){
  return function(){
    const div = document.getElementById("LogBox");
    const p = document.createElement("p");
    p.textContent += msg;
    div.append(p);
    div.scrollTop = div.scrollHeight;
  }
}

export const _displayGameStatus = function(strings){
  return function(){
    const div = document.getElementById("StatusBox");
    div.replaceChildren();
    strings.forEach((str) => {
      const p = document.createElement("p");
      p.textContent += str;
      div.append(p);
    });
  }
}


export const _printToActionBox = function(strings){
  return function(){
    const div = document.getElementById("ActionBox");
    div.replaceChildren();
    strings.forEach((str) => {
      const p = document.createElement("p");
      p.textContent += str;
      div.append(p);
    });
  }
}
