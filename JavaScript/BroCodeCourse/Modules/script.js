import {PI, getCircumfrence, getArea, getVolume} from './mathUtil.js';

console.log(PI);

const circumfrence = getCircumfrence(10);
console.log(`${circumfrence.toFixed(2)}cm`);
const area = getArea(10);
console.log(`${area.toFixed(2)}cm2`);
const volume = getVolume(10);
console.log(`${volume.toFixed(2)}cm3`);