const checkBox = document.getElementById("checkBox");
const visaBtn = document.getElementById("visaBtn");
const masterBtn = document.getElementById("masterBtn");
const paypalBtn = document.getElementById("paypalBtn");
const mySubmit = document.getElementById("mySubmit");
const subResult = document.getElementById("subResult");
const paymentResult = document.getElementById("paymentResult");

mySubmit.onclick = function(){
  if(checkBox.checked){
    subResult.textContent = `You are Subscribed!`
  }
  else {
    subResult.textContent = `You are Not Subscribed!`
  }

  if(visaBtn.checked){
    paymentResult.textContent = `You are paying with visa!`
  }
  else if(masterBtn.checked){
    paymentResult.textContent = `You are paying with mastercard!`
  }
  else if(paypalBtn.checked){
    paymentResult.textContent = `You are paying with paypal!`
  }
  else{
    paymentResult.textContent = `You must select a payment type!`
  }
}