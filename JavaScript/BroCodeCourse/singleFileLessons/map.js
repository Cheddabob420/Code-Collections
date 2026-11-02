const numbers = [1, 2 ,3, 4, 5];
const students = ["spongebob", "patrick", "sandy", "gary"];
const dates = ["2024-1-10", "2025-2-20", "2020-4-20", "2023-2-20"];
const formattedDates = dates.map(formDates);
function formDates(element){
  const parts = element.split("-");
  return `${parts[1]}/${parts[2]}/${parts[0]}`
}

const squares = numbers.map(square);
console.log(squares);
const cubes = numbers.map(cube);
console.log(cubes);
const studentsU = students.map(uppercase);
console.log(studentsU)
const studentsL = students.map(lowercase);
console.log(studentsL);
function square(element){
  return Math.pow(element, 2);
}

function cube(element){
  return Math.pow(element, 3);
}

function uppercase(element){
  return element.toUpperCase();
}
function lowercase(element){
  return element.toLowerCase();
}

console.log(formattedDates);