# User Testing Checklist – Auth Session Demo App

Tester: ____________________  
Device / OS: ____________________  
App version: 1.0.0+1  
Date: ____________________

| ID | Test scenario | Steps / input | Expected result | Actual result | Status |
|---|---|---|---|---|---|
| UT-01 | Open app without session | Clear app data, launch app | Login screen appears | | |
| UT-02 | Empty username | Leave username empty, enter `1234`, tap Login | Username validation appears | | |
| UT-03 | Short password | Username `admin`, password `123`, tap Login | Password validation appears | | |
| UT-04 | Invalid credentials | `admin / 9999` | “Login failed” message; remain on Login | | |
| UT-05 | Valid credentials | `admin / 1234` | Navigate to Dashboard | | |
| UT-06 | Open Profile | Dashboard → Open Profile | Profile appears | | |
| UT-07 | Logout | Profile → Logout | Return to Login; cannot back to Profile | | |
| UT-08 | Auto-login | Login successfully, fully close and relaunch app | Dashboard appears directly | | |
| UT-09 | Session cleared | Logout, fully close and relaunch app | Login appears | | |
| UT-10 | Password visibility | Toggle eye icon | Password visibility changes | | |
| UT-11 | Loading feedback | Tap Login with valid credentials | Loading indicator appears while request runs | | |
| UT-12 | Unknown route | Navigate to an unknown named route in a test harness | 404 fallback appears | | |

## Bug report template

- Bug ID:
- Title:
- Environment (device / OS / app version):
- Preconditions:
- Steps to reproduce:
- Expected result:
- Actual result:
- Screenshot / log:
- Severity:
- Status (Open / In progress / Fixed / Retest):

> Tester must execute the checklist on a real device or emulator and fill in Actual result and Status. Do not mark tests as passed without executing them.
