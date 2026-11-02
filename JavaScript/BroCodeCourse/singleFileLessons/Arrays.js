let fruits =["Apple", "Pear", "Orange", "Banana"];

console.log(fruits);
console.log(fruits[0]);
console.log(fruits[1]);
console.log(fruits[2]);
console.log(fruits[3]);

fruits[0] = "Coconut";
fruits[1] = "Grape";
fruits[2] = "Fig";
fruits[3] = "Strawberry";

console.log(fruits[0]);
console.log(fruits[1]);
console.log(fruits[2]);
console.log(fruits[3]);

fruits.push("Blueberry");

console.log(fruits);

fruits.pop();

console.log(fruits);

fruits.unshift("Mango");

console.log(fruits);

fruits.shift();

console.log(fruits);

let numFruits = fruits.length;
let index = fruits.indexOf("Fig");
console.log(numFruits);
console.log(index);

for(let i = 0; i < fruits.length; i++){
  console.log(fruits[i]);
}
fruits.sort()

for(let fruit of fruits){
  console.log(fruit);
}