//
//  AppDelegate.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "IntroControll.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IntroDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) NSString *generatedUserID;

@end

