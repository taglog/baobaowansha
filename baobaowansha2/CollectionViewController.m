//
//  CollectionViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/17.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CollectionViewController.h"
@interface CollectionViewController ()
@property(nonatomic,strong)NSDictionary *requestURL;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    

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
