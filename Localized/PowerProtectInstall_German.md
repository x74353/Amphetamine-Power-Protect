# Hallo 👋🏼

<b>Diese Nachricht in Ihrer bevorzugten Sprache anzeigen:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">Arabisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">Chinesisch (Vereinfacht)<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Niederländisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Französisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">Englisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">Japanisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">Koreanisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Portugiesisch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Vietnamesisch</a>
<br><br>
Auf Apple Silicon Mac-Laptops funktioniert der Closed-Display-Modus möglicherweise nach dem Anschließen oder Trennen Ihres Mac von einer externen Stromquelle wie einem Netzteil oder einem Display mit Stromversorgung nicht wie erwartet. Um Probleme zu vermeiden, können Sie ein Skript und eine Konfigurationsdatei installieren, die das Problem beheben.

Es tut mir wirklich leid, aber Apple bietet keine andere Möglichkeit. Apple glaubt, dass sie es besser wissen als Sie und erlaubt es nicht, Amphetamine direkt das Skript und die Konfigurationsdatei zu installieren, die erforderlich sind, um Probleme mit dem Closed-Display-Modus zu vermeiden. Es scheint, dass Sie heutzutage selbst handanlegen müssen, um die Dinge "einfach funktionieren zu lassen". 🔨💪🏼

## So installieren Sie Power Protect

<h4>Schritt Eins</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Laden Sie das Power Protect Skript herunter</a> und installieren Sie es an folgendem Ort:<br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>Schritt Zwei</h4>

<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Laden Sie die Power Protect Konfigurationsdatei herunter</a> und installieren Sie sie an folgendem Ort:

```
/private/etc/sudoers.d/
```

<h4>Schritt Drei</h4>

Öffnen Sie Terminal.app unter ```/Applications/Utilities/```, kopieren Sie dann den folgenden Befehl und fügen Sie ihn in ein Terminalfenster ein:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

drücken Sie dann die Eingabetaste, um den Befehl auszuführen.
