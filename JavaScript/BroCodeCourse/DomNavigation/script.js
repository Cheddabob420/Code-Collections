// first element child
const fruits = document.getElementById("fruits");
const vegies = document.getElementById("vegetables");
const desserts = document. getElementById("desserts");
const ulElements = document.querySelectorAll("ul");
const sibling = document.getElementById("apple");
const sibling1 = document.getElementById("carrots");
const sibling2 = document.getElementById("ice cream");
const parent = document.getElementById("apple")
const child = document.getElementById("fruits");

const firstChild1 = fruits.firstElementChild;
const firstChild2 = vegies.firstElementChild;
const firstChild3 = desserts.firstElementChild;
const nextSibbling = sibling.nextElementSibling;
const nextSibbling1 = sibling1.nextElementSibling;
const prevSibbling = sibling2.previousElementSibling;
const parents = parent.parentElement;
const children = child.children;

firstChild1.style.backgroundColor = "rgb(255, 255, 0)";
firstChild2.style.backgroundColor = "rgb(255, 0, 255)";
firstChild3.style.backgroundColor = "rgb(0, 255, 255)";
ulElements.forEach(ulElement => {
    const lastChild = ulElement.lastElementChild;
    lastChild.style.backgroundColor = "rgb(255, 0, 0)";
})
const lastChild = fruits.lastElementChild;
lastChild.style.backgroundColor = "rgb(0, 255, 0)";

nextSibbling.style.backgroundColor = "rgb(0, 0, 255)";
nextSibbling1.style.backgroundColor = "rgb(0, 0, 255)";
prevSibbling.style.backgroundColor = "rgb(0, 0, 255)";
console.log(parents);
Array.from(children).forEach(child => {
    console.log(child);
})
