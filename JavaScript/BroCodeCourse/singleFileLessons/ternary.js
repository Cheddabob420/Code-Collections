let age = 21;

let message = age >= 18 ? "Your an adult!" : "Your an minor!"

console.log(message);

let time = 16;
let greeting = time < 12 ? "Good Morning" : "Good Afternoon";

console.log(greeting);

let isStudent = true;
let message2 = isStudent ? "student" : "no student";
console.log(message2);

let purchase = 125;
let discount = purchase >= 100 ? 10 : 0;
console.log(`Your total is $${purchase - purchase * (discount/100)}`);