/*
const hello = function(){
  console.log("Hello!");
}

hello();
*/

setTimeout(function(){
  console.log("Hello!");
}, 3000);

const numbers =[1, 2, 3, 4, 5, 6];

const squares = numbers.map(function(element){
  return Math.pow(element, 2);
});

const cube = numbers.map(function(element){
  return Math.pow(element, 3);
});

const evenNums = numbers.filter(function(element){
  return element % 2 === 0;
});

const oddNums = numbers.filter(function(element){
  return element % 2 !== 0;
});

const total = numbers.reduce(function(acc, element){
  return acc + element;
})

console.log(squares);
console.log(cube);
console.log(evenNums);
console.log(oddNums);
console.log(total);