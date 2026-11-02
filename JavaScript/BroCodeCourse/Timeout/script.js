function hello(){
    window.alert("Hello");
}

//setTimeout(hello, 3000);

//setTimeout(function(){window.alert("Goodbye!")}, 6000);

//setTimeout(() => window.alert("Yay"), 9000);

//const timeoutId = setTimeout(hello, 12000);
//clearTimeout(timeoutId);

let timeoutId;

function startTimer(){
    timeoutId = setTimeout(() => window.alert("hello"), 3000);
    console.log("Started");
}

function stopTimer(){
    clearTimeout(timeoutId);
    console.log("Stopped");
}