//
//  CustomizedUIViewController.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/21.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CustomizedUITableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface CustomizedUIViewController ()

@end

@implementation CustomizedUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    leftDrawerButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    leftDrawerButton.image = [UIImage imageNamed:@"menu.png"];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    // remove keyboard
    [self.mm_drawerController.centerViewController.view endEditing:YES];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
