//
//  SettingsViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/17.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "SettingsViewController.h"
#import "RETableViewManager.h"
#import "AboutUsViewController.h"
#import "BabyInfoViewController.h"

@interface SettingsViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"设置";
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    RETableViewSection *section1 = [RETableViewSection sectionWithHeaderTitle:@"宝贝信息" footerTitle:@""];
    RETableViewSection *section2 = [RETableViewSection sectionWithHeaderTitle:@"系统设置" footerTitle:@""];
    [self.manager addSection:section1];
    [self.manager addSection:section2];
    
    [section1 addItem:[RETableViewItem itemWithTitle:@"宝贝信息" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [self.navigationController pushViewController:[[BabyInfoViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
    }]];

    
    
    [section2 addItem:[RETableViewItem itemWithTitle:@"支持我们" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        NSURL * urlStr = [NSURL URLWithString:@"http://blog.yhb360.com"];//后面为参数
        if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
            NSLog(@"going to url");
            [[UIApplication sharedApplication] openURL:urlStr];
        }else{
            NSLog(@"can not go to url");
        }
    }]];
    
    [section2 addItem:[RETableViewItem itemWithTitle:@"关于我们" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [self.navigationController pushViewController:[[AboutUsViewController alloc] init] animated:YES];
    }]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
