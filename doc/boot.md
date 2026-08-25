# Bare Metal Tube: CoPro Bat'n'Ball

## Loading: Boot

Once you've pressed `Shift + Break` we can start loading the game. Unfortunately we [can't set the boot option of the disc to *RUN](#why-cant-we-set-the-boot-option-to-run) so we'll need to *EXEC a !Boot file that runs our actual Boot program.

Once that's running we perform some environment checks (which side of the Tube it's running on, machine type and copro presence) and can then move on to showing the intro screen.


### Why can't we set the boot option to *RUN?

ReCo copros don't behave according to the Acorn-defined standard, so the first program you attempt to run on the parasite results in it installing its own version of BASIC and running that instead.

Letting that happen and then *EXEC being executed gets around that flaw.

It's not actually relevant for the boot program that runs on the host but it would hurt us later.

