//
//  MainViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/12/22.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "HomeTableViewCell.h"
#import "PostViewController.h"
#import "BabyInfoViewController.h"
#import "AFNetworking.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,strong)NSMutableArray *homeTableViewCell;

@property (nonatomic,retain)EGORefreshCustom *refreshHeaderView;

@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

@property (nonatomic,retain) UITableView *homeTableView;

@property (nonatomic,strong)UILabel *noDataAlert;

@property (nonatomic,strong)UIView *tableViewMask;

@property (nonatomic, strong) iCarousel * carousel;
@property (nonatomic, strong) NSMutableArray *carouselItems;

@property (nonatomic, retain) UIScrollView * scrollView;

@property (nonatomic, retain) NSDictionary* responseData;

@property (nonatomic,retain) AppDelegate *appDelegate;

@property (nonatomic,strong)JGProgressHUD *HUD;
@property (nonatomic,assign)BOOL isHudShow;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: 判断是否已将信息同步，如果从来没有同步过
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userHasLogged"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"userHasLogged"]) {
        BabyInfoViewController * bbVC = [[BabyInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = @"暂不设置";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [self.navigationController pushViewController:bbVC animated:YES];
        
    }
    self.title = @"发现";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLeftMenuButton];
    [self setupRightFilterButton];
    self.requestURL =  @{@"requestRouter":@"post/discover"};
    
    self.responseData =
    @{@"banner":
          @{@"imgurl":@"chrismas.jpg", @"title":@"圣诞节",
            @"imgurl":@"winter.jpeg", @"title":@"冬天",
            @"imgurl":@"newyear.png", @"title":@"春节",
            @"imgurl":@"halloween.jpeg", @"title":@"万圣节"
            }
      };
  
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //初始化数据
    [self initViews];
    
}

-(void)initViews{
    
    //初始化homeTableViewCell
    self.homeTableViewCell = [[NSMutableArray alloc]init];
    
    [self initScrollView];
    [self initCarousel];
    [self initTableView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
    
}
-(void)initScrollView{
    UIView *whitespace = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
    whitespace.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64.0f)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    _scrollView.backgroundColor  = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self.view addSubview:whitespace];
    
}
-(void)initCarousel{
    
    self.carouselItems = [NSMutableArray array];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0,110, self.view.frame.size.width, 50)];
    textView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    
    UILabel *carouselTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,0, self.view.frame.size.width, 50)];
    carouselTextLabel.text = @"圣诞节专题";
    carouselTextLabel.textColor = [UIColor whiteColor];
    carouselTextLabel.font = [UIFont systemFontOfSize:15.0f];
    
    imageView1.image = [UIImage imageNamed:@"chrismas.jpg"];
    [textView addSubview:carouselTextLabel];
    [imageView1 addSubview:textView];
    [self.carouselItems addObject:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    imageView2.image = [UIImage imageNamed:@"winter.jpeg"];
    [self.carouselItems addObject:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    imageView3.image = [UIImage imageNamed:@"newyear.png"];
    [self.carouselItems addObject:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    imageView4.image = [UIImage imageNamed:@"halloween.jpeg"];
    [self.carouselItems addObject:imageView4];
    
    
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width,160)];
    self.carousel.type = 1;
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.pagingEnabled = YES;
    self.carousel.clipsToBounds = YES;
    [self.carousel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_scrollView addSubview:self.carousel];
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(carouselSlide:) userInfo:nil repeats:YES];
    
    
}
-(void)initTableView{
    
    if(!_homeTableView){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0, 160, self.view.frame.size.width,self.view.frame.size.height);
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.scrollEnabled = NO;
        
        self.tableViewMask = [[UIView alloc]init];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        _homeTableView.tableFooterView = self.tableViewMask;
        
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
        [_scrollView addSubview:_homeTableView];
    }
    
}


-(void)carouselSlide:(NSTimer*)timer{
    static int i = 0;
    if(i>3)
    {
        i=0;
    }
    [self.carousel scrollToItemAtIndex:i animated:YES];
    i++;
}

//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(!_refreshHeaderView){
        _refreshHeaderView = [[EGORefreshCustom alloc] initWithScrollView:_scrollView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [_scrollView addSubview:_refreshHeaderView];
        
    }
    
}
-(void)initRefreshFooterView{
    
    if(!_refreshFooterView){
        
        _refreshFooterView = [[EGORefreshCustom alloc] initWithScrollView:_scrollView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        _refreshFooterView.frame = CGRectMake(0, _scrollView.contentSize.height, self.view.frame.size.width, 100.0f);
        [_scrollView addSubview:_refreshFooterView];

    }
    
}

//如果没有数据，那么要告诉用户表是空的
-(void)showNoDataAlert{
    
    
    
    self.tableViewMask = [[UIView alloc]init];
    self.tableViewMask.backgroundColor =[UIColor clearColor];
    _homeTableView.tableFooterView = self.tableViewMask;
    
    self.noDataAlert = [[UILabel alloc]initWithFrame:CGRectMake(0, 164, self.view.frame.size.width, 40.0f)];
    self.noDataAlert.text = @"暂时没有内容哦~";
    self.noDataAlert.textAlignment = NSTextAlignmentCenter;
    self.noDataAlert.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    self.noDataAlert.textAlignment = NSTextAlignmentCenter;
    self.noDataAlert.font = [UIFont systemFontOfSize:14.0f];
    
    [_homeTableView addSubview:self.noDataAlert];
    
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.homeTableViewCell.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"List";
    
    //创建cell
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell setDataWithDict:self.homeTableViewCell[indexPath.row] frame:self.view.frame];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    
    PostViewController *post = [[PostViewController alloc] init];
    
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.homeTableViewCell[indexPath.row] objectForKey:@"ID"],@"postID",self.appDelegate.generatedUserID,@"userIdStr",nil];
    
    NSString *postRouter = @"/post/post";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        
        if(responseDict != (id)[NSNull null]){
            [post initViewWithDict:responseDict];
        }else{
            [post noDataAlert];
        }
        [post dismissHUD];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [post dismissHUD];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }];
    [post showHUD];
    [self.navigationController pushViewController:post animated:YES];
    
}


