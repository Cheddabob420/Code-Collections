function outer(){
    let message = "hello";
    function inner(){
        console.log(message);
    }
    inner();
}

outer();

function createCounter(){
    let count = 0;
    function increment(){
    
        count++;
        console.log(`count increased bt ${count}`);
    }
    
    function getCount(){
        return count;
    }
    return {increment, getCount};
}

const counter = createCounter();

counter.increment();
counter.increment();
counter.increment();
counter.increment();
console.log(`the current count is ${counter.getCount()}`);

function createGame(){
    let score = 0;

    function incScore(points){
        score += points;
        console.log(`+${points}pts`);
    }
    function decScore(points){
        score -= points;
        console.log(`-${points}pts`);
    }
    function getScore(){
        return score;
    }

    return {incScore, decScore, getScore};
}

const game = createGame();

game.incScore(5);
game.incScore(6);
console.log(`Current score ${game.getScore()}`);
game.decScore(3);
game.decScore(2);
console.log(`Final score ${game.getScore()}`);