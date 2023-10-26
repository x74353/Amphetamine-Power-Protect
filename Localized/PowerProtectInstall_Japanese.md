# こんにちは 👋🏼

<b>お好みの言語でこのメッセージを表示:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">アラビア語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">簡体字中国語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">オランダ語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">フランス語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">英語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">ドイツ語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">韓国語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">ポルトガル語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">ベトナム語</a>
<br><br>
Apple Silicon Macノートブックでは、外部電源供給装置（アダプターまたは電源供給ディスプレイなど）を接続または切断した後、閉じたディスプレイモードが期待どおりに機能しないことがあります。問題を回避するために、問題を解決するスクリプトと構成ファイルをインストールできます。

申し訳ありませんが、Appleは他の方法を提供していません。Appleはユーザーよりもよく知っていると考え、閉じたディスプレイモードの問題を回避するために必要なスクリプトと構成ファイルをAmphetamineが直接インストールすることを許可しません。今日では、問題を自分で解決する必要があるようです。🔨💪🏼

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
