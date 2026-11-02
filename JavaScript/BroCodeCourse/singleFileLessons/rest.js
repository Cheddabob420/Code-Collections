
function openFridge(...foods){
  console.log(foods);
  console.log(...foods);
}
function getFood(...foods){
  return foods;
}

function sum(...numbers){
  let result = 0;
  for(let number of numbers){
    result += number;
  }
  return result;
}
function getAverage(...numbers){
  let result = 0;
  for(let number of numbers){
    result += number;
  }
  return result / numbers.length;
}

const total = sum(1, 5, 7, 8, 14);
const total2 = getAverage(75, 60, 100, 94, 72);

const food1 = "pizza"
const food2 = "burger"
const food3 = "hotdog"
const food4 = "sushi"
const food5 = "ramen"

openFridge(food1, food2, food3, food4, food5);

const foods = getFood(food1, food2, food3, food4, food5);
console.log(foods);

console.log(`Your total is $${total}`);
console.log(`Your average is ${total2}`);