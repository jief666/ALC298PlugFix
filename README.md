ALCPlugFix - Use for ALC 298
----------

This is an improved version of ALCPlugFix from [goodwin](https://github.com/goodwin/ALCPlugFix).
2020-06 Merge back version from Prefzei repo

The original and this fork tries to fix headphone audio power state issue in non Apple sound card in macOS.

The improvement include:

 - Refactor
 - Add listener when sleep/wake
 - Fix on sleep wake
 - Let you choose `hda-verb` so it don't need be in `$PATH`
 - Enable launching as LauchDaemon
 - Bug fix
 - Install.sh script with update support
 - Uninstall.sh to uninstall ALCPlugFix
 - macOS Catalina support

Install
-------

Running `sh install.sh` will install to `/user/local/bin` (no need to be in the install.sh folder anymore).

By default it search `hda-verb` in current work directory, if not found it will search in `$PATH` _(May not work when it is running from LaunchDaemon because it is using as root)_.

Compatible Laptops
------------------
- Dell XPS 9560, and, I suppose, all other using ALC298

Build
-----
`xcodebuild -target ALCPlugFix`

Debug
-----

Add following to launchDaemon file to log to `/tmp/ALCPlugFix.log`, _(or use `log stream`)_

```
	<key>StandardOutPath</key>
	<string>/tmp/ALCPlugFix.log</string>
	<key>StandardErrorPath</key>
	<string>/tmp/ALCPlugFix.log</string>
```

Credits
-----

- Goodwin for creating the Software
- Menchen for the refactoring and new features
- Joshuaseltzer for creating new install.sh and uninstall.sh
- Sniki for maintaining the software
- Profzei


