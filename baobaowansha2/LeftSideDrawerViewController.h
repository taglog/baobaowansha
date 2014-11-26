//
//  LeftSideDrawerViewController.h
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/21.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSideDrawerViewController.h"

@interface LeftSideDrawerViewController : BaseSideDrawerViewController


@property (nonatomic, retain) UIViewController * navHome;
@property (nonatomic, retain) UIViewController * navCollection;
@property (nonatomic, retain) UIViewController * navComment;
@property (nonatomic, retain) UIViewController * navBabyInfo;
@property (nonatomic, retain) UIViewController * navSetting;
@property (nonatomic, retain) UIViewController * navFeedback;

@property (nonatomic, retain) NSString * currentController;

@property (nonatomic, retain) NSString * headerWords;
@property (nonatomic, retain) NSString * headerImage;

@end