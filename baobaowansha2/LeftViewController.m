//
//  LeftViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/13.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()
{
    NSArray *menuButtonTitle;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuButtonTitle= @[@"修改宝宝信息",@"我的收藏",@"我的评论",@"设置",@"反馈"];
    
    [self initBackground];
    [self initButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//左侧导航背景图片在这里更换
-(void)initBackground{
    
    UIImage *background = [UIImage imageNamed:[NSString stringWithFormat:@"menuBackground.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:background];
}
//添加导航栏的按钮
//按钮占据侧边栏的全部大小，250*100
-(void)initButton{
    
    //
    __block float distance = 0;
    [menuButtonTitle enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
     {
         
         UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44+distance,250, 100)];
         //button的icon
         UIImageView *menuButtonImageView =[[UIImageView alloc] initWithFrame:CGRectMake(40, 38,24, 24)];
         menuButtonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu24x24.png"]];
         menuButtonImageView.tintColor = [UIColor whiteColor];
         
         UILabel *menuButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 120, 60)];
         menuButtonLabel.text = obj;
         menuButtonLabel.font = [UIFont systemFontOfSize:15.0];
         menuButtonLabel.textColor = [UIColor whiteColor];
         [menuButton addSubview:menuButtonImageView];
         [menuButton addSubview:menuButtonLabel];
         
         menuButton.tag = idx;
         
         [menuButton addTarget:self.delegate action:@selector(pushToView:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:menuButton];
         distance += 60;
     }];
}

@end
