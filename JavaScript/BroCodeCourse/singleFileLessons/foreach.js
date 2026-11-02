let numbers = [1, 2, 3, 4, 5];
numbers.forEach(cube);
numbers.forEach(display);

function display(element){
  console.log(element);
}

function double(element, index, array){
  array[index] = element * 2;
}
function tripple(element, index, array){
  array[index] = element * 3;
}

function square(element, index, array){
  array[index] = Math.pow(element, 2);
}

function cube(element, index, array){
  array[index] = Math.pow(element, 3);
}

function uppercase(element, index, array){
  array[index] = element.toUpperCase();
}
function lowercase(element, index, array){
  array[index] = element.toLowerCase();
}
function capt(element, index, array){
  array[index] = element.charAt(0).toUpperCase() + element.slice(1);
}

let fruits = ["apple", "orange", "banana", "mango"];

fruits.forEach(capt);
fruits.forEach(display);
