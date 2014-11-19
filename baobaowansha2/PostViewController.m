//
//  PostViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/14.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "PostViewController.h"
#import "PostView.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = @{@"postTitle":@"宝宝玩啥玩具偏偏",@"postHeaderImage":@"headerImage.jpg",@"postContent":@"拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳"};
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000.0f);
    PostView *post = [[PostView alloc] initWithDict:dict frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:post];
    
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
