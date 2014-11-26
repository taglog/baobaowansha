//
//  BaseSideDrawerViewController.h
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/21.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"


typedef NS_ENUM(NSInteger, MMDrawerSection){
    MMDrawerSection1,
    MMDrawerSection2,
    MMDrawerSection3,

};

@interface BaseSideDrawerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * drawerWidths;


@end

