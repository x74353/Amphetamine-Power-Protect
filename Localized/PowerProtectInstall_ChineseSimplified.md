# 你好 👋🏼

<b>用您偏好的语言查看此消息:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">阿拉伯语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">荷兰语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">法语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">英语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">德语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">韩语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">葡萄牙语</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">越南语</a>
<br><br>
在Apple Silicon Mac笔记本上，连接或断开Mac与外部电源适配器或带电源传递的显示器等外部电源后，关闭显示模式可能无法按预期工作。为了避免问题，您可以安装脚本和配置文件来解决问题。

非常抱歉，但苹果没有提供其他方法。苹果认为他们了解得比您更多，不允许Amphetamine直接安装所需的脚本和配置文件，以避免关闭显示模式的问题。如今，似乎必须自行解决问题，使事情“正常工作”。🔨💪🏼

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
