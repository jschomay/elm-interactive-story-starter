# Interactive Story Starter

This repo helps you get started writing non-linear interactive story games for the
browser using the [Elm Narrative Engine](https://enegames.itch.io/elm-narrative-engine).

The code in this repo is written in [Elm](https://elm-lang.org/), a friendly language
that gets compiled into JavaScript.

## Usage

First clone or download this repo, `cd` into it, and run `npm install`. Then:

### Step 1: Set up the project

Head over to the [visual editor](https://enegames.itch.io/elm-narrative-engine) to
create a project, and add some data to the manifest and rules tabs.

### Step 2: Connect your story data for live development

In the editor, under the "Settings" tab of your project, you will need to check the
"Allow public reads" check box. You also need your project's id, which you can find
in the same area.

Copy and paste your project's id into the indicated spot in `src/dev.js`, then run
`npm run dev` and open `localhost:3000/` in your web browser.

You should see your game with the data from the editor. This data updates in
real-time, so you can preview it as you make changes in the editor without needing to
refresh. It also live-updates as you make code changes.

### Step 3: Customize your game

`src/Model.elm` and `src/View.elm` contain the code to get your started. You can
modify these files to change how your game works and/or looks. You can also change
the title in `src/index.html` and the styles in `src/styles.scss`.

### Step 4: Release your game

When you are ready to release your game, you need to bundle it with the exported
story data.

Under the "Settings" tab of your project, you can download your "Project data" as a
json file. Save this file as `story-data.json` next to `src/release.js` then run
`npm run release`. You can then deploy the contents of the `dist/` directory where
ever you want (such as zipping that directory and uploading it to a new itch.io
project).

Feel free to share your finished game on the ["Made with the Elm Narrative Engine"
forum](https://itch.io/t/1324724/games-made-with-the-elm-narrative-engine).

## Getting help

If you are stuck, you can read through the [full
documentation](https://package.elm-lang.org/packages/jschomay/elm-narrative-engine/latest/).
You can also ask for help on the [editor's
forum](https://enegames.itch.io/elm-narrative-engine/community).
