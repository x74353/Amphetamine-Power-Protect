# 안녕하세요 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Apple Silicon Mac 노트북에서 디스플레이를 닫았을시는 외부 전원 공급원인 전원 어댑터 또는 전원 공급 디스플레이와 같은 외부 전원 소스를 연결하거나 연결 해제한 후에 예상대로 작동하지 않을 수 있습니다. 어떤 문제를 피하려면 해당 문제를 해결하는 스크립트와 구성 파일을 설치할 수 있습니다.

이 부분에 대해 정말 죄송합니다만, 애플은 다른 방법을 제공하지 않습니다. 애플은 사용자보다 더 잘 안다고 생각하며 디스플레이를 닫았을시의 문제를 피하기 위해 필요한 스크립트와 구성 파일을 직접 설치하도록 Amphetamine에 허용하지 않습니다. 요즘에는 "그냥 작동하게"하려면 스스로 해야 하는 것 같습니다. 🔨💪🏼

## Power Protect 설치 방법

<h4>단계 1</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Power Protect 스크립트 다운로드</a> 및 다음 위치에 설치하십시오:<br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>단계 2</h4>

<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Power Protect 구성 파일 다운로드</a> 및 다음 위치에 설치하십시오:

```
/private/etc/sudoers.d/
```

<h4>단계 3</h4>

터미널 앱을 ```/Applications/Utilities/``` 에서 열고 다음 명령을 복사하여 터미널 창에 붙여 넣으십시오:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

그런 다음 명령을 실행하려면 Return 키를 누르십시오.
