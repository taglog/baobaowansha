//
//  TableView.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/24.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "TableView.h"
@interface TableView()
@end

@implementation TableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 152.0f, frame.size.width - 20.0f, 40.0f)];
    button.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:86.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
    
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self.delegate action:@selector(infoComplete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 130)];
    self.tableView.scrollEnabled = NO;
    
    [self addSubview:self.tableView];
    
    
    return self;
}




@end
