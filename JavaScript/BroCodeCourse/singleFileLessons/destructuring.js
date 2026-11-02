let a = 1;
let b = 2;

[a, b] = [b, a];

console.log(a);
console.log(b);

const colors = ["red", "green", "blue", "black", "white"];

[colors[0], colors[4]] = [colors[4], colors[0]]
console.log(colors)

const [firstC, secondC, thirdC, ...extraC] = colors;

console.log(firstC);
console.log(secondC);
console.log(thirdC);
console.log(extraC);

function displayPerson({firstName, lastName, age, job="Unemployed"}){
  console.log(`Name: ${firstName} ${lastName}`);
  console.log(`Age: ${age}`);
  console.log(`Job: ${job}`);
}

const person1 = {
  firstName: "Greg",
  lastName: "Jones",
  age: 30,
  job: "Fry Cook"
}

const person2 = {
  firstName1: "John",
  lastName1: "James",
  age1: 34
}

const {firstName, lastName, age, job} = person1;
//const {firstName, lastName, age, job="Unemployed"} = person2;

console.log(firstName);
console.log(lastName);
console.log(age);
console.log(job);

displayPerson(person1);
displayPerson(person2);