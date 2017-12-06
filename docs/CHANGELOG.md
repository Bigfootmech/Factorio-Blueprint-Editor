TODO:
ALL THE THINGS (read the "a Blueprint Editing.txt" file in the notes repo

0.2.4 (2017.12.06)
Hoo boy. Big break. Basically I've been playing other stuff. Now I felt like working on this a bit again.

This update should basically allow you to add non-blueprint objects with the "add" hotkey.

Fun fact: not tested with things that aren't allowed in blueprints (like cars I presume)

0.2.3 (2017.11.12)
All anchors should now keep the whole blueprint "on grid". No more going off grid (hopefully)

0.2.2 (2017.11.11)
Rotating oblong shapes should now stay on-grid
Changed default "move" action to be 1 and 5 tiles (no going off grid)
Bugfix: Fixed a bug where some objects weren't being moved correctly.

0.2.1 (2017.11.10)
Placing objects now places them correctly on-grid

0.2.0 (2017.11.09)
Added "Unselect" (E)
Removes selection.

This finishes my list of commands I plan to be usable. But I'm not happy with so many other things >.<

It feels like this will never be finished

0.1.12 (2017.11.09)
Added "Copy" (Ctrl-C)
Either full blueprint, or per element selection.

0.1.11 (2017.11.09)
Added "Delete" (Del button) of individual elements. Want to add a safety, but will leave as is for now.
Upgraded amount of ordered options that can be added (I went over 26 keybinds).
Decided for some reason that "selected elements" had to be a Set of Numbers, so introduced a new
    object, as well as generics to Lua
Also added a way of integration testing (Tried cucumber. failed. Tried busted. failed. 
    Did it with luaunit, but then got bored, and just fixed the damn errors with manual testing). 
Worked on continuous integration, but haven't gotten one to work yet (found out appveyor is windows
    only, circle ci is a pain in the arse for config, and travis took a long time to find the docs,
    now I'm stuck on that it seems to not be running python subprocess the way that it works
    on my local machine).
Fixed a minor issue with binding to corner while "editing" filling up your inventory.
    

Basically, I started adding this command, by saying it'll be easy, then all the things went slightly
    wonkey, and I tried to fix everything, and it was too much to fix all at once.
Lots of behind the scenes. 
Lots of experiments that failed. 
As well as real life getting in the way.

0.1.10 (2017.11.03)
Added "mirroring" (Ctrl- and Shift-M). Yeah, bigger delay than usual. I was trying a fix, which 
    ended up not working, and did a lot of background dev-qol/code quality stuff. 
    Up shot: I have like 60 downloads for this version now (260 total!) :P

0.1.9 (2017.11.01)
Added "ENTER" button to finish editing. Tick still works as well. This is fairly preemptive for possible future updates
	as well as not having to rely on GUI for an essential function.
Decent amount of DEV_QOL under the hood. Keybinds class looks completely different now.

0.1.8 (2017.11.01)
Fixed a major bug where commands, and data weren't restoring properly on save -> load
	(thanks for the early heads up eradicator on how Factorio stores data, and Stumpyofpain for reporting the bug)

0.1.7 (2017.10.31)
Added ability to "move" entire blueprint (ie: nudge anchor point around)

0.1.6 (2017.10.31)
Added single-element Rotation functionality

0.1.5 (2017.10.30)
Added Numpad Anchor functionality

0.1.4 (2017.10.29)
Added "Select" (TAB) functionality

0.1.3 (2017.10.29)
Fancied adding https://forums.factorio.com/viewtopic.php?f=6&t=49445 since people seemed interedted
And it was a QOL change that I had wanted too.

Added something along those lines.

Currently, you can use "CAPS LOCK" to "lock in" selection as the "anchor"

Basically, when you finish editing the blueprint (click tick), your new anchor will now be the origin
point for your blueprint.

Also a few fixes / QOLs for myself as a dev along the way too.

0.1.2 (2017.10.29)
Fixed a bug where commands weren't showing up/editable in the commands/mods menu
Made deployment semi-automatic, and added file generation. Should be no more screwing with bugs like that, 
    and deployments should now be easier for me. As well as having a nicer-looking directory structure in git.

0.1.1 (2017.10.28)
(hopefully) Fixed a bug eradicator found, with directions.
(behind the scenes) Changed "Table" to be "Map", as that's what I see it as.

0.1.0 (2017.10.27)
First fast out-the-door entry.

It will kind-of work. But expect it to be nothing short of unstable garbage.

DO NOT USE if you aren't comfortable with your game crashing.

Read the Readme for instructions of how to use it.

0.0.3
Rewriting a bunch of the core code to be more standardized. 
Stdlib rejected as a concept, because it doesn't implement the things I need in the way I need them.
It would be more effort to repurpose it for my project than making my own.

Directory structure improved
License chosen in anticipation of "public release"
Docs added to main folder

Somewhere along the lines I was thinking "well THIS is just a showcase..." at which point I realized that I'd done that a couple of times already.
Which means this is now the "third" iteration. ie:0.0.3, even though it hasn't seen the light of day yet.

I may go through more, depending on how I feel about the data-preservation for blueprints.
(I don't, don't, DON'T want people to freak out because I destroyed their blueprints. Because that's exactly what I'd do.)
(I'm also really lazy, and don't want to have to deal with data migrations yet, if I can help it)

0.0.2
Creating basic mod

Currently, a botch job. 
It will LET you edit blueprints. 
But I won't promise that it will be good.

Discovered a show-stopper bug where I was holding on to the hand, rather than a specific blueprint.

0.0.1
Scripts in game