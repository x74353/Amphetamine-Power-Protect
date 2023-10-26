# Olá 👋🏼

Nos laptops Apple Silicon Mac, o Modo com Tela Fechada pode não funcionar como esperado depois de conectar ou desconectar o seu Mac de uma fonte de alimentação externa, como um adaptador de energia ou um monitor com fornecimento de energia. Para evitar problemas, você pode instalar um script e um arquivo de configuração que abordam o problema.

Lamento muito por isso, mas a Apple não oferece outra maneira. A Apple acredita que sabe melhor do que você e não permite que você permita ao Amphetamine instalar diretamente o script e o arquivo de configuração necessários para evitar problemas com o Modo com Tela Fechada. Hoje em dia, parece que você precisa fazer isso por conta própria para que as coisas "simplesmente funcionem". 🔨💪🏼

---

# Como instalar o Power Protect

1. <b>[Baixe o script Power Protect](https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip)</b> e instale-o no seguinte local:
   
     ```/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/```
   <BR><BR>

2. <b>[Baixe o arquivo de configuração do Power Protect](https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip)</b> e instale-o no seguinte local:
   
     ```/private/etc/sudoers.d/```
 <BR><BR>
 
3. Abra Terminal.app em <i>/Applications/Utilities/</i> e copie e cole o seguinte comando em uma janela do Terminal:
   
     ```defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE```

    em seguida, pressione a tecla Return para executar o comando
