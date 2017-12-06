# Blueprint Editor!

While editing, or otherwise:
 - "Anchor points" 
  -- Use numpad 1-9 to with a blueprint in hand, to change the point of the blueprint under your mouse
  -- place blueprint from any corner, centre, or part way between them.
  -- commands are editable.
  
 - "COPY"
  -- Ctrl-C by default (editable)
  -- If editing, will copy selection to origin.
  -- If not, will attempt to copy a blueprint in your cursor
  -- otherwise, it stays silent.

Blueprint Editing:
 - Pick up a blueprint, and "assign" it for editing with N (editable), while it's in your hand. 
  -- This should open up the familiar "blueprint edit" screen, but with additional (hidden) features.
  -- If there isn't a blueprint in your hand, the BPEdit will try to open the interface for a 
    blueprint you're already editing (if it's accidentally closed).

 - "Select" an element using the TAB button.
    
 - "Unselect" everything (using E - currently also closes UI). 
    I might need to play with default/multiple key binds

 - Move the "selection" around until you are satisfied with up-down-left-right (editable)
  -- You should see it moving in "real time".
  -- Use "Shift" to move items further.
  
 - Rotate the "selection" (if rotatable in game) by using the R, and Shift-R keys
 
 - Mirror the "selection" (if rotatable in game) by using Shift-M (horisontally), and Ctrl-M (Vertically)
  
 - Press "CAPS LOCK" to "anchor" your blueprint to the "selection". When placing, your blueprint
    will now orientate around that (rather than in the centre of the blueprint)
    
 - You can "nudge" the anchor around, using the normal blueprint movement keys, while having
    nothing selected.

 - "Quick open" inventory for easier access to your existing blueprints by hitting "N" again.
  
 - Use Shift-N (editable) to add: another blueprint from hand (first element only) OR item in hand 
    OR mouseover selection item. 
  -- It should now appear on the blueprint you are editing.
  -- It is instantly "selected"
  
 - Remove an element instantly by pressing the DELETE button.

 - Finish editing by clicking the usual "tick" button, or pressing ENTER.

Notes: 
 - Not tested with full inventory
 - Not tested with combinators / other "oblong" shapes
 - Not tested if it preserves wires
 - Not tested with other mods / bob's stuff
 - May have command incompatibility with Picher Extended - Dollies!
 - Can't check if "tick" button is on the correct/coresponding gui.
 - not fully tested (using something that's not a blueprint in your hand with these commands) yet.