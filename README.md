# Bare Metal Tube: CoPro Bat'n'Ball

## Introduction

This is an example project demonstrating how to create a 2nd Processor game for the BBC Micro series of computers in assembly language.

This is by no means the only way to do it and the Tube versions of _Elite_ and _Chuckie Egg_ don't operate in the same way.

We've chosen _Bat'n'Ball_ from the Welcome tape/disc because it's a very simple game and easy to convert to assembly language.

## What this project is

* A minimal, working example of how to take full control of both CPUs in a cooperative Tube environment designed solely for running video games
* An assembly language conversion of _Bat'n'Ball_ from the Welcome tape/disc, adapted to run in that Tube environment, with some small tweaks (e.g. more exciting sound) and a couple of bug fixes

## What this project is not

* An explanation of how the Tube in general, the Tube ULA or Acorn Tube protocols work. Those are very well documented elsewhere
* A finely polished, blockbuster game; it's _Bat'n'Ball_

## How to build the game

You will need:

* GNU Make
* `ca65` and `ld65` from the [cc65](https://cc65.github.io/) compiler suite
* NodeJS (any recent version should be fine, and we are currently using v22.16.0 for no particular reason)
* A BBC Micro emulator with VDFS and 65x family 2nd Processor support (we use [b-em](https://b-em.bbcmicro.com/))

The supplied [makefile](./makefile) has been written for Windows and some of the paths/commands may need to be adjusted in order to get it to build on Linux.

From the command line, inside the root folder, execute:

> make

The output files will be placed in a folder named `vdfs` at the same level as `src`. Temporary files will be placed in `asm-temp`, also at the same level as `src`.

### ca65 and ld65

We don't use BeebAsm because it doesn't follow the generally accepted syntax used by 6502 assemblers and also encourages the use of colon-separated instructions and BBC BASIC style function calls rather than macros, which doesn't suit our programming style.

We make heavy use of `.include` to keep the various concerns separated and navigable - logic, data, macros, helper definitions and the like - and to make them sharable between modules. 

It also avoids the single monolithic source file approach, which we don’t consider maintainable for anything beyond trivial examples.

## Running the game

The build does not create a disc image. Configure the VDFS root in your emulator and then use **Shift+Break** to start the game.

If you prefer to work with disc images, feel free to add a disc image creation step to your own makefile using whatever tooling you like.

## Final notes

You should use a disc that is not write protected when playing the game, otherwise it will not be possible to persist a new high score.

## Reference documentation

[Tube Application Note](http://www.cpu-ns32k.net/files/User_Guide_Tube.pdf) \
(not strictly required to follow the code as it's fairly well commented)

For more in-depth implementation notes, head on over to [Technical Details](./doc/startHere.md).
