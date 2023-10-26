# Xin chào 👋🏼
<b>View this message in your preferred language:</b><br><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Arabic.html">العربية</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_ChineseSimplified.html">简体中文<a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Dutch.html">Nederlands</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_French.html">Français</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/">English</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_German.html">Deutsch</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Japanese.html">日本語</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Korean.html">한국어</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Portuguese.html">Português Brasileiro</a><b> | </b><a href="https://x74353.github.io/Amphetamine-Power-Protect/Localized/PowerProtectInstall_Vietnamese.html">Tiếng Việt</a>
<br><br>
Trên các máy tính xách tay Apple Silicon Mac, Chế độ khi Gập Màn hình có thể không hoạt động như mong đợi sau khi bạn kết nối hoặc ngắt kết nối Mac với nguồn điện ngoại như một bộ chuyển đổi nguồn hoặc màn hình có khả năng cung cấp điện. Để tránh mọi vấn đề, bạn có thể cài đặt một tập lệnh và tệp cấu hình giải quyết vấn đề này.

Tôi thật sự xin lỗi vì điều này, nhưng Apple không cung cấp cách khác. Apple nghĩ họ biết rõ hơn bạn và sẽ không cho phép bạn cài đặt trực tiếp bằng Amphetamine tập lệnh và tệp cấu hình cần thiết để tránh vấn đề với Chế độ khi Gập Màn hình. Ngày nay, có vẻ bạn phải tự thực hiện để mọi thứ "hoạt động dễ dàng" hơn. 🔨💪🏼

<h4>Lưu ý: Tính năng này không còn yêu cầu mật khẩu hoặc Touch ID nữa.</h4>

---

## Cách Cài Đặt Power Protect

<h4>Bước Một</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Tải xuống tập lệnh "Power Protect"</a> và cài đặt nó tại vị trí sau:<br>
   
```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h4>Bước Hai</h4>
<a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Tải xuống tệp cấu hình Power Protect</a> và cài đặt nó tại vị trí sau:
   
```
/private/etc/sudoers.d/
```

<h4>Bước Ba</h4>
Mở ứng dụng Terminal từ <i>/Applications/Utilities/</i>, sau đó sao chép và dán lệnh sau vào cửa sổ Terminal:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

sau đó nhấn phím Return để thực hiện lệnh.
