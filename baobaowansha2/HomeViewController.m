//
//  HomeViewController.m
//  ;
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "HomeViewController.h"
#import "ContentViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CollectionViewCell.h"



@interface HomeViewController ()
@property (nonatomic,strong)JGProgressHUD *HUD;
@property (nonatomic,assign)BOOL isHudShow;

@property (nonatomic,strong)ContentViewController *contentViewControllerFirst;
@property (nonatomic,strong)ContentViewController *contentViewControllerSecond;
@property (nonatomic,strong)ContentViewController *contentViewControllerThird;
@property (nonatomic,strong)ContentViewController *contentViewControllerFourth;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor  ];
    [AVAnalytics beginLogPageView:@"HomeViewPage"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = self.controllerTitle;
    
    //4个标签，需要4个实例
    self.contentViewControllerFirst = [[ContentViewController alloc] initWithURL:self.requestURL type:0];
    self.contentViewControllerFirst.delegate = self;
    self.contentViewControllerSecond = [[ContentViewController alloc] initWithURL:self.requestURL type:1];
    self.contentViewControllerSecond.delegate = self;
    self.contentViewControllerThird = [[ContentViewController alloc] initWithURL:self.requestURL type:2];
    self.contentViewControllerThird.delegate = self;
    self.contentViewControllerFourth = [[ContentViewController alloc] initWithURL:self.requestURL type:3];
    self.contentViewControllerFourth.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    [self setupLeftMenuButton];
    self.isHudShow = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [AVAnalytics endLogPageView:@"HomeViewPage"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewPagerDataSource
//设置tab页的按钮数为4个
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 4;
}

//设置4个按钮的label为：（全部，绘本，玩具，亲子）
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    NSString *tabTitle;
    switch(index){
            case 0 :
                tabTitle = @"全部";
            break;
            case 1 :
                tabTitle = @"绘本";
            break;
            case 2 :
                tabTitle = @"玩具";
            break;
            case 3 :
                tabTitle = @"亲子";
            break;
    }
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = tabTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0/255.0f alpha:1.0];
    [label sizeToFit];
    
    return label;
}

//内容视图的dataSource，交给HomeTableViewController
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    //初始化contentViewController
    ContentViewController *viewController;
    switch (index) {
        case 0:
            viewController = self.contentViewControllerFirst;
            break;
        case 1:
            viewController = self.contentViewControllerSecond;
            break;
        case 2:
            viewController = self.contentViewControllerThird;
            break;
        case 3:
            viewController = self.contentViewControllerFourth;
            break;
        default:
            break;
    }
    
    return viewController;
}



#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 40.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return self.view.frame.size.width/4.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0] colorWithAlphaComponent:1.0];
        case ViewPagerTabsView:
            return [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        default:
            return color;
    }
}



-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    leftDrawerButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    leftDrawerButton.image = [UIImage imageNamed:@"menu.png"];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



#pragma mark - 指示层delegate
-(void)showHUD:(NSString*)text{
    //初始化HUD
    if(self.isHudShow == YES){
        [self.HUD dismissAnimated:NO];
    }
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = text;
    [self.HUD showInView:self.view];
    self.isHudShow = YES;
    
}
-(void)dismissHUD{
    [self.HUD dismissAfterDelay:1.0];
    self.isHudShow = NO;
}





@end
