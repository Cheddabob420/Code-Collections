const newH1 = document.createElement("h1");
const newH2 = document.createElement("h2");
const box2 = document.getElementById("box3");
const boxes = document.querySelectorAll(".box");
const newH3 = document.createElement("h3")
const newListItem = document.createElement("li");

newH3.textContent = "I like blue"
newH1.textContent = "I like pizza";
newH2.textContent = "I like turles";
document.body.insertBefore(newH3, boxes[3])
//document.body.append(newH1);
document.body.prepend(newH1);
document.body.append(newH2);
document.body.insertBefore(newH2, box2);
newH1.id = "myH1";
newH3.id = "myH3";
newListItem.textContent = "coconut";
document.body.append(newListItem);
newH1.style.color = "tomato";
newH2.style.color = "aqua";
newH3.style.color = "yellowgreen";
newH1.style.textAlign = "center";
newH2.style.textAlign = "center";
newH3.style.textAlign = "center";
//document.getElementById("box1").append(newH1);
document.getElementById("box1").prepend(newH1);
newListItem.id = "coconut";
newListItem.style.fontWeight = "bold";
newListItem.style.backgroundColor = "lightgreen";
//document.getElementById("fruits").append(newListItem);
document.getElementById("fruits").prepend(newListItem);