#pragma mark EGORefreshReloadData
- (void)reloadTableViewDataSource{
    
    //下拉刷新的数据处理
    if(_refreshHeaderView.pullDown){
        [self performPullDownRefresh];
    }
    //上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        [self performPullUpRefresh];
    }
}

-(void)simulatePullDownRefresh{
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    _scrollView.contentOffset = CGPointMake(0, -64);
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    if(self.tag){
        
        postRouter = @"post/getTableByTag";
        
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",self.tag,@"tag",nil];
    }else{
        
        postRouter = [self.requestURL valueForKey:@"requestRouter"];
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:1],@"p",nil];
    }
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        [self.homeTableViewCell removeAllObjects];
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            if(self.noDataAlert){
                self.noDataAlert.hidden = YES;
            }
            
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
                
            }
            if([self.homeTableViewCell count]>4){
                
                _homeTableView.frame = CGRectMake(0, self.carousel.frame.size.height, self.view.frame.size.width,[self.homeTableViewCell count]*100);
                
                _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.carousel.frame.size.height + _homeTableView.frame.size.height);
                
                [self initRefreshFooterView];
                
            }else{
                //去除分割线
                _homeTableView.tableFooterView = self.tableViewMask;
                _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            }
            
            
            
        }else{
            
            [self showHUD:@"没有内容~"];
            _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            [self dismissHUD];
            [self showNoDataAlert];

        }
        [_homeTableView reloadData];
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
        
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        [self showHUD:@"网络请求失败~"];
        [self dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }];
    
    
}
-(void)performPullUpRefresh{
    
    _reloading = YES;
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    
    static int p = 2;
    
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
    
    if(self.tag){
        
        postRouter = @"post/getTableByTag";
        
        postParam = [NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:p],@"p",self.tag,@"tag",nil];
        
    }else{
        
        postRouter = [self.requestURL valueForKey:@"requestRouter"];
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInt:p],@"p",nil];
        
    }
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray == (id)[NSNull null]){
            //如果是最后一页
            [self showHUD:@"已经是最后一页了"];
            [self  dismissHUD];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
            app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
        }else{
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
                _homeTableView.frame = CGRectMake(0, self.carousel.frame.size.height, self.view.frame.size.width,[self.homeTableViewCell count]*100);
                _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.carousel.frame.size.height + [self.homeTableViewCell count]*100 );
                _refreshFooterView.frame = CGRectMake(0, _scrollView.contentSize.height, self.view.frame.size.width, 100.0f);
                [_homeTableView reloadData];
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self  showHUD:@"网络请求失败~"];
        [self  dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5f];
        
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }];
    ++p;
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    
    
}


#pragma mark - EGOPullRefreshDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshCustom *)view{
    [self reloadTableViewDataSource];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshCustom *)view{
    
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshCustom *)view{
    
    return [NSDate date];
    
}

#pragma mark - Bar Button Init
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    leftDrawerButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    leftDrawerButton.image = [UIImage imageNamed:@"menu.png"];
}


-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)setupRightFilterButton {
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
    rightDrawerButton.tintColor = [UIColor colorWithRed:40.0f/255.0f green:185.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    rightDrawerButton.image = [UIImage imageNamed:@"filter.png"];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.carouselItems count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        UIImageView *imageView = [self.carouselItems objectAtIndex:index];
        [view addSubview:imageView];
        
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [self.carouselItems[(NSUInteger)index] stringValue];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}


//- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//    //implement 'flip3D' style carousel
//    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
//    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
//}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}


#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.carouselItems)[(NSUInteger)index];
    //NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    //NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}


#pragma mark - 标签栏delegate
-(void)tagSelected:(NSString *)string{
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                     animations:^{
                         self.title = [NSString stringWithFormat:@"发现-%@",string];
                         //开始动画
                         [self.carousel setFrame:CGRectMake(0, 0, self.view.frame.size.width,0)];
                         _homeTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,[self.homeTableViewCell count]*100);
                         _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [self.homeTableViewCell count]*100 );
                         _refreshFooterView.frame = CGRectMake(0, _scrollView.contentSize.height, self.view.frame.size.width, 100.0f);
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                         self.tag = string;
                         [self simulatePullDownRefresh];
                     }];

    
}

-(void)tagDeselected{
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                     animations:^{
                         self.title = @"发现";
                         //开始动画
                         [self.carousel setFrame:CGRectMake(0, 0, self.view.frame.size.width,160)];
                         _homeTableView.frame = CGRectMake(0, 160, self.view.frame.size.width,[self.homeTableViewCell count]*100);
                         _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [self.homeTableViewCell count]*100 );
                         _refreshFooterView.frame = CGRectMake(0, _scrollView.contentSize.height, self.view.frame.size.width, 100.0f);
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                         self.tag = nil;
                         [self simulatePullDownRefresh];
                     }];
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
