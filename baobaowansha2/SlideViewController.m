//
//  SlideViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/13.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "SlideViewController.h"
#import "CollectionViewController.h"
#import "CommentViewController.h"
#import "BabyInfoViewController.h"
#import "SettingsViewController.h"
#import "FeedbackViewController.h"



@interface SlideViewController ()
{
    BOOL leftViewOpen;
    UIButton *maskButton;
    
    BabyInfoViewController *babyInfo;
    CollectionViewController *collection;
    CommentViewController *comment;
    SettingsViewController *settings;
    FeedbackViewController *feedback;
    
}

@end

@implementation SlideViewController

-(id)initWithLeftViewController:(UIViewController *)leftViewController navigationController:(UINavigationController *)navigationViewController{
    
    if(self){
        self = [super init];
        _navigationViewController = navigationViewController;
        _leftViewController = leftViewController;
        
        [self.view addSubview:_leftViewController.view];
        [self.view addSubview:_navigationViewController.view];
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initLeftMenu];
    
}

-(void)initLeftMenu{
    
    //初始化左侧菜单的参数
    leftViewOpen = NO;
    maskButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _navigationViewController.view.frame.size.width, _navigationViewController.view.frame.size.height)];
    [maskButton addTarget:self action:@selector(hideLeftView) forControlEvents:UIControlEventTouchUpInside];
    maskButton.hidden = YES;
    
    //初始化左侧菜单
    comment = [[CommentViewController alloc] init];
    collection = [[CollectionViewController alloc] init];
    babyInfo = [[BabyInfoViewController alloc] init];
    settings = [[SettingsViewController alloc] init];
    feedback = [[FeedbackViewController alloc] init];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 事件
//leftBarButtonItem 点击事件
-(void)leftBarButtonItemClicked{
    [self showLeftView];
}

//显示左侧导航
-(void)showLeftView{
    
    if(!leftViewOpen){
        
        [UIView animateWithDuration:0.3 animations:^{
            [_navigationViewController.view setFrame:CGRectMake(250, 0, _navigationViewController.view.frame.size.width, _navigationViewController.view.frame.size.height)];
        }  completion:^(BOOL finished){
        
            leftViewOpen = YES;
            maskButton.hidden = NO;
            [_navigationViewController.view addSubview:maskButton];
        
        }];
    }
}

//收起左侧导航
-(void)hideLeftView{
    
    if(leftViewOpen){
        
        [UIView animateWithDuration:0.3 animations:^{
            [maskButton removeFromSuperview];
            [_navigationViewController.view setFrame:CGRectMake(0, 0, _navigationViewController.view.frame.size.width, _navigationViewController.view.frame.size.height)];
        }  completion:^(BOOL finished){
            
            leftViewOpen = NO;
            
        }];
    }
}

//左侧导航按钮的delegate实现
-(void)pushToView:(UIButton *)leftViewMenuButton{
    
    //!!
    //!!  这里push太快的话，会有bug，怎么解决呢
    //!!
   
    UIViewController *menuViewController = [[UIViewController alloc] init];
        switch (leftViewMenuButton.tag) {
            case 0:
                menuViewController = babyInfo;
                break;
            case 1:
                menuViewController = collection;
                break;
            case 2:
                menuViewController = comment;
                break;
            case 3:
                menuViewController = settings;
                break;
            case 4:
                menuViewController = feedback;
                break;
            default:
                break;
    };

    [_navigationViewController pushViewController:menuViewController animated:NO];
    [self hideLeftView];
}

@end
