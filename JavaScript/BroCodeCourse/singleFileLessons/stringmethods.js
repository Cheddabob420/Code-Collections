let username = "Cogy";
console.log(username.charAt(0));
console.log(username.indexOf("g"));
console.log(username.length);
let messyname = "   Cogy    "
console.log(messyname.trim());
console.log(username.toUpperCase());
console.log(username.toLowerCase());
console.log(username.repeat(3));
console.log(username.startsWith("C"));
console.log(username.endsWith("C"));
console.log(username.includes("C"));

let phoneNum = "123-456-7899";

let phoneNumb = phoneNum.replaceAll("-", "/");

console.log(phoneNumb);

let phoneNumber = phoneNum.padStart(15, "_");
phoneNumber = phoneNumber.padEnd(18, "_");

console.log(phoneNumber);

