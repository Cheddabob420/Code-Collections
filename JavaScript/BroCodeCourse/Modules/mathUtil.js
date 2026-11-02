export const PI = 3.14159;

export function getCircumfrence(raduis){
    return 2 * PI * raduis;
}

export function getArea(radius){
    return PI * radius * radius;
}

export function getVolume(radius){
    return (4/3) * PI * Math.pow(radius, 3);
}