function add(x, y){
  return x + y;
}

function sub(x, y){
  return x - y;
}

function mult(x, y){
  return x * y;
}

function div(x, y){
  if(x == 0){
    console.log("Cannot divide bu 0!");
  }
  else{
    return x / y;
  }
}

function isEven(number){
  return number % 2 === 0 ? "Even" : "Odd";
}

function isValidEmail(email){
  return email.includes("@") ? true : false;
}

console.log(add(4, 5));
console.log(sub(10, 5));
console.log(mult(4, 5));
console.log(div(30, 3));
console.log(`Is 2 Even or Odd?: ${isEven(2)}`);
console.log(isValidEmail("g@gmail.com"));