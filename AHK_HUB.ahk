#NoEnv
#SingleInstance Force
;____________________________________________________________
;____________________________________________________________
;//////////////[variables]///////////////
SetWorkingDir %A_ScriptDir%
version = 0.1
appfoldername = AHK_HUB
appFolder = %A_AppData%\%appfoldername%
settingsFolder = %A_AppData%\%appfoldername%\Settings
gameModeFolder = %A_AppData%\%appfoldername%\GameMode
;update stuff
IfExist, %appFolder%\AHK_HUB.ahk
{
    FileDelete, %appFolder%\AHK_HUB.ahk
}
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui]///////////////
Menu Tray, Icon, shell32.dll, 92

Gui -MaximizeBox
Gui Add, Tab3, x0 y0 w727 h422, Game Mode|Asetukset
Gui Tab, 1
Gui Add, GroupBox, x416 y24 w304 h180, Sulje sovellukset
Gui Add, GroupBox, x416 y208 w304 h180, Avaa sovellukset
Gui Add, Button, x6 y358 w88 h32, Game Mode
Gui Add, ComboBox, x424 y48 w282, ComboBox
Gui Add, ComboBox, x424 y232 w282, ComboBox
Gui Add, Text, x424 y80 w86 h23 +0x200, Sovelluksen nimi:
Gui Add, Text, x424 y264 w86 h23 +0x200, Sovelluksen nimi:
Gui Add, Edit, x513 y81 w194 h21
Gui Add, Edit, x514 y265 w194 h21
Gui Add, Button, x632 y176 w80 h23, Uusi sovellus
Gui Add, Button, x632 y360 w80 h23, Uusi sovellus
Gui Add, Button, x536 y176 w80 h23, Vaihda tiedosto
Gui Add, Button, x438 y167 w80 h32, Poista sovellus listasta
Gui Add, Button, x440 y352 w80 h32, Poista sovellus listasta
Gui Add, Button, x536 y360 w80 h23, Vaihda tiedosto
Gui Add, Button, x424 y296 w122 h23, Optimointi sovellukset
;settings tab __________________________________________
Gui Tab, 2
Gui Add, GroupBox, x6 y290 w171 h100, Poista tietoja 
Gui Add, Button, x16 y360 w116 h23 gDeleteAllFiles, Poista kaikki tiedostot
Gui Add, Button, x16 y336 w115 h23 gDeleteAppSettings, Poista asetukset
Gui Add, Button, x16 y312 w154 h23 gDeleteGameMode, Poista Game Mode asetukset
;päivitykset
Gui Add, GroupBox, x8 y200 w203 h80, Päivitykset
Gui Add, CheckBox, x16 y224 w177 h23 vcheckup gAutoUpdates, Tarkista päivitykset aloituksessa
IfExist, %settingsFolder%\Settings.ini
{
    IniRead, t_checkup, %settingsFolder%\Settings.ini, Settings, Updates
	GuiControl,,checkup,%t_checkup%
}
Gui Add, Button, x16 y248 w112 h23 gcheckForupdates, Tarkista päivitykset
;versio
Gui Add, Text, x584 y360 w120 h23 +0x200, Versio = %version%

Gui Show, w724 h394, AHK HUB
;____________________________________________________________
;//////////////[Check for updates]///////////////
IfExist, %settingsFolder%\Settings.ini
{
    IniRead, t_checkup, %settingsFolder%\Settings.ini, Settings, Updates
    if(t_checkup == 1)
    {
        goto checkForupdates
    }
}
Return
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui escape]///////////////
GuiEscape:
GuiClose:
    ExitApp
;____________________________________________________________
;____________________________________________________________
;//////////////[Game Mode]///////////////

;____________________________________________________________
;____________________________________________________________
;//////////////[Poista tiedot]///////////////
DeleteAllFiles:
MsgBox, 1,Oletko varma?, Tämä poistaa kaikki tiedostot, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %appFolder%,1
    ;Reset all settings when settings files are removed
    GuiControl,,checkup,0
}
return
DeleteAppSettings:
MsgBox, 1,Oletko varma?, Tämä poistaa kaikki sovelluksen asetukset, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %settingsFolder%,1
    ;Reset all settings when settings files are removed
    GuiControl,,checkup,0
}
return
DeleteGameMode:
MsgBox, 1,Oletko varma?, Tämä poistaa kaikki Game mode Asetukset, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %gameModeFolder%,1
}
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Asetukset]///////////////

;____________________________________________________________
;//////////////[checkForupdates]///////////////
checkForupdates:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/AHK_HUB/master/Version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "")
{
    if(newversion != version)
    {
        MsgBox, 1,Update,New version is  %newversion% `nOld is %version% `nUpdate now?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            ;Download update
            FileMove, %A_ScriptFullPath%, %appFolder%\%A_ScriptName%, 1
            sleep 1000
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/AHK_HUB/master/AHK_HUB.ahk, %A_ScriptFullPath%
            Sleep 1000
            loop
            {
                IfExist %A_ScriptFullPath%
                {
                    Run, %A_ScriptFullPath%
                }
            }
			ExitApp
        }
    }
}
return
;Check updates on start
AutoUpdates:
Gui, Submit, Nohide
FileCreateDir, %settingsFolder%
IniWrite, %checkup%, %settingsFolder%\Settings.ini, Settings, Updates
return