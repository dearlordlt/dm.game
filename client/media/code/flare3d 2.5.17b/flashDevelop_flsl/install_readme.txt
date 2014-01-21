1) Open Flash Devlop and go to 

Tools -> Open Application Files

Copy the Settings and Templates folders there.

2) Open with any xml editor "FlashDevelop install folder\Settings\ScintillaNET.xml"

and add the following line

<include file="$(BaseDir)\Settings\Languages\FLSL.xml" />

Restart Flash Develop ;)