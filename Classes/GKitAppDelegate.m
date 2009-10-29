//
//  GKitAppDelegate.m
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GKitAppDelegate.h"

@implementation GKitAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
