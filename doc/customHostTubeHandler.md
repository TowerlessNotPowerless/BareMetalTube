# Bare Metal Tube: CoPro Bat'n'Ball

## Custom host Tube handler

We'll build this as a separate component so that we don't get bogged down with relocation and the likes, and include it in the boot file as a binary blob that we can move into place when we're ready. 

This _might_ actually mean the game will run with only BASIC and Acorn DFS 0.90 installed (and a 65x 2nd Processor) because up to this point there has been no reliance on an existing Tube handler - all we've done is check whether the OS thinks there's a copro attached so that we can proceed with installing our own handler. We'll test and confirm (or not) later.

For the handler itself, all we are interested in at this point is handling the standard $406 reason codes (with a tweak to one of them that we'll come to in a bit) so that the filing system can operate as normal for load and save operations, and OSFILE of course, so that the parasite can load and save files. Nothing else from the Acorn protocol is required, literally nothing.

So, that tweak. In the Acorn implementation, reason code 4 (Execute on parasite) never returns to the program that called it on the host. Instead, it enters a tight loop, waiting for commands from the parasite. We're not going to do that. It will mean that we can start a program running on the parasite and continue on the host right where we left off. We will implement a host Tube loop but we don't need one yet.

This leaves in the position where we can run a loader program on the parasite, wait for it to say hello, confirm it's running a version of itself that is from the same build as the boot program, and then continue with loading and running the game. No fiddling around with intercepting vectors was required - both CPUs are now able to communicate and under our full control. We will be extending the host Tube code later to handle OSFILE and what we'll call Out Of Band messages from the parasite a little later.

If the parasite doesn't complete the handshake within a reasonable amount of time, we can deduce that it's either the wrong CPU type or is part of a different build, and never will, so we can abort on the host side and show the user something meaningful.

