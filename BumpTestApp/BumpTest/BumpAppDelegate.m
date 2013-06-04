//
//  BumpAppDelegate.m
//  BumpTest
//
//  Created by Thomas Greany on 1/26/12.
//  Copyright (c) 2012 Bump Technologies, Inc. All rights reserved.
//

#import "BumpAppDelegate.h"

#import "BumpViewController.h"
#import "BumpClient.h"

@implementation BumpAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}


- (void) configureBump {
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

    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
        } else {
            NSLog(@"Bump disconnected...");
        }
    }];

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

    [[BumpClient sharedClient] setBumpable:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[BumpViewController alloc] initWithNibName:@"BumpViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[BumpViewController alloc] initWithNibName:@"BumpViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [self configureBump];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
