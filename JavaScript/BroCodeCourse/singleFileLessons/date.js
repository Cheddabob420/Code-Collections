const date = new Date();
const year = date.getFullYear();
const month = date.getMonth();
const theDay = date.getDate();
const day = date.getDay();
const hours = date.getHours();
const minutes = date.getMinutes();
const seconds = date.getSeconds();
const milliseconds = date.getMilliseconds();


console.log(date);
console.log(year);
console.log(month);
console.log(theDay);
console.log(day);
console.log(hours);
console.log(minutes);
console.log(seconds);
console.log(milliseconds);
date.setFullYear(1993);
date.setMonth(5);
date.setDate(20);
date.setHours(2);
date.setMinutes(30);

console.log(date);

const date1 = new Date("2023-12-31");
const date2 = new Date("2024-01-01");

if(date2 > date1){
    console.log("greater that date 1")
}