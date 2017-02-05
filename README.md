# NearBus

Generic Features:
- App built using MVVM design pattern and Swift 3.0..
- Some Unit Test cases included.
- Mock Objects also present for Test cases.
- Added a button to goto DummyLocation in case no Bus Stops in your current area.
- No JSON parsing library used, Models parse the json respone.
- No Networking Library used, App has a Network Layer of its' own built using URLSession class.
- Radius can be changed Via "Set Radius" button on navigation bar of Home View.
- GPX file added with Dummy Location to test on simulators.
- No gitignore for simplicity
- Uses GoogleMaps instead of Apple Maps, no particular reason for this.
- Rotation and iPad are supported.
- Swift print() function overridden so that it can be used freely, and will print data only in DEBUG mode.
- Dummy Assets used in App.

Caching:
- I felt only 1 genuine used case for caching, i.e. the route of buses. They are being saved in UserDefaults since size is small.
- Saving such data in UserDefaults is not an ideal case, but done so for simplicity.
- Some mechanism should be added to clear the cache using some policy like Expiring after some time or storing only latest values.

Proposed Improvements:
- A cleaner approach on caching, by using Realm/CoreData.
- Handle No Internet case and show relevant error Messages.
- Add more Unit Test Cases.
- Add UI Test Cases.

Instructions:
- Open the app in Xcode 8+.
- Pods also pushed to the Repo for simplicity.
- To run the app, CMD + R.
- To run Test cases CMD + U.
