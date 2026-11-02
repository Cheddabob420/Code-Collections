function hello(callback){
  console.log("Hello");
  callback();
}
function leave(){
  console.log("Leave");
}
function bye(){
  console.log("Goodbye");
}

function sum(callback, x, y){
  let result = x + y;
  callback(result);
}
function display(result){
  console.log(result);
}

function displayPage(result){
  document.getElementById("myH1").textContent = result;
}

hello(leave);


sum(display, 4, 10);

sum(displayPage, 20, 25);