# Xin chào 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Trên các máy tính xách tay Apple Silicon Mac, Chế độ khi Gập Màn hình có thể không hoạt động như mong đợi sau khi bạn kết nối hoặc ngắt kết nối Mac với nguồn điện ngoại như một bộ chuyển đổi nguồn hoặc màn hình có khả năng cung cấp điện. Để tránh mọi vấn đề, bạn có thể cài đặt một tập lệnh và tệp cấu hình giải quyết vấn đề này.

Tôi thật sự xin lỗi vì điều này, nhưng Apple không cung cấp cách khác. Apple nghĩ họ biết rõ hơn bạn và sẽ không cho phép bạn cài đặt trực tiếp bằng Amphetamine tập lệnh và tệp cấu hình cần thiết để tránh vấn đề với Chế độ khi Gập Màn hình. Ngày nay, có vẻ bạn phải tự thực hiện để mọi thứ "hoạt động dễ dàng" hơn. 🔨💪🏼

---

# Cách cài đặt Power Protect

1. <b>[Tải xuống tập lệnh Power Protect](https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip)</b> và cài đặt tập lệnh đó ở vị trí sau:
   
     ```/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/```

3. <b>[Tải xuống tệp cấu hình Power Protect](https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip)</b> và cài đặt tệp đó ở vị trí sau:
   
     ```/private/etc/sudoers.d/```

5. Mở Terminal.app từ ```/Applications/Utilities/```, sau đó sao chép và dán lệnh sau vào cửa sổ Terminal:

     ```defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE```

    sau đó nhấn phím Return để thực hiện lệnh
