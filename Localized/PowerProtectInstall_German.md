# Hallo 👋🏼

Auf Apple Silicon Mac-Laptops funktioniert der Display-Geschlossen-Modus möglicherweise nicht wie erwartet, nachdem Sie Ihren Mac von einer externen Stromquelle wie einem Netzteil oder einem Display mit Stromversorgung angeschlossen oder getrennt haben. Um mögliche Probleme zu vermeiden, können Sie ein Skript und eine Konfigurationsdatei installieren, die das Problem beheben.

Es tut mir wirklich leid dafür, aber Apple bietet keine andere Möglichkeit. Apple glaubt, sie wissen besser als Sie, und erlaubt Ihnen nicht, Amphetamine die direkte Installation des benötigten Skripts und der Konfigurationsdatei zur Vermeidung von Problemen mit dem Display-Geschlossen-Modus zu erlauben. Heutzutage müssen Sie anscheinend selbst Hand anlegen, um die Dinge zum "einfach funktionieren" zu bringen. 🔨💪🏼

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
