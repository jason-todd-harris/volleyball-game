//
//  AppDelegate.m
//  volleyball
//
//  Created by JASON HARRIS on 11/3/15.
//  Copyright © 2015 Jason Harris. All rights reserved.
//

#import "AppDelegate.h"
#import <Appirater.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GameAndScoreDetails sharedGameDataStore];
    [Appirater setAppId:@"1062974540"];
    [Appirater setDaysUntilPrompt:10];
    [Appirater setUsesUntilPrompt:15];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:5];
    [Appirater setDebug:NO];
    
    //http://stackoverflow.com/questions/29210885/error-itms-90096-your-binary-is-not-optimized-for-iphone-5
    //website to get it working on 7 and below
    
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    /*
     -(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
     {
     if(self.restrictRotation)
     return UIInterfaceOrientationMaskPortrait;
     else
     return UIInterfaceOrientationMaskAll;
     }
     */
    
    return UIInterfaceOrientationMaskLandscape;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
