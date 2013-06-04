//
//  BumpClient.h
//
//  Created by Thomas Greany on 10/21/11.
//  Copyright 2011 Bump Technologies, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned long long BumpChannelID;

typedef enum {
    BUMP_EVENT_BUMP = 0,
    BUMP_EVENT_NO_MATCH = 1,
} bump_event;

typedef void (^BumpEventBlock)(bump_event event);
typedef void (^BumpMatchBlock)(BumpChannelID channelID);
typedef void (^BumpChannelConfirmedBlock)(BumpChannelID channelID);
typedef void (^BumpConnectionStateChangedBlock)(BOOL connectedToBumpServer);
typedef void (^BumpDataReceivedBlock)(BumpChannelID channel, NSData *data);

@interface BumpClient : NSObject {}

+ (BumpClient *) sharedClient;

- (void) connect; // the first call to sharedClient calls this already
- (void) disconnect;

// required configuration
+ (void) configureWithAPIKey : (NSString *) key andUserID : (NSString *) userName;
- (void) setMatchBlock : (BumpMatchBlock) matchBlock;
- (void) setChannelConfirmedBlock : (BumpChannelConfirmedBlock) confirmedBlock;

// channel methods
- (void) confirmMatch : (BOOL) confirmed onChannel : (BumpChannelID) channel;

// data must be less than 512kB in size.
- (void) sendData : (NSData *) data toChannel : (BumpChannelID) channel;
- (NSString *) userIDForChannel : (BumpChannelID) channelID;

// optional blocks
- (void) setConnectionStateChangedBlock : (BumpConnectionStateChangedBlock) connectionBlock;
- (void) setBumpEventBlock : (BumpEventBlock) bumpEventBlock;
- (void) setDataReceivedBlock : (BumpDataReceivedBlock) dataReceivedBlock;

// turn bumping on/off; defaults to YES.
@property (nonatomic) BOOL bumpable;

// specify dispatch queue that callback blocks should placed on. 
// if unset, the main queue is used.
- (void) setCallbackQueue : (dispatch_queue_t) callbackQueue;

// bump simulation
- (void) simulateBump;


@end
