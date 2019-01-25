require( './Theme/styles/reset.css' );
require( './Theme/styles/main.css' );
require( './Theme/styles/story.css' );
require( './Theme/styles/github-markdown.css' );

// inject bundled Elm app
var {Elm} = require( './Main' );
var app = Elm.Main.init({
	node: document.body
});


// automatically set images to load through webpack manifest loader
var imagesToLoad = require("json!manifest?config=images!../preload.json");


// start app right away if we don't need to load anything
if (!imagesToLoad.length) {
  loaded();
}


// need to keep a reference so browsers don't dereference and lose the cache
var loadedImages = imagesToLoad.map(loadImage);

var numAssetsLoaded = 0;
function assetLoaded() {
  numAssetsLoaded++;
  if(numAssetsLoaded === imagesToLoad.length) {
    loaded();
  }
}

function loadImage(path) {
  var img = new Image();
  img.src = path;
  img.onload = assetLoaded;
  return img;
}

function loaded() {
  app.ports.loaded.send(true);
}

