const person1 = {
  name: "Spongebob",
  favFood: "Krabby Patty",
  sayHello: function(){console.log(`Hi i am ${this.name}`)},
  eat: function(){console.log(`${this.name} is eating a ${this.favFood}`)}
}

const person2 = {
  name: "Patrick",
  favFood: "Krabby Pattys",
  sayHello: function(){console.log(`Hi i am ${this.name}`)},
  eat: function(){console.log(`${this.name} is eating ${this.favFood}`)}
}


person1.sayHello();
person1.eat();

person2.sayHello();
person2.eat();