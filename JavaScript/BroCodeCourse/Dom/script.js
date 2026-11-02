document.title = "my website"
document.body.style.backgroundColor = "hsl(0, 0%, 15%)"

const username = ""
const welcomeMesage = document.getElementById("welcome");
welcomeMesage.textContent += username === "" ? `Guest` : username;

console.dir(document);