Thanks for downloading shrimpleHUD!

Before I get into installation instructions... 
If you intend to use this for your mod or video or whatever, please credit me (Basketcaise/NoMoreNuzlocke) and leave a link back to the Gamebanana page.
I'd appreciate it!

---

Installation instructions:
Just place the script corresponding to your version in either the scripts folder or the data folder of the song you want to use the HUD in.

If you don't have a specific mod you want to use the HUD in or you want to use the HUD in all mods, then just place the one of the global folders corresponding to your version inside your Psych Engine mods folder.

Remember, this script only supports Psych Engine versions 0.6.3 and 0.7.2+. Other versions may not display properly or not work at all!

---

Here's an example of how to use the global variables to disable shrimpleHUD on specific songs or mods:

For shrimpleHUD on Psych v0.7.2+:
function onCreate()
	setVar('sHUDEnabled', false)
end

- This method works anywhere regardless of shrimpleHUD's file path

For shrimpleHUD on Psych v0.6.3:
function onCreate()
	setGlobalFromScript('mods/[Global]-sHUD-0.6.3/scripts/sHUD-0.6.3.lua', 'disableShrimpHUD', true)
end

- This method only works if you have the global mod installed and the folder is named '[Global]-sHUD-0.6.3'
- However, you can edit the file path to wherever the script is located to make it work :))