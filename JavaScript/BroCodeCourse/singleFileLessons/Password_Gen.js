function genPasswd(len, incLower, incUpper, incNumbers, incSymbols){
  const lowerChars = "abcdefghijklmnopqrstuvwxyz";
  const upperChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const numbers = "1234567890";
  const symbols = "!@#$%^&*()_+=-|][{}<>/?;:~";
  let allowedChars = "";
  let password = "";

  allowedChars += incLower ? lowerChars : "";
  allowedChars += incUpper ? upperChars : "";
  allowedChars += incNumbers ? numbers : "";
  allowedChars += incSymbols ? symbols : "";
  
  if(len <= 0){
    return `(Password Length must be at least one character long!)`;
  }
  if(allowedChars.length === 0){
    return `(You need to select at least one of the options!)`;
  }
  for(let i = 0; i < len; i++){
    const randIndex = Math.floor(Math.random() * allowedChars.length);
    password += allowedChars[randIndex];
  }

  return password;
}


const pwLen = 12;
const incLower = true;
const incUpper = true;
const incNumbers = true;
const incSymbols = true;

const password = genPasswd(pwLen, incLower, incUpper, incNumbers, incSymbols);
console.log(`Generated Password ${password}`);

