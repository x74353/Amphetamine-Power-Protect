# Olá 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Nos laptops Apple Silicon Mac, o Modo com Tela Fechada pode não funcionar como esperado depois de conectar ou desconectar o seu Mac de uma fonte de alimentação externa, como um adaptador de energia ou um monitor com fornecimento de energia. Para evitar problemas, você pode instalar um script e um arquivo de configuração que abordam o problema.

Lamento muito por isso, mas a Apple não oferece outra maneira. A Apple acredita que sabe melhor do que você e não permite que você permita ao Amphetamine instalar diretamente o script e o arquivo de configuração necessários para evitar problemas com o Modo com Tela Fechada. Hoje em dia, parece que você precisa fazer isso por conta própria para que as coisas "simplesmente funcionem". 🔨💪🏼

<h4>Observação: Esta funcionalidade não requer mais senha ou Touch ID.</h4>

## Como Instalar Power Protect

<h4>Passo Um</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Baixe o script Power Protect</a> e instale-o no seguinte local:<br>
  
```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>Passo Dois</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Baixe o arquivo de configuração Power Protect</a> e instale-o no seguinte local:
   
```
/private/etc/sudoers.d/
```
 
<h4>Passo Três</h4>
Abra o Terminal.app a partir de <i>/Applications/Utilities/</i>, em seguida, copie e cole o seguinte comando em uma janela do Terminal:
   
```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

em seguida, pressione a tecla Enter para executar o comando.
