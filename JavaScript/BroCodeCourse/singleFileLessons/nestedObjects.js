class Person{
  constructor(name, age, ...address){
    this.name = name;
    this.age = age;
    this.address = new Address(...address);
  }
}


class Address{
  constructor(street, city, state){
    this.street = street;
    this.city = city;
    this.state = state;
  }
}

const person1 = new Person("Jesk", 30, "123 Rainy st", "covington", "georgia");
const person2 = new Person("John", 30, "123 Rainy st", "covington", "georgia");
const person3 = new Person("Greg", 30, "123 Rainy st", "covington", "georgia");





const person = {
  fullName: "Greg Jones",
  age: 30,
  isStudent: true,
  hobbies: ["karate", "fishing", "cooking"],
  address: {
    street: "123 Rainy st",
    city: "Boston",
    country: "America"
  }
}
for(const property in person.address){
  console.log(person.address[property]);
}

console.log(person.fullName);
console.log(person.age);
console.log(person.isStudent);
console.log(person.hobbies[1]);
console.log(person.address.street);

console.log(person1.name);
console.log(person1.age);
console.log(person1.address.street);
console.log(person1.address.city);
console.log(person1.address.state);

console.log(person2.name);
console.log(person2.age);
console.log(person2.address.street);
console.log(person2.address.city);
console.log(person2.address.state);

console.log(person3.name);
console.log(person3.age);
console.log(person3.address.street);
console.log(person3.address.city);
console.log(person3.address.state);