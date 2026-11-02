let numbers = [1, 2, 3, 4, 5, 6, 7];
let evenNum = numbers.filter(isEven);
let oddNum = numbers.filter(isOdd);
const ages = [16, 17, 18, 18, 19, 20, 60];
const adults = ages.filter(isAdult);
const childs = ages.filter(isChild);
const fruit = ["banana", "orange", "coconut", "pineapple", "mango"]
const shortW = fruit.filter(getShort);
const longW = fruit.filter(getLong);

function isEven(element){
  return element % 2 === 0;
}
function isOdd(element){
  return element % 2 !== 0;
}
function isAdult(element){
  return element >= 18;
}
function isChild(element){
  return element < 18;
}
function getShort(element){
  return element.length <= 6
}
function getLong(element){
  return element.length > 6
}

console.log(evenNum);
console.log(oddNum);
console.log(adults);
console.log(childs);
console.log(shortW);
console.log(longW);
