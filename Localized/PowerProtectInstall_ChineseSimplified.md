# 你好 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
在Apple Silicon Mac笔记本上，连接或断开Mac与外部电源适配器或带电源传递的显示器等外部电源后，显示器关闭模式可能无法按预期工作。为了避免任何问题，您可以安装一个脚本和配置文件，来解决这个问题。

对此我深感抱歉，但苹果没有提供其他方法。苹果认为他们比您更懂，不会允许您允许Amphetamine直接安装所需的脚本和配置文件，以避免显示器关闭模式的问题。现在，似乎必须亲自去做，才能使事情“正常工作”。🔨💪🏼

<h4>注意：此功能不再需要密码或触摸ID。</h4>

## 安装Power Protect的步骤

<h4>第一步</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">下载Power Protect脚本</a>并将其安装在以下位置：<br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>第二步</h4>

<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">下载Power Protect配置文件</a>并将其安装在以下位置：

```
/private/etc/sudoers.d/
```

<h4>第三步</h4>

从```/应用程序/实用工具/```打开终端.app，然后将以下命令复制并粘贴到终端窗口中：

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

然后按回车键执行命令。
