try{
    console.log(x);
}
catch(error){
    console.log(error);
}
finally{
    console.log("this always executes")
}

try{
    const dividend = Number(window.prompt("Eneter a dividend: "));
    const divisor = Number(window.prompt("Enter a divisor: "));
    if(divisor == 0){
        throw new Error("You cannot divide by zero!");
    }
    if(isNaN(dividend) || isNaN(divisor)){
        throw new Error("Values must be a number!");
    }
    const result = dividend / divisor;
    console.log(result);
}
catch(error){
    console.error(error);
}

console.log("You have reached the end!");
