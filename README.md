Bump API 3.0
============

This is an all-new version of the Bump iOS API. 

Highlights
==========

* faster, smaller. ~400kB is added to an ARM binary after linking. 
* block/GCD based callbacks.
* multiple concurrent sessions: once two users have matched, they can continue to send data to each other and other users
* at the moment breaks compatibility with earlier versions of the API

Getting Started
=======

1. Agree to the API license agreement and get your API key: http://bu.mp/apiagree
1. Add libBump.a and BumpClient.h to your Xcode project.
1. Ensure that your target is linked against libBump.a, CFNetwork.framework, CoreLocation.framework, and AudioToolbox.framework.
1. Configure your client:
    `[BumpClient configureWithAPIKey:@"your_api_key" andUserID:[[UIDevice currentDevice] name]];`

Congrats, that's it.  Your app is now bumpable!

Notes
=====

1. Use of this library is subject to both our SDK License agreement, http://bu.mp/licagr_internaluse, and Trademark Guidelines: http://bu.mp/apitrademark
1. Android builds coming soon.
1. Please submit comments and questions to tg@bu.mp

Release Notes
=============

3.1
---
* fixes leak when no internet connection is present
* fixes 'Somebody' userID bug
* removes a compiler warning when linking against the library

3.01
---
* fixes userId configuration bug
* adds optional disconnect/connect calls (first call to sharedClient auto-connects)

3.0
--- 
* setBumpable turns location updates on/off
* userIDForChannel returns empty string when other user's name is unset

RC1
---

* removes use of [[UIDevice currentDevice] uniqueIdentifier]
* includes armv6 binary 

Beta 3
------
* Additional power saving measures when bumping disabled
* Fixes two internal bugs, one of which means that it will not match with earlier betas

Beta 2
------
* callback structure changed: BumpClient calls its `matchBlock` when a match occurs.  In order to create a channel (and send data), both users most call `[[BumpClient sharedClient] confirmMatch:YES onChannel:channel];`. When both users confirm a channel, then `BumpClient` will callback its `channelConfirmedBlock`.
* See updated examples for this new structure
* API key status notification on stderr.

Complete Example
================

```Objective-C
- (void) configureBump {
    // userID is a string that you could use as the user's name, or an ID that is semantic within your environment
    [BumpClient configureWithAPIKey:@"your_api_key" andUserID:[[UIDevice currentDevice] name]];

    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) { 
		NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]); 
		[[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
		NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
		[[BumpClient sharedClient] sendData:[[NSString stringWithFormat:@"Hello, world!"] dataUsingEncoding:NSUTF8StringEncoding]
                                  toChannel:channel];
    }];

    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
		NSLog(@"Data received from %@: %@", 
		[[BumpClient sharedClient] userIDForChannel:channel], 
		[NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding]);
    }];


    // optional callback
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
		if (connected) {
			NSLog(@"Bump connected...");
		} else {
			NSLog(@"Bump disconnected...");
		}
    }];

    // optional callback
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
		switch(event) {
		    case BUMP_EVENT_BUMP:
				NSLog(@"Bump detected.");
				break;
		    case BUMP_EVENT_NO_MATCH:
				NSLog(@"No match.");
				break;
		}
    }];
} 
```
