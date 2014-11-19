//
//  LeftViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/13.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewControllerDelegate <NSObject>

-(void)pushToView:(UIButton *)leftViewMenuButton;

@end

@interface LeftViewController : UIViewController

@property(nonatomic,retain) id<LeftViewControllerDelegate> delegate;

@end
