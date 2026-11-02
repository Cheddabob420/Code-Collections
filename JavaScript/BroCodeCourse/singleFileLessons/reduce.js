
const grades = [90, 89, 78, 56, 78]
const prices = [1, 4, 66, 23, 56, 12];

const total = prices.reduce(sum);
const maximum = grades.reduce(getMax);
const minimum = grades.reduce(getMin);
function sum(acc, element){
  return acc + element;
}
function getMax(acc, element){
  return Math.max(acc, element);
}
function getMin(acc, element){
  return Math.min(acc, element);
}
console.log(`$${total.toFixed(2)}`);
console.log(maximum);
console.log(minimum);