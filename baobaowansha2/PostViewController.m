//
//  PostViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/14.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "PostViewController.h"
#import "PostView.h"
#import "CommentTableViewCell.h"

@interface PostViewController ()

@property(nonatomic,retain) PostView *post;
@property(nonatomic,retain) UITableView *commentTableView;
@property(nonatomic,retain) NSArray *commentTableViewCell;


@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.commentTableViewCell = @[
  @{@"userName":@"啦啦啦",@"stairsNumber":@"8楼",@"userComment":@"握握手；大家发生；打飞机阿斯顿飞矮撒旦法奥迪发生地方阿斯顿飞爱疯飞",@"userBabyAge":@"14-24个月",@"commentTime":@"11点10分"},
  @{@"userName":@"啦啦啦",@"stairsNumber":@"8楼",@"userComment":@"握握手；大家发生；打飞机阿斯顿飞矮撒旦法奥迪发生地方阿斯顿飞爱疯飞",@"userBabyAge":@"14-24个月",@"commentTime":@"11点10分"},
  @{@"userName":@"啦啦啦",@"stairsNumber":@"8楼",@"userComment":@"握握手；大家发生；打飞机阿斯顿飞矮撒旦法奥迪发生地方阿斯顿飞爱疯飞",@"userBabyAge":@"14-24个月",@"commentTime":@"11点10分"},
  @{@"userName":@"啦啦啦",@"stairsNumber":@"8楼",@"userComment":@"握握手；大家发生；打飞机阿斯顿飞矮撒旦法奥迪发生地方阿斯顿飞爱疯飞",@"userBabyAge":@"14-24个月",@"commentTime":@"11点10分"},
  @{@"userName":@"啦啦啦",@"stairsNumber":@"8楼",@"userComment":@"握握手；大家发生；打飞机阿斯顿飞矮撒旦法奥迪发生地方阿斯顿飞爱疯飞",@"userBabyAge":@"14-24个月",@"commentTime":@"11点10分"},];
    
    
    NSDictionary *dict = @{@"postTitle":@"宝宝玩啥玩具偏偏",@"postHeaderImage":@"headerImage.jpg",@"postContent":@"拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳拉动所发生的了符合就阿訇是浪费的好看就阿訇是浪费点卡季后赛的疯狂拉黑是激发和斯柯达发贺卡吉林省弗兰克矮凳"};
    
    
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64.0f)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000.0f);
    [self.view addSubview:scrollView];
    //scrollView + post
    self.post = [[PostView alloc] initWithDict:dict frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView addSubview:self.post];
    //scrollView + commentTableView beneath post
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.post.frame.size.height, self.view.frame.size.width,self.view.frame.size.height)];
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [scrollView addSubview:self.commentTableView];
    
}

#pragma mark -commentTableView 委托实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentTableViewCell.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
      static NSString *ID = @"Comment";
      CommentTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
      if(cell == nil){
          cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
         [cell setDataWithDict:self.commentTableViewCell[indexPath.row]];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
