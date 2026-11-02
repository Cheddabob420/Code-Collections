const decB = document.getElementById("decB");
const resetB = document.getElementById("resetB");
const incB = document.getElementById("incB");
const countLabel = document.getElementById("countLabel");
let count = 0;

incB.onclick = function(){
  count++;
  countLabel.textContent = count;
}

decB.onclick = function(){
  count--;
  countLabel.textContent = count;
}

resetB.onclick = function(){
  count = 0;
  countLabel.textContent = count;
}