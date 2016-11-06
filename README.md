# Interactive Story Starter

A starting point to build your own interactive stories using the [Elm Narrative Engine](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest).

The Elm Narrative Engine aims to make it as simple as possible to tell stories that are as engaging as possible, allowing you to focus on your story and not the code.

*Updated for version 2.0.0*


## Getting started

 Initialize your story by cloning this repo and then running `npm i` from that directory.

 Run the story locally with `npm start` then open  http://localhost:8080/ in your browser to view.

Build your story for distribution (in `/dist/`) with `npm build`.

## Writing your story

This story starter comes with a short example story template to get you started.  You will find all the files you need in the `/src/` directory.  Just modify them with your own content.

The section below explains the main concepts for telling your story.  Also refer to the [package documentation](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest) for the docs on everything that you can do.

### Concepts

You need to provide four pieces of information for the framework to run your story:

1. Story information (title, author, prologue)
2. Description of all of the elements that make up your story world (items, locations, and characters)
3. A set of rules broken in to "scenes" that describe how your story changes over time
4. The state your story starts in

`Main.elm` already sets this up for you, just change the appropriate pieces with your own content.

#### Story elements

By describing your story elements to the framework, it can build a static word that the player can move through and inspect.

List your items, locations, and characters and provide display information for them by modifying `World.elm`.  You could break this file up into separate files if it gets too large.

Each story element gets a display name and display description.  Locations also get a color.

#### Story rules and scenes

In order to progress the story by changing the story world and adding dynamic narration, you must give the framework sets of rules.

Each rule contains:

- An interaction matcher against what the player clicked on
- Conditions to match against based on the current story world state
- A list of commands to change the story world (such as moving the protagonist to a new location or adding an item to the inventory)
- A narration to accompany the event (multiple narrations can be specified for subsequent matches of the same rule)

Rules are grouped into scenes, and you can change scenes through rules as well.

On each player interaction, the framework will run through all of the rules in the current scene, in order, looking for the first match to execute.  If a match is not found, it will do a default action, which usually is just narrating the description of what ever was interacted with.  Order and constrain your rules carefully to be sure the right rules match the right conditions!

See `Scenes.elm` for an example on how to build up rule sets.  Also refer to the package documentation for all of the available matchers and commands to change the story world.

## Sample stories

You can [play some sample stories](http://blog.elmnarrativeengine.com/sample-stories) (including the the sample story in this story starter).

## Future development

Plans are underway to add a visual editor and much more.  Follow along with the progress on the [development blog](http://blog.elmnarrativeengine.com/).
