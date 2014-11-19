//
//  SlideViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/13.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "LeftViewController.h"

@interface SlideViewController : UIViewController <HomeViewDelegate,LeftViewControllerDelegate>

@property (nonatomic,strong) UINavigationController *navigationViewController;
@property (nonatomic,strong) UIViewController *leftViewController;

//初始化slideView
-(id)initWithLeftViewController:(UIViewController *)leftViewController navigationController:(UINavigationController *)navigationViewController;


@end
