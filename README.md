# Hello 👋🏼

On Apple Silcon Mac laptops, Closed-Display Mode may not work as expected after connecting or disconnecting your Mac from an external power source such as a power adapter or display with power delivery. To avoid any issues, you can install a script and configuration file that addresses the issue. 

I'm truely sorry for this, but Apple provides no other way. Apple thinks they know better than you do, and won't allow you to permit Amphetamine to directly install the script and configuration file needed to avoid issues with Closed-Display Mode. To get things to "just work" nowadays, you have to do it yourself it seems. 🔨💪🏼

---

# How To Install Power Protect

<h3>Step One</h3>
<p>
<b><a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Script.zip">Download the Power Protect script</a> and install it in the following location:</b>

<code>/Users/YourUserAccount/Library/Application Scripts/com.if.Amphetamine/</code>
</p>
<h3>Step Two</h3>
<p>
<b><a href="https://raw.githubusercontent.com/x74353/Amphetamine/master/Files/PowerProtect_Configuration.zip">Download the Power Protect configuration file</a> and install it in the following location:</b>

<code>/private/etc/sudoers.d/</code>
</p>
<h3>Step Three</h3>
<p>
Open Terminal.app from ```/Applications/Utilities/```, then copy & paste the following command into a Terminal window:

<code>defaults write com.if.Amphetamine 'Enable Power Protect Install' -bool TRUE</code>

   then press the Return key to execute the command
</p>


