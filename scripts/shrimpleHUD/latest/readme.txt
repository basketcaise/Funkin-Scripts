Thanks for downloading shrimpleHUD!

Before I get into installation instructions... 
If you intend to use this for your mod or video or whatever, please credit me (Basketcaise/NoMoreNuzlocke) and leave a link back to the Gamebanana page.
I'd appreciate it!

---

Installation instructions:
Just place the script corresponding to your version in either the scripts folder or the data folder of the song you want to use the HUD in.

If you don't have a specific mod you want to use the HUD in or you want to use the HUD in all mods, then just place the shrimpleHUD folder inside your Psych Engine mods folder.

Remember, this script only supports Psych Engine versions 0.7.3 and 1.0. Other versions may not display properly or not work at all!

---

Want to add shrimpleHUD compatibility to your mod? Refer to these variables/functions!

shrimple: Global variable that toggles the script altogether. Set with setVar() on the onCreate() callback to use.
lockShrimple: Global variable that toggles the players ability to switch HUD styles. Set with setVar() to use.
shrimpleStyle(HUD:Int, ?print:Bool = false): Global function that sets the current HUD style. First argument is an integer that correlates to hudMap, second optional argument is a bool to display a HUD switch print.

Here's an HScript example of these being used in a song.

function onCreatePost() {
    if (getVar('shrimple')) { // checks if shrimpleHUD is present
        setVar('lockShrimple', true); // prevents the player from switching styles
        shrimpStyle(3); // sets the style to the 3rd hud in the script, which is sKade
    }
}

function onBeatHit() {
    if (getVar('shrimple') && curBeat == 32) shrimpStyle(1); // checks if shrimpleHUD is present and if the current beat is 32, then sets the style to the 1st hud in the script, which is sVanilla
}