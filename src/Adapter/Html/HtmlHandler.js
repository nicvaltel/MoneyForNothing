const N_BUTTONS = 9;
// const BUTTONS_NAMES = ["btnRollDice"]
// const buttons = range(1, N_BUTTONS).map((i) => document.getElementById("btn"+i));


function range(firstN, lastN) {
  const size = lastN - firstN + 1;
  return [...Array(size).keys()].map(i => i + firstN);
}
  
 
// export function _waitForClick() {
//   return new Promise((resolve) => {
//     const handlers = range(1, N_BUTTONS).map((i) => (() => cleanup(i)));
        
//     function cleanup(value) {
//       buttons.forEach((btn, i) => btn.removeEventListener("click", handlers[i]));
//       resolve(value);
//     }

//     buttons.forEach((btn, i) => btn.addEventListener("click", handlers[i]));
//   });
// }


export function _waitForClick() {
  // document.addEventListener('DOMContentLoaded', function() {
    return new Promise((resolve) => {


      // const buttons = document.querySelectorAll('button');
      const BUTTONS_NAMES = ["btnRollDice"]
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


// export function _waitForClick111() {
//   // Ждём загрузки DOM
//   document.addEventListener('DOMContentLoaded', function() {
//     // Получаем все элементы button на странице
//     const buttons = document.querySelectorAll('button');
    
//     // Добавляем обработчик клика к каждой кнопке
//     buttons.forEach(button => {
//       button.addEventListener('click', function(event) {
//         // Получаем имя нажатой кнопки
//         const buttonName = this.name || this.id || this.textContent || 'Безымянная кнопка';
        
//         // Выводим имя кнопки (можно заменить на нужное вам действие)
//         console.log('Нажата кнопка:', buttonName);
//         alert(`Нажата кнопка: ${buttonName}`);
        
//         // Если нужно что-то делать с этим именем дальше - возвращаем его
//         return buttonName;
//       });
//     });
//   });
// }


export const _hideButton = function (btnIdx){
  return function () {
    document.getElementById(btnIdx).hidden = true;
  }
}

export const _displayButton = function(btnIdx){
  return function(){
    document.getElementById(btnIdx).hidden = false;
  }
}

export const _setButtonText = function(btnIdx){
  return function(text){
    return () => document.getElementById(btnIdx).value = text;
  }
}

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

// export function waitForClickImpl() {
//   return new Promise((resolve) => {
//     const handler1 = () => cleanup(1);
//     const handler2 = () => cleanup(2);
//     const handler3 = () => cleanup(3);

//     function cleanup(value) {
//       btn1.removeEventListener("click", handler1);
//       btn2.removeEventListener("click", handler2);
//       btn3.removeEventListener("click", handler3);
//       resolve(value);
//     }

//     const btn1 = document.getElementById("btn1");
//     const btn2 = document.getElementById("btn2");
//     const btn3 = document.getElementById("btn3");

//     btn1.addEventListener("click", handler1);
//     btn2.addEventListener("click", handler2);
//     btn3.addEventListener("click", handler3);
//   });
// }