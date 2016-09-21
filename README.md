# Interactive Story Starter

A starting point to build your own interactive stories using the [Elm Narrative Engine](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine).

The Elm Narrative Engine aims to make it as simple as possible to tell stories that are as engaging as possible, allowing you to focus on your story and not the code.


## Getting started

 Initialize your story by cloning this repo and then running `npm i` from that directory.

 Run the story locally with `npm start` then open  http://localhost:8080/ in your browser to view (note that the story will automatically reload as you make changes).

Build your story for distribution (in `/dist/`) with `npm build`.

## Writing your story

This story starter comes with a short example story template to get you started.  You will find all the files you need in the `/src/` directory.  Just modify them with your own content.

The section below explains the main concepts for telling your story.  Also refer to the [package documentation](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine) for the docs on everything that you can do.

### Concepts

You need to provide four pieces of information for the framework to run your story:

1. Story information (title, author, prologue)
2. Description of all of the elements that make up your story world (items, locations, and characters)
3. A set of rules broken in to "scenes" that describe how your story changes over time
4. The state your story starts in

`Main.elm` already sets this up for you, just change the appropriate pieces with your own content.

#### Story elements

By describing your story elements to the framework, it can build a static word that the player can move through and inspect.

List your items, locations, and characters and provide display information for them by modifying `Items.elm`, `Locations.elm` and `Characters.elm` appropriately.

 Each story element gets a display name and display description.  Locations also get a color.

#### Story rules and scenes

In order to progress the story by changing the story world and adding dynamic narration, you must give the framework sets of rules.

Each rule contains:

-  A situation to match against (a trigger such as interacting with an element, and a condition such as being in a specific location)
- A list of commands to change the story world (such as moving the protagonist to a new location or adding an item to the inventory)
- A narration to accompany the event

Rules are grouped into scenes, and you can change scenes through rules as well.

For each trigger (usually the player interacting with something), the framework will run through all of the rules in the current scene, in order, looking for the first match to execute.  If a match is not found, it will do a default action, which usually is just narrating the description of what ever was interacted with.

See `Scene1.elm` for an example on how to build up rule sets.  Also refer to the package documentation for all of the available matchers and commands to change the story world.

`Knowledge.elm` contains a list of "intangible" elements, like knowledge or skills gained from certain actions in the story.  You can match against if you have certain knowledge, adding to the narrative possibilities.
