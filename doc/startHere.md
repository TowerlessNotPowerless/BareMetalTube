# Bare Metal Tube: CoPro Bat'n'Ball

## Why not just set the boot option to *RUN?

There's a reason we're using Exec instead of Run for the boot option; ReCo doesn't behave according to the Acorn-defined standard, so the first program you attempt to run on the parasite results in it installing its own version of BASIC and running that instead. I've posted details elsewhere on here before.

Letting that happen and then *EXEC being executed gets around that flaw.

## Code and data integrity

To save wasting time investigating when someone is intentionally trying to be 'clever' with the loader build from Tuesday and the actual game built on Wednesday and says "it's not working", we'll include a binary timestamp in each file that can be validated by each part. Pretty much every file will include that.

## Exports

Whilst ca65/ld65 does export symbols, it doesn't export them as an asm file for inclusion in subsequent modules, so we have written a JavaScript tool to do that for us. Caveats to this approach:

- You can only export labels
- You must export the label immediately after defining it

