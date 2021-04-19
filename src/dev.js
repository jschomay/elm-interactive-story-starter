// this file gets loadded when running the webpack dev server and connects your live
// game data for real-time previews

require("./styles.scss");
const { Elm } = require("./Main.elm");

// Get your project id from your project's settings tab
let projectId = "<PASTE YOUR PROJECT ID HERE>";

var elmApp = Elm.Preview.init({
    node: document.getElementById("game"),
    flags: { showDebug: true }
});

function onEntitiesData(entities) {
    elmApp.ports.addEntities.send(entities);
}
function onRulesData(rules) {
    elmApp.ports.addRules.send(rules);
}

// This function comes from the included live-game-data.js script, which gets loaded
// when running the webpack dev server.
// Call it with your project id and callbacks to handle new entities and rules data
// respectively.
connectLiveGameData(projectId, onEntitiesData, onRulesData);
