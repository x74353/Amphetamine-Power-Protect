# أهلا 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
على أجهزة الكمبيوتر المحمولة Apple Silicon Mac، قد لا يعمل وضع الشاشة المغلقة كما هو متوقع بعد توصيل أو فصل جهاز Mac الخاص بك من مصدر طاقة خارجي مثل محول الطاقة أو الشاشة ذات التغذية بالطاقة. لتجنب أية مشكلات، يمكنك تثبيت سكريبت وملف تكوين يعالج المشكلة.

أنا آسف حقًا لهذا، ولكن Apple لا تقدم وسيلة أخرى. تعتقد Apple أنها تعرف أفضل منك، ولن تسمح لك بالسماح لـ Amphetamine بتثبيت السكريبت وملف التكوين اللازمين لتجنب المشاكل مع وضع الشاشة المغلقة مباشرة. في الوقت الحالي، يبدو أنه يجب عليك القيام به بنفسك لجعل الأمور تعمل "بسهولة". 🔨💪🏼

<h4>ملاحظة: لم يعد هذا الميزة بحاجة إلى كلمة مرور أو معرف اللمس.</h4>
---

كيفية تثبيت "Power Protect"

<h4>الخطوة الأولى</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">قم بتنزيل ملف السكربت "Power Protect"</a> وقم بتثبيته في الموقع التالي:<br>


```/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/```

<h4>الخطوة الثانية</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">قم بتنزيل ملف الضبط "Power Protect"</a> وقم بتثبيته في الموقع التالي:
   
```/private/etc/sudoers.d/```

<h4>الخطوة الثالثة</h4>
افتح تطبيق الطرفية من ***/التطبيقات/أدوات/***, ثم قم بنسخ ولصق الأمر التالي في نافذة الطرفية:
     
```defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE```

ثم اضغط على مفتاح العودة لتنفيذ الأمر.
   
   
