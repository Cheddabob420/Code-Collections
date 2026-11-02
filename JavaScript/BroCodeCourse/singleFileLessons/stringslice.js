const fullName = "Cody Gibson";
let firstName = fullName.slice(0, 4);
let lastName = fullName.slice(5);
let firstChar = fullName.slice(0, 1);
let lastChar = fullName.slice(-1);

console.log(firstName);
console.log(lastName);
console.log(firstChar);
console.log(lastChar);

let fullN = "Bronano Gonglata"
let firstN = fullN.slice(0, fullN.indexOf(" "));
let lastN = fullN.slice(fullN.indexOf(" ") + 1);
console.log(firstN);
console.log(lastN);

let email = "cogygibson420@gmail.com"
let uName = email.slice(0, email.indexOf("@"));
let extention = email.slice(email.indexOf("@") + 1, email.indexOf("."));

console.log(uName);
console.log(extention);