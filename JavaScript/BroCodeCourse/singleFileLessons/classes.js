class Product{
  constructor(name, price){
    this.name = name;
    this.price = price;
  }
  
  displayProduct(){
    console.log(`Product: ${this.name}`);
    console.log(`Price: ${this.price.toFixed(2)}`);
  }

  calcTotal(salesTax){
    return this.price + (this.price * salesTax);
  }
}

salesTax = 0.05;

const product1 = new Product("Shirt", 19.99);
product1.displayProduct();
const total1 = product1.calcTotal(salesTax);
console.log(`Total price (with tax): $${total1.toFixed(2)}`);

const product2 = new Product("Pants", 29.55);
product2.displayProduct();
const total2 = product2.calcTotal(salesTax);
console.log(`Total price (with tax): $${total2.toFixed(2)}`);

const product3 = new Product("Underwear", 119.99);
product3.displayProduct();
const total3 = product3.calcTotal(salesTax);
console.log(`Total price (with tax): $${total3.toFixed(2)}`);

