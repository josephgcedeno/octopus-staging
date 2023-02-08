# Project Octopus

Nuxify's very own, all-in-one, workflow tool based on a custom Agile workflow.

## Features

- [x] Login
- [x] Time In / Time Out
- [x] Reminders Panel
- [x] Daily Standup Report
- [x] Leaves Tracking & Requests
- [x] Credentials List
- [x] HR Files (Static)
- [x] Admin Panel
- [x] Accomplishments Generator (via Admin Panel)
- [x] Create Account (via Admin Panel)
- [x] Mobile Application
- [x] Web Application
- [x] Desktop App (Windows/macOS)


- [ ] Work Analytics
- [ ] Automated Payslip Generation


Coming soon to Play Store & App Store.



## Build steps

All these steps are assuming you're using VS Code as your editor.

1. Make sure that the [Flutter SDK](https://flutter.dev/docs/get-started/install) is installed on your machine. 
- The installation of the SDK requires plenty of other software such as **Android Studio** and **Xcode** (if you're developing in Mac). Ensure that you have these too.

2. You can run the project in multiple ways:
- Android Emulator (Open Android Studio -> Configure -> AVD Manager)
- iOS Simulator (Run ```open -a Simulator``` in the Terminal)
- Physical device (Connect phone to your development machine)

3. Run the command ``make`` on the Terminal. This will automatically run a sequence of commands such as ```make install``` that are necessary for running the project.

4. Voila! The project should now be running on your designated simulator/device.

To use Flutter debug tools, go to Run -> Start Debugging in VS Code.

See Makefile for other commands.

Made with ❤️ at [Nuxify](https://nuxify.tech)
