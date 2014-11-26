//
//  BabyInfoViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/17.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "BabyInfoViewController.h"
#import "RETableViewManager.h"

@interface BabyInfoViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETextItem *nameItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *dateTimeItem;
@property (strong, readwrite, nonatomic) RESegmentedItem *sexSegmentItem;

@property (strong, readwrite, nonatomic) RETableViewSection *buttonSection;


@end

@implementation BabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    // TODO: load plist information as init value
    
    self.title = @"宝贝信息";
    
    // Create manager
    //
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    // Add a section
    //
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"基本设置" footerTitle:@"您可以随时修改以上信息"];
    [self.manager addSection:section];
    self.buttonSection = [self addButton];
    
    // Add items
    //
    self.nameItem = [RETextItem itemWithTitle:@"您的昵称: " value:@"" placeholder:@""];
    self.nameItem.validators = @[@"presence", @"length(1, 20)"];
    
    
    self.dateTimeItem = [REDateTimeItem itemWithTitle:@"宝贝生日: " value:[NSDate date] placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    self.dateTimeItem.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.dateTimeItem.validators = @[@"presence"];
    self.dateTimeItem.textAlignment = NSTextAlignmentCenter;

    self.sexSegmentItem = [RESegmentedItem itemWithTitle:@"宝贝性别: " segmentedControlTitles:@[@"男孩儿", @"女孩儿"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        NSLog(@"Value: %li", (long)item.value);
    }];

    
    
    [section addItem:self.nameItem];
    [section addItem:self.sexSegmentItem];
    [section addItem:self.dateTimeItem];
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation
 */

- (RETableViewSection *)addButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
 
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"确定" accessoryType:UITableViewCellAccessoryNone  selectionHandler:^(RETableViewItem *item) {
            item.title = @"Need TODO!";
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
 
    return section;
}


@end
