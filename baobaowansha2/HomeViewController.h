//
//  HomeViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"


@protocol HomeViewDelegate

-(void)leftBarButtonItemClicked;

@end

@interface HomeViewController : ViewPagerController <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic,assign) id<HomeViewDelegate> leftBarButtonItemClickedDelegate;

@end