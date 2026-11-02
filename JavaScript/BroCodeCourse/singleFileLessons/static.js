class MathUtil{
  static PI = 3.14159;
  static getDiam(radius){
    return radius * 2;
  }
  static getCir(radius){
    return 2 * this.PI * radius;
  }
  static getArea(radius){
    return this.PI * radius * radius;
  }
  
}

class User{
  static userCount = 0;
  constructor(username){
    this.username = username;
    User.userCount++;
  }
  static getUserCount(){
    console.log(`There are ${User.userCount} users online`);
  }
  sayHello(){
    console.log(`Hello my name is ${this.username}`);
  }
}

const user1 = new User("Spongebob");
const user2 = new User("Patrick");
const user3 = new User("Sandy");

console.log(MathUtil.PI);
console.log(MathUtil.getDiam(10));
console.log(MathUtil.getCir(10));
console.log(MathUtil.getArea(10));

user1.sayHello();
user2.sayHello();
user3.sayHello();
User.getUserCount();