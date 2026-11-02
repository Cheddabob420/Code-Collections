const hello = (name, age) => {console.log(`Hello ${name}!`);
console.log(`You are ${age} years old!`);}

hello("cody", 33);

setTimeout( () => console.log("Goodbye!"), 3000);

const numbers = [1, 2, 3, 4, 5, 6];

const squares = numbers.map((element) => Math.pow(element, 2));
const cubes = numbers.map((element) => Math.pow(element, 3));
const even = numbers.filter((elemnet) => elemnet % 2 === 0);
const odd = numbers.filter((elemnet) => elemnet % 2 !== 0);
const total = numbers.reduce((acc, element) => acc + element);
console.log(squares);
console.log(cubes);
console.log(even);
console.log(odd);
console.log(total);