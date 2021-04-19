require("./styles.scss");
const { Elm } = require("./Main.elm");

// start up elm app
var app = Elm.Preview.init({
    node: document.getElementById("game"),
    flags: { showDebug: false }
});

fetch("./story-data.json")
    .then((response) => response.json())
    .then((gameData) => {
        app.ports.addEntities.send(gameData.manifest);
        app.ports.addRules.send(gameData.rules);
    });
