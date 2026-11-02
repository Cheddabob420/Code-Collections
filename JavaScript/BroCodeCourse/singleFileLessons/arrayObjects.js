const fruits = [
  {name: "apple", color: "red", calories: 95},
  {name: "orange", color: "orange", calories: 87},
  {name: "banana", color: "yellow", calories: 123},
  {name: "grape", color: "green", calories: 45},
  {name: "plum", color: "purple", calories: 68}];


fruits.push({name: "mango", color: "orange", calories: 102});

console.log(fruits[0].name);
console.log(fruits[1].name);
console.log(fruits[2].name);
console.log(fruits[3].name);
console.log(fruits[4].name);
console.log(fruits[5].name);

console.log(fruits[0].color);
console.log(fruits[1].color);
console.log(fruits[2].color);
console.log(fruits[3].color);
console.log(fruits[4].color);
console.log(fruits[5].color);

console.log(fruits[0].calories);
console.log(fruits[1].calories);
console.log(fruits[2].calories);
console.log(fruits[3].calories);
console.log(fruits[4].calories);
console.log(fruits[5].calories);

console.log(fruits);

fruits.pop();

console.log(fruits);

fruits.forEach(fruit => console.log(fruit));
fruits.forEach(fruit => console.log(fruit.name));
fruits.forEach(fruit => console.log(fruit.color));
fruits.forEach(fruit => console.log(fruit.calories));

const fruitNames = fruits.map(fruit => fruit.name);
const fruitColors = fruits.map(fruit => fruit.color);
const fruitCals = fruits.map(fruit => fruit.calories);

console.log(fruitNames);
console.log(fruitColors);
console.log(fruitCals);

const redFruits = fruits.filter(fruits => fruits.color === "red");
const lowCalFruits = fruits.filter(fruit => fruits.calories < 100);
const highCalFruits = fruits.filter(fruit => fruits.calories > 100);
const maxFruit = fruits.reduce((max, fruit) => fruit.calories > max.calories ? fruit : max);
const minFruit = fruits.reduce((min, fruit) => fruit.calories < min.calories ? fruit : min);

console.log(redFruits);
console.log(lowCalFruits);
console.log(highCalFruits);
console.log(maxFruit);
console.log(minFruit);