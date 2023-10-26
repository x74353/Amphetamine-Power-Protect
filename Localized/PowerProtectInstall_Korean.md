# 안녕하세요 👋🏼

<b>선호하는 언어로 이 메시지 보기:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">아랍어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">중국어 (간체)</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">네덜란드어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">프랑스어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">영어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">독일어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">일본어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">포르투갈어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">베트남어</a>
<br><br>
Apple Silicon Mac 노트북에서 외부 전원 공급원(예: 어댑터 또는 전원 공급 디스플레이)에 연결 또는 연결 해제한 후, 폐쇄 디스플레이 모드가 예상대로 작동하지 않을 수 있습니다. 문제를 피하려면 문제를 해결하는 스크립트 및 구성 파일을 설치할 수 있습니다.

죄송하지만, Apple은 다른 방법을 제공하지 않습니다. Apple은 사용자보다 더 잘 알고 있다고 생각하며, 폐쇄 디스플레이 모드 문제를 해결하기 위해 필요한 스크립트 및 구성 파일을 직접 설치하는 것을 허용하지 않습니다. 요즘에는 "그냥 작동하게"하려면 스스로 수행해야 하는 것 같습니다. 🔨💪🏼

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
