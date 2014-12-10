//
//  AppDelegate.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LeftSideDrawerViewController.h"
#import "MobClick.h"


@interface AppDelegate ()

@property (nonatomic,strong) IntroControll * introcontroller;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];

    UIViewController * leftSideDrawerViewController = [[LeftSideDrawerViewController alloc] init];

    UIViewController * centerViewController = [[HomeViewController alloc] init];    
    UINavigationController *centerNavigation = [[UINavigationController alloc] initWithRootViewController:centerViewController];

    //设置服务器跟目录
    self.rootURL = @"http://blogtest.yhb360.com/baobaowansha";
    
    //TODO: 判断是否是第一次启动app
    


        
    // generate UserID using VenderID
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"generatedUserID"] == nil) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            self.generatedUserID = [UIDevice currentDevice].identifierForVendor.UUIDString;
        else
            self.generatedUserID = ((__bridge NSString *)(CFUUIDCreateString(NULL, CFUUIDCreate(NULL))));
        NSLog(@"generate UserID from UIDevice, %@", self.generatedUserID);
        [[NSUserDefaults standardUserDefaults] setObject:self.generatedUserID forKey:@"generatedUserID"];
    } else {
        self.generatedUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"generatedUserID"];
        NSLog(@"get UserID from NSUserDefaults, %@", self.generatedUserID);
    }
    
    
    
    
    
    // send information(id, and start time) to serverside
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //TODO, update db
        AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
        afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString * settingURL = [self.rootURL stringByAppendingString:@"/serverside/app_statistic.php?action=app_start"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.generatedUserID forKey:@"userIdStr"];
        NSLog(@"sending statistic info: %@", dict);
        [afnmanager POST:settingURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"App statistic update Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"App statistic update Error: %@", error);
        }];
    });
    
    //embed 3rd parth analyzing code 友盟统计
    [MobClick startWithAppkey:@"5487dc8ffd98c53799000ea9" reportPolicy:BATCH   channelId:@""];
    

    
    

    
    self.drawerController = [[MMDrawerController alloc]
                                        initWithCenterViewController:centerNavigation
                                        leftDrawerViewController:leftSideDrawerViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window setRootViewController:self.drawerController];
    
    //TODO: 判断是否是第一次启动app, if yes, add splash view
    //if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
    if (NO) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"Example 1" description:@"Hi, add description here" image:@"splash_image1.jpg"];
        
        IntroModel *model2 = [[IntroModel alloc] initWithTitle:@"Example 2" description:@"Several sample texts in Old, Middle, Early Modern, and Modern English are provided here for practice, reference, and reading." image:@"splash_image2.jpg"];
        
        IntroModel *model3 = [[IntroModel alloc] initWithTitle:@"Example 3" description:@"The Tempest is the first play in the First Folio edition (see the signature) even though it is a later play (namely 1610) than Hamlet (1600), for example. The first page is reproduced here" image:@"splash_image3.jpg"];
        
        CGRect bounds = [[UIScreen mainScreen] bounds];
        self.introcontroller = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height) pages:@[model1, model2, model3]];
        
        [self.drawerController.view addSubview:self.introcontroller];
        self.introcontroller.delegate = self;
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

#pragma -IntroDelegate
- (void) IntroFinished {
    NSLog(@"Intro finished, animated to hide");
    [UIView animateWithDuration:0.3 animations:^{
        self.introcontroller.alpha = 0;
    } completion:nil];
    
}


@end
