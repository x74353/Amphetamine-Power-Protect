# Bonjour 👋🏼

<b>Consultez ce message dans votre langue préférée :</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">Arabe</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">Chinois (simplifié)<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Néerlandais</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">Anglais</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Allemand</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">Japonais</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">Coréen</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Portugais</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Vietnamien</a>
<br><br>
Sur les ordinateurs portables Apple Silicon Mac, le mode "Fermeture du couvercle" peut ne pas fonctionner comme prévu après avoir connecté ou déconnecté votre Mac d'une source d'alimentation externe telle qu'un adaptateur secteur ou un écran avec alimentation. Pour éviter tout problème, vous pouvez installer un script et un fichier de configuration qui résolvent ce problème.

Je suis vraiment désolé pour cela, mais Apple ne fournit aucune autre solution. Apple pense qu'elle sait mieux que vous, et ne vous permettra pas d'autoriser Amphetamine à installer directement le script et le fichier de configuration nécessaires pour éviter les problèmes avec le mode "Fermeture du couvercle". Pour que les choses fonctionnent "comme il faut" de nos jours, il semble que vous deviez le faire vous-même. 🔨💪🏼

## Comment installer Power Protect

<h4>Étape un</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Téléchargez le script Power Protect</a> et installez-le à l'emplacement suivant :<br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>Étape deux</h4>

<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Téléchargez le fichier de configuration Power Protect</a> et installez-le à l'emplacement suivant :

```
/private/etc/sudoers.d/
```

<h4>Étape trois</h4>

Ouvrez Terminal.app depuis ```/Applications/Utilities/```, puis copiez et collez la commande suivante dans une fenêtre du Terminal:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

puis appuyez sur la touche Entrée pour exécuter la commande.
