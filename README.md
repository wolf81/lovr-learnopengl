# LÖVR Learn Open GL

This repository contains a [LÖVR](https://lovr.org) port of the [Learn Open GL](https://learnopengl.com) tutorials.

The goal of the repo is for myself and hopefully others to better understand how to port (mainly) shaders to LÖVR.

## Directory Structure

The directory structure is as follows:

- `src/`: contains the tuturial source code and some additions for menu navigation in the root program.
- `lib/`: contains several dependencies, this is code found elsewhere such as lovr-mouse. I've decided to directly integrate the libraries into this repo (no submodules), for easy of use.
- `gfx/`: contains graphical assets used in tutorials.

As mentioned before, there's a basic UI included for menu navigation. This allows a user to start the main program from the root directory and navigate between the tutorials. Some tutorials include a camera and if so, navigation is possible using mouse and keyboard (A,S,D,F). The `<escape>` button can be pressed to navigate back from a tutorial or menu.

Please note, each tutorial also includes it's own main program, so it's possible to navigate to the directory of a tutorial and start LÖVR from there. Of course, in this case there will be no menu navigation and the `<escape>` button will exit the tutorial.

## Conventions

Some programming conventions used in this project are:

- I've used a class-based approach somewhat similar to the approach described in the [Privacy](https://www.lua.org/pil/16.4.html) chapter of Programming in Lua.
- Many tutorials contain a `shd/` directory, the vertex and fragment shaders are stored inside.
- A tutorial directory contains at least a `main.lua` file and a `tutorial.lua` file. The `tutorial.lua` file contains the source-code equivalent to the C++ source code in the Learn Open GL tutorials.
