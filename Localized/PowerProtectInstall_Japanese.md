# こんにちは 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Apple Silicon Macノートブックでは、外部電源アダプタや電源供給付きディスプレイなどの外部電源からMacを接続または切断した後、クラムシェルモードが予想どおりに動作しないかもしれません。問題を回避するために、問題を解決するスクリプトと設定ファイルをインストールできます。

申し訳ありませんが、Appleには他の方法はありません。Appleはあなたよりもよく知っていると考え、クラムシェルモードの問題を回避するために必要なスクリプトと設定ファイルをAmphetamineに直接インストールすることを許可しません。最近では、"簡単に動作する"ために自分で行う必要があるようです。🔨💪🏼

## Power Protectのインストール方法

<h4>ステップ1</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Power Protectスクリプトをダウンロード</a>し、次の場所にインストールしてください:<br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>ステップ2</h4>

<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Power Protect構成ファイルをダウンロード</a>し、次の場所にインストールしてください:

```
/private/etc/sudoers.d/
```

<h4>ステップ3</h4>

Terminal.app ```/Applications/Utilities/``` から開き、次のコマンドをコピーしてターミナルウィンドウに貼り付けてください:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

その後、コマンドを実行するためにReturnキーを押してください。
