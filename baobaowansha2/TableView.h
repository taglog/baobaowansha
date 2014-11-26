//
//  TableView.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/24.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TableViewDelegate
-(void)infoComplete;
@end
@interface TableView : UIView

@property(nonatomic,retain)id<TableViewDelegate>delegate;
@property(nonatomic,retain)UITableView *tableView;

@end
