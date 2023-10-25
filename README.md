# Hello 👋🏼

On Apple Silcon Mac laptops, Closed-Display Mode may not work as expected after connecting or disconnecting your Mac from an external power source such as a power adapter or display with power delivery. To avoid any issues, you can install a script and configuration file that addresses the issue. 

I'm truely sorry for this, but Apple provides no other way. Apple thinks they know better than you do, and won't allow you to permit Amphetamine to directly install the script and configuration file needed to avoid issues with Closed-Display Mode. To get things to "just work" nowadays, you have to do it yourself it seems. 🔨💪🏼

---

# How To Install Power Protect

<h3>Step One</h3>
<b><a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Download the Power Protect script</a> and install it in the following location:</b><br>

```
/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/
```

<h3>Step Two</h3>

<b><a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Download the Power Protect configuration file</a> and install it in the following location:</b>

```
/private/etc/sudoers.d/
```

<h3>Step Three</h3>

Open Terminal.app from ```/Applications/Utilities/```, then copy & paste the following command into a Terminal window:

```
defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE
```

then press the Return key to execute the command



