const myButton = document.getElementById("myButton");
const myImg = document.getElementById("myImage");

myButton.addEventListener("click", event => {
    if(myImg.style.visibility === "hidden"){
        myImg.style.visibility = "visible";
        myButton.textContent = "Hide"
    }
    else {
        myImg.style.visibility = "hidden";
        myButton.textContent = "Show";
    }
    
    
});