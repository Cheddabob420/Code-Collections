let numbers = [1, 10, 2, 9, 3, 8, 4, 7, 5, 6];

numbers.sort();

console.log(numbers); // lexicographicly sorted

numbers.sort((a, b) => a - b);

console.log(numbers); // sorted leat to great

numbers.sort((a, b) => b - a);

console.log(numbers) // sorted great to least

const people = [
    {name: "Greg", age: 33, gpa: 3.2}, 
    {name: "James", age: 32, gpa: 2.2},
    {name: "Will", age: 37, gpa: 2.7},
    {name: "Ryan", age: 30, gpa: 1.7},
    {name: "Jane", age: 23, gpa: 4.0}];

people.sort((a, b) => a.age - b.age); // sort by youngest first

console.log(people); 

people.sort((a, b) => b.age - a.age); // sort by oldest first

console.log(people); 

people.sort((a, b) => a.gpa - b.gpa); // sort by lowest gpa first

console.log(people); 

people.sort((a, b) => b.gpa - a.gpa); // sort by highest gpa first

console.log(people); 

people.sort((a, b) => a.name.localeCompare(b.name)); // a-z

console.log(people);

people.sort((a, b) => b.name.localeCompare(a.name)); // z-a

console.log(people);