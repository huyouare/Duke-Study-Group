//
//  AppDelegate.m
//  DukeStudy
//
//  Created by Jesse Hu on 9/13/14.
//  Copyright (c) 2014 Jesse Hu. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "AppConstant.h"

#import "AppDelegate.h"
#import "GroupView.h"
#import "PrivateView.h"
#import "ProfileView.h"
#import "NavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"SgbZOZ1OPs3pSiC3H9vDZ9ZqF1NFYDQ75jgWAkWK"
                  clientKey:@"jg9PNPhgqaMNpb1x683mGCERM4lJ1QX5SAIKk2Zs"];
    
    [PFFacebookUtils initializeFacebook];
    
    [PFImageView class];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NavigationController *nc1 = [[NavigationController alloc] initWithRootViewController:[[GroupView alloc] init]];
//	NavigationController *nc2 = [[NavigationController alloc] initWithRootViewController:[[PrivateView alloc] init]];
	NavigationController *nc3 = [[NavigationController alloc] initWithRootViewController:[[ProfileView alloc] init]];
    
	self.tabBarController = [[UITabBarController alloc] init];
	self.tabBarController.viewControllers = [NSArray arrayWithObjects:nc1, nc3, nil];
	self.tabBarController.tabBar.barTintColor = COLOR_TABBAR_BACKGROUND;
	self.tabBarController.tabBar.tintColor = COLOR_TABBAR_LABEL;
	self.tabBarController.tabBar.translucent = NO;
	self.tabBarController.selectedIndex = 0;
    
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Facebook responses

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

@end
