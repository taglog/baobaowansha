//
//  FeedbackViewController.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/28.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RELongTextItem *longTextItem;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"意见反馈";
    NSLog(@"feedback is running");
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"您的意见" footerTitle:@""];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.longTextItem = [RELongTextItem itemWithValue:nil placeholder:@"请告诉我们您的想法！感谢！"];
    self.longTextItem.cellHeight = 166;
    
    [section addItem:self.longTextItem];
    
    [self.manager addSection:section];
    
    [self addButton];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (RETableViewSection *)addButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"确定" accessoryType:UITableViewCellAccessoryNone  selectionHandler:^(RETableViewItem *item) {
        item.title = @"Need TODO!";
        NSLog(@"longTextItem.value = %@", self.longTextItem.value);
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
    
    return section;
}




@end
