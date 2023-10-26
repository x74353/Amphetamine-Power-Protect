# Hallo 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Op Apple Silicon Mac-laptops werkt de Modus met dichtgeklapt scherm mogelijk niet zoals verwacht na het aansluiten of loskoppelen van uw Mac van een externe stroombron, zoals een voedingsadapter of een beeldscherm met stroomtoevoer. Om eventuele problemen te voorkomen, kunt u een script en een configuratiebestand installeren dat het probleem aanpakt.

Het spijt me echt hiervoor, maar Apple biedt geen andere manier. Apple denkt dat ze het beter weten dan u, en staat niet toe dat u Amphetamine toestemming geeft om het benodigde script en configuratiebestand rechtstreeks te installeren om problemen met de Modus met dichtgeklapt scherm te vermijden. Tegenwoordig moet u het zelf doen lijkt het wel, om ervoor te zorgen dat alles gewoon werkt. 🔨💪🏼

<h4>Opmerking: Deze functie vereist geen wachtwoord of Touch ID meer.</h4>

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


