const myHeadding = document.getElementById('my-heading');
const fruits = document.getElementsByClassName("fruits");
const h4Elements = document.getElementsByTagName("h4");
const listItems = document.getElementsByTagName("li");
const element = document.querySelector(".fruits");
const foods = document.querySelectorAll("li");

myHeadding.style.textAlign = "center";

/*
for(let fruit of fruits){
    fruit.style.backgroundColor = "rgb(255, 247, 1)";
}

Array.from(fruits).forEach(fruit => {
    fruit.style.backgroundColor = "rgb(255, 247, 1)";
})
*/
//h4Elements[0].style.backgroundColor = "rgb(255, 247, 1)"

for(let h4 of h4Elements){
    h4.style.backgroundColor = "rgb(255, 247, 1)";
}
/*
for(let li of listItems){
    li.style.backgroundColor = "rgb(69, 255, 1)"
}
*/
element.style.backgroundColor = "rgb(60, 255, 0)";

foods.forEach(food =>{
    food.style.backgroundColor = "rgb(255, 247, 1)"
});
