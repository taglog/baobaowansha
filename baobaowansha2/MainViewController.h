//
//  MainViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/12/22.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "RightSideDrawerViewController.h"
#import "EGORefreshCustom.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EGORefreshDelegate,iCarouselDataSource, iCarouselDelegate, RightSideDrawerDelegate>

@property(nonatomic,strong) NSString *tag;
@property(nonatomic,strong) NSDictionary *requestURL;

@end
