const person1 = {
  firstName: "Sponge Bob",
  lastName: "Square Pants",
  age: 30,
  isEmployed: true,
  sayHello: function(){console.log("Hi! Im Spongebob!")},
  sayGoodbye: function(){console.log("Goodbye!")},
  eat: () => console.log("Eating a krabby patty"),
}

const person2 = {
  firstName: "Patrick",
  lastName: "Star",
  age: 33,
  isEmployed: false,
  sayHello: function(){console.log("Heeey....")},
  sayGoodbye: function(){console.log("byeee...")},
  eat: () => console.log("Eating Dirt!"),
}

console.log(person1.firstName);
console.log(person1.lastName);
console.log(person1.age);
console.log(person1.isEmployed);
person1.sayHello();
person1.sayGoodbye();
person1.eat();

console.log(person2.firstName);
console.log(person2.lastName);
console.log(person2.age);
console.log(person2.isEmployed);
person2.sayHello();
person2.sayGoodbye();
person2.eat();