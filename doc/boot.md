# Bare Metal Tube: CoPro Bat'n'Ball

## Boot

Once you've pressed `Shift + Break` we can start loading the game. Unfortunately we [can't set the boot option of the disc to *RUN](#why-cant-we-set-the-boot-option-to-run) so we'll need to *EXEC a !Boot file that runs our actual Boot program.

Once that's running we perform some environment checks (which side of the Tube we're running on, the machine type and copro presence), exiting with an error message if any pre-requisites are not satisfied, and can then move on to showing the intro screen.

## The intro screen

Now we can say hello to the user. We spent an unreasonable amount of time deciding how it should look, and because this is a Tube game we wanted something original that stands out and absolutely, categorically does **not** resemble any existing trademarks. So we went with a bold red circle filled in white, a horizontal blue bar across the middle, and crisp white text. Totally original. Completely unique - any resemblance to a well‑known transport logo is purely coincidental and probably your fault.

Now what we _don't_ want to do is load a huge file over the whole screen track by track, because that looks a bit rubbish. Instead, we'll switch the screen off for a moment, build it programmatically and switch the screen back on again afterwards.

We've now reached the point where we start caring about memory usage, so we're going to fiddle around with the CRTC a bit to free up some space.

The first step, though, is to create the character definitions for printing the game's name and other messages on the intro screen. We've built a C# tool for creating those, that loads a PNG image we made in GIMP and separates out the characters. We'll create a tools folder in a bit and pop that in there. For now, we'll just include the output in this project.

Now that's all in place we start preparing the screen. First we switch to MODE 1 using OSWRCH so the OS can do the grunt work. Then we switch off the screen, resett NuLA, set up our fallback palette for those who don't have NuLA, and reconfigure the screen dimensions ready for when we've finished drawing our 'unique' masterpiece.


#### Why can't we set the boot option to *RUN?

ReCo copros don't behave according to the Acorn-defined standard, so the first program you attempt to run on the parasite results in it installing its own version of BASIC and running that instead.

Letting that happen and then *EXEC being executed gets around that flaw.

It's not actually relevant for the boot program that runs on the host but it would hurt us later.

