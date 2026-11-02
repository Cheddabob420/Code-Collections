const headers = document.querySelectorAll("#show > div > h3");
let x = 0;
headers.forEach((h3) => {
    x += 6;
    x = Math.floor( x % 360);
    h3.style.color = `hsl(${x}, 100%, 50%)`;
})
