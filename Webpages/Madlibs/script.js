let zooStory = {
    title: "The Zoo Mystery",
    blanks: ["animal", "color", "food", "name", "action", "bag", "shout"],
    template: "It was a total mystery at the zoo one {color} morning! The zoo keeper opened the main gate and noticed a {animal} named {name}. Instead of staying in its pen, {name} was {action} all over the place and juggling a whole bag of {bag}! All the visitors stopped to watch, and they started throwing {food} into the air to join the fun. The head zoo keeper gasped and yelled, {shout} as loud as he could!",
    labels: {
        animal: "A zoo animal:",
        color: "A color as a feeling:",
        food: "Animal food:",
        name: "A name:",
        action: "An action word ending in ing (like jumping):",
        bag: "Something that comes in a bag (like marbles):",
        shout: "A zoo animal sound:"
    }
};
let slimeStory = {
    title: "The Great Goo Spill",
    blanks: ["animal", "color", "food", "name", "action", "bag", "shout"],
    template: "Welcome to the Goo Factory, where they make the best slime in the world! The tour guide today was a big {animal} in a bright {color} lab coat. Everything was going great until a worker dropped a bowl of {food} into the slime tub. Uh oh! The machine began to shake! The boss, {name}, was {action} all the way to the big red STOP button. SPLAT! A giant wave of slime came out of the tub! It went all over the room. It even got into a huge bag of {bag} on the shelf! The tour guide threw up its paws and yelled, \"{shout}!\" It was the messiest, best day ever at the Goo Factory!",
    labels: {
        animal: "One slippery animal:",
        color: "A gooey color:",
        food: "A slimy food:",
        name: "A name:",
        action: "An action word ending in ing (like running):",
        bag: "Something that comes in a bag (like marbles):",
        shout: "Something you would shout:"
    }
};
let spaceStory = {
    title: "The Great Beyond",
    blanks: ["animal", "color", "food", "name", "action", "bag", "shout"],
    template: "Captain {name} was steering the rocket ship through a high-speed asteroid field when suddenly, the radar detected a strange, bright {color} alien! It wasn't an ordinary alien—it looked just like a giant {animal} wearing an astronaut helmet. The alien was {action} across the spaceship's control panel and accidentally knocked over a full plate of {food}. To make matters worse, the space engine swallowed a whole bag of {bag}! Captain {name} grabbed the radio and blasted, '{shout}!' across all galaxy channels!",
    labels: {
        animal: "A space-monstrous animal:",
        color: "A bright, neon color:",
        food: "Space food:",
        name: "A space captain's name:",
        action: "An action word ending in -ing:",
        bag: "Things inside a bag:",
        shout: "A space alien noise or command:"
    }
};
let pirateStory = {
    title: "The Pirate Treasure Hunt",
    blanks: ["animal", "color", "food", "name", "action", "bag", "shout"],
    template: "Ahoy! The famous pirate captain, {name}, set sail across the deep {color} sea in search of buried treasure! Riding on the ship's mast was the crew's loyal pet {animal}. Right as the captain dug up the wooden chest, everyone expected shiny gold, but instead it was completely packed with delicious {food}! The crew started {action} all over the deck in celebration while tossing around a giant bag of {bag}. Captain {name} raised a sword to the sky and yelled, '{shout}!'",
    labels: {
        animal: "A pirate's pet animal:",
        color: "A sea color:",
        food: "A pirate snack:",
        name: "A pirate captain name:",
        action: "An action word ending in -ing:",
        bag: "Something that comes in a bag:",
        shout: "A pirate shout:"
    }
};
let magicStory = {
    title: "Glitter Magic",
    blanks: ["animal", "color", "food", "name", "action", "bag", "shout"],
    template: "Deep inside the {color} tower, a brilliant wizard named {name} was casting a brand-new magic spell. Beside the cauldron sat a magical {animal} who kept {action} around the room. The wizard carefully dropped three pieces of {food} into the potion, followed by a whole bag of {bag}. Suddenly, the cauldron bubbled over! Smoke filled the room, and the wizard threw up their arms and shouted, '{shout}!' as the magic turned everything into glitter!",
    labels: {
        animal: "A wizard's sidekick animal:",
        color: "A magical color:",
        food: "A strange spell ingredient:",
        name: "A wizard's name:",
        action: "An action word ending in -ing:",
        bag: "Things you carry in a bag:",
        shout: "A magic spell word or shout:"
    }
};
let stories = {
    zoo: zooStory,
    slime: slimeStory,
    space: spaceStory,
    pirate: pirateStory,
    magic: magicStory
};
function showBlanks(){
    let pick = document.getElementById("storyPick").value;
    let chosen = stories[pick];
    let area = document.getElementById("blankarea");
    area.innerHTML = "";
    for(let blank of chosen.blanks){
        let label = document.createElement("label");
        label.textContent = chosen.labels[blank];
        label.htmlFor = blank;
        let box = document.createElement("input");
        box.type = "text";
        box.id = blank;
        box.spellcheck = true;
        box.setAttribute("autocorrect", "off");
        area.appendChild(label);
        area.appendChild(box);
        area.appendChild(document.createElement("br"));
    }
}
function makeStory() {
    let pick = document.getElementById("storyPick").value;
    let chosen = stories[pick];
    let story = chosen.template;
    for (let blank of chosen.blanks) {
        let word = document.getElementById(blank).value;
        story = story.replaceAll("{" + blank + "}", word);
    }
    document.getElementById("story").textContent = story;
    document.getElementById("story").scrollIntoView({ behavior: "smooth", block: "center" });
}
showBlanks();