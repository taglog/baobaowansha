//
//  AppDelegate.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideViewController.h"
#import "LeftViewController.h"
#import "HomeViewController.h"
#import "InitProfileViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    //判断是否是第一次启动app
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        InitProfileViewController *initView = [[InitProfileViewController alloc] init];
        UINavigationController *initNavigation = [[UINavigationController alloc] initWithRootViewController:initView];
        self.window.rootViewController =initNavigation;
        
    }else{
        
        //创建左侧菜单
        LeftViewController *leftVC = [[LeftViewController alloc] init];
        
        //创建带navigationController的homeViewController
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:homeVC];
        
        //创建滑动页面
        SlideViewController *slideVC = [[SlideViewController alloc] initWithLeftViewController:leftVC navigationController:navigation];
        
        self.window.rootViewController = slideVC;
        
   }
    [self.window makeKeyAndVisible];
    return YES;
        
        
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
