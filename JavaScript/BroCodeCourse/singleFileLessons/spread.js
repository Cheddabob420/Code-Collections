let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
let username ="Cogy Gibson"
let letters = [...username].join("-");
let fruits = ["apple", "mango", "grape"];
let vegtables = ["carrots", "potatos", "celery"];
let foods = [...fruits, ...vegtables, "eggs", "milk"];

let max = Math.max(...numbers);
let min = Math.min(...numbers);


console.log(max);
console.log(min);
console.log(letters);
console.log(fruits);
console.log(vegtables);
console.log(foods);