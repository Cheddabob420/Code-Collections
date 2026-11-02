class Rectangle{
  constructor(width, height){
    this.width = width;
    this.height = height;
  }
  set width(newWidth){
    if(newWidth > 0){
      this._width = newWidth;
    }
    else{
      console.error("Width must be a positive number!");
    }
  }

  set height(newHeight){
    if(newHeight > 0){
      this._height = newHeight;
    }
    else{
      console.error("Height must be a positive number!");
    }
  }

  get width(){
    return this._width;
  }

  get height(){
    return this._height;
  }

  get area(){
    return this._width * this._height
  }

}

class Person{
  constructor(firstName, lastName, age){
    this.firstName = firstName;
    this. lastName = lastName;
    this.age = age;
  }
  set firstName(newFirstName){
    if(typeof newFirstName === "string" && newFirstName.length > 0){
      this._firstName = newFirstName;
    }
    else{
      console.error("First name must be a non empty string!");
    }
  }
  set lastName(newLastName){
    if(typeof newLastName === "string" && newLastName.length > 0){
      this._lastName = newLastName;
    }
    else{
      console.error("Last name must be a non empty string!");
    }
  }
  set age(newAge){
    if(typeof newAge === "number" && newAge > 0){
      this._age = newAge;
    }
    else{
      console.error("Age must be a number greater than 0!");
    }
  }

  get firstName(){
    return this._firstName;
  }
  get lastName(){
    return this._lastName;
  }
  get age(){
    return this._age;
  }
  get fullName(){
    return this.firstName + " " + this.lastName;
  }
}

const rectangle = new Rectangle(20, 40);
const person = new Person("Greg", "Bob", 33);
rectangle.width = 5;
rectangle.height = 10;

console.log(rectangle.width);
console.log(rectangle.height);
console.log(rectangle.area);

console.log(person.firstName);
console.log(person.lastName);
console.log(person.age);
console.log(person.fullName);