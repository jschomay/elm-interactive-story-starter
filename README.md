# Interactive Story Starter

A starting point to build your own interactive stories using the [Elm Narrative Engine](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest).

The Elm Narrative Engine is a unique tool for telling interactive stories. It features a context-aware rule-matching system to drive the story forward, and offers a total separation of logic, presentation, and content, making it an extremely flexible and extensible engine. 

You can read the [full API and documentation](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest), follow along with [developement](http://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest), and play some [sample stories](http://blog.elmnarrativeengine.com/sample-stories/).


## Getting started

This repo contains a fully featured sample story that you can clone and extend for your own use.  The Elm Narrative Engine is written in [Elm](http://elm-lang.org), and so is this client code.

Run this code with `npm i` (to install) and then `npm start` (to serve it).  Then you can open your browser window to http://localhost:8080/ to see the story.  `npm run build` will build the code into the `/dist` directory.

The simplest way to start writing your own story is to modify the `Rules.elm` and `Manifest.elm` files with your own content.  You can also change the theme by changing the code in the `Theme` directory.  All of these source files live under the `/src` directory.


## More advanced

This code uses a pattern called the Entity Component System pattern, which allows for strong decoupling.

In a nutshell, each "object" in your story is an "entity," which has an id.

"Components" can be anything that adds more meaning or content to an entity, such as a description, or an image file.  You can add components as you need them by defining what data types the component uses, then associating that component and its specific data with an entity id.

Each component has a "system," which does something meaningful with the component data, such as rendering the description or image.

You will find some component data being added to various entities in the `Manifest.elm` file, which gets "plucked" out for use in the theme and `Main.elm` files.  The source files are annotated with comments, explaining the specifics further

Enjoy creating your interactive story!
