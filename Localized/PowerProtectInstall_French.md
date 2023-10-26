# Bonjour 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Sur les ordinateurs portables Apple Silicon Mac, le Mode Ecran Fermé peut ne pas fonctionner comme prévu après la connexion ou la déconnexion de votre Mac à partir d'une source d'alimentation externe telle qu'un adaptateur secteur ou un écran avec alimentation. Pour éviter tout problème, vous pouvez installer un script et un fichier de configuration qui résout le problème.

Je suis vraiment désolé pour cela, mais Apple ne propose aucune autre solution. Apple pense qu'ils savent mieux que vous ce qu'il faut faire, et ne vous autorisera pas à permettre à Amphetamine d'installer directement le script et le fichier de configuration nécessaires pour éviter les problèmes avec le Mode Ecran Fermé. De nos jours, il semble que vous devez le faire vous-même pour que les choses "fonctionnent simplement". 🔨💪🏼

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
