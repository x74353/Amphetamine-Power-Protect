# Hallo 👋🏼

<b>Bekijk dit bericht in uw voorkeurstaal:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">Arabisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">Chinees (Vereenvoudigd)</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Frans</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">Engels</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Duits</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">Japans</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">Koreaans</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Portugees</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Vietnamees</a>
<br><br>
Op Apple Silicon Mac-laptops werkt de Gesloten-schermmodus mogelijk niet zoals verwacht na het aansluiten of loskoppelen van uw Mac van een externe voedingsbron, zoals een voedingsadapter of een scherm met stroomvoorziening. Om problemen te voorkomen, kunt u een script en een configuratiebestand installeren dat het probleem aanpakt.

Het spijt me zeer, maar Apple biedt geen andere optie. Apple denkt dat ze het beter weten dan u en staat niet toe dat Amphetamine het script en het configuratiebestand direct installeert dat nodig is om problemen met de Gesloten-schermmodus te voorkomen. Het lijkt erop dat u tegenwoordig zelf moet handelen om dingen 'gewoon te laten werken'. 🔨💪🏼

## Hoe u Power Protect installeert

<h4>Stap Eén</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Download het Power Protect-script</a> en installeer het op de volgende locatie:<br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>Stap Twee</h4>

<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Download het Power Protect-configuratiebestand</a> en installeer het op de volgende locatie:

```
/private/etc/sudoers.d/
```

<h4>Stap Drie</h4>

Open Terminal.app vanuit ```/Applications/Utilities/```, kopieer vervolgens de volgende opdracht en plak deze in een Terminal-venster:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

druk vervolgens op de Return-toets om de opdracht uit te voeren.


