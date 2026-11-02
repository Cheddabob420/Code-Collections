function walkDog(){
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            const dogWalked = true;
            if(dogWalked){
                resolve("You walk the dog 🐕");
            }
            else{
                reject("You didnt walk the dog");
            }
        }, 1500);
    });
}

function cleanKitchen(){
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            const kitchenCleaned = true;
            if(kitchenCleaned){
                resolve("You clean the kitchen 🧹");
            }
            else{
                reject("You didnt clean the kitchen");
            }  
        }, 2500);
    });
}

function takeTrash(){
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            const trashTaken = true;
            if(trashTaken){
                resolve("You take out the trash 🗑️");
            }
            else{
                reject("You didnt take out the trash");
            }
            
        }, 500);
    });
}

async function doChores(){
    try{
        const walkResult = await walkDog();
        console.log(walkResult);

        const cleanResult = await cleanKitchen();
        console.log(cleanResult);

        const takeResult = await takeTrash();
        console.log(takeResult);

        console.log("You Finished All Tasks!");
    }
    catch(error){
        console.error(error);
    }

    
}

doChores();