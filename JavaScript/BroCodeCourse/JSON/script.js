const names = ["Greg", "Jeff", "Bob", "Joe"];
console.log(names);
const jsonString = JSON.stringify(names);
console.log(jsonString);

const person = {
    "name": "Jeff",
    "age": 30,
    "isEmployed": true,
    "hobbies": ["Karate", "Cooking", "Reading"]
}
console.log(person);
const jsonString2 = JSON.stringify(person);
console.log(jsonString2);

const people = [{
    "name": "Jeff",
    "age": 30,
    "isEmployed": true
},
{
    "name": "Greg",
    "age": 33,
    "isEmployed": false
},
{
    "name": "Jim",
    "age": 37,
    "isEmployed": true
},
{
    "name": "James",
    "age": 40,
    "isEmployed": true
}]
console.log(people);
const jsonString3 = JSON.stringify(people);
console.log(jsonString3);


const jsonNames = `["Greg", "Jeff", "Bob", "Joe"]`;

const jsonPerson = `{"name": "Jeff", "age": 30, "isEmployed": true, "hobbies": ["Karate", "Cooking", "Reading"]}`;

const jsonPeople = `[{"name": "Jeff", "age": 30, "isEmployed": true},
                    {"name": "Greg", "age": 33, "isEmployed": false},
                    {"name": "Jim", "age": 37, "isEmployed": true},
                    {"name": "James", "age": 40, "isEmployed": true}]`;

const parsedData1 = JSON.parse(jsonNames);
console.log(jsonNames);
const parsedData2 = JSON.parse(jsonPerson);
console.log(jsonPerson);
const parsedData3 = JSON.parse(jsonPeople);
console.log(jsonPeople);

fetch("person.json").then(response => response.json()).then(value => console.log(value));
fetch("people.json").then(response => response.json()).then(values => values.forEach(value => console.log(value.name)));
