let buttons = document.querySelectorAll(".myButtons");
const newButton = document.createElement("button");
/*
buttons.forEach(button => {
    button.style.backgroundColor = "green"
    button.textContent += "😶‍🌫️"
});
*/
newButton.textContent = "Button5";
newButton.classList = "myButtons";
document.body.appendChild(newButton);

buttons = document.querySelectorAll(".myButtons");

buttons.forEach(button => {
    button.addEventListener("click", event => {
        event.target.remove();
    })
})

buttons.forEach(button => {
    button.addEventListener("click", event => {
        event.target.style.backgroundColor = "tomato"
    });
});

buttons.forEach(button => {
    button.addEventListener("mouseover", event => {
        event.target.style.backgroundColor = "hsl(205, 100%, 40%)"
    });
});

buttons.forEach(button => {
    button.addEventListener("mouseout", event => {
        event.target.style.backgroundColor = "hsl(205, 100%, 60%)"
    });
});


