require( './Theme/styles/reset.css' );
require( './Theme/styles/main.css' );
require( './Theme/styles/github-markdown.css' );

// inject bundled Elm app
var Elm = require( './Main' );
Elm.Main.fullscreen();
