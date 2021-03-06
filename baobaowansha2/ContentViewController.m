//
//  ContentViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "ContentViewController.h"
#import "HomeTableViewCell.h"
#import "PostViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"


@interface ContentViewController ()

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,strong)NSMutableArray *homeTableViewCell;

@property (nonatomic,retain)EGORefreshCustom *refreshHeaderView;

@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

@property (nonatomic,retain)AppDelegate *appDelegate;

@property (nonatomic,strong)UILabel *noDataAlert;

@property (nonatomic,strong)UIView *tableViewMask;

@end

@implementation ContentViewController

-(id)initWithURL:(NSDictionary *)dict type:(NSInteger)index{
    self = [super init];
    self.requestURL = dict;
    self.type = index;
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(self){
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //初始化数据
        [self initViews];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)initViews{
    //初始化homeTableViewCell
    self.homeTableViewCell = [[NSMutableArray alloc]init];
    
    [self initTableView];
    [self initRefreshHeaderView];
    [self simulatePullDownRefresh];
    
}

//初始化tableView
-(void)initTableView{
    
    
    if(!_homeTableView){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - 64);
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        
        self.tableViewMask = [UIView new];
        self.tableViewMask.backgroundColor =[UIColor clearColor];
        _homeTableView.tableFooterView = self.tableViewMask;
        
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_homeTableView];
    
    
}

//初始化下拉刷新header
-(void)initRefreshHeaderView{
    
    //初始化headerView
    if(!_refreshHeaderView){
        _refreshHeaderView = [[EGORefreshCustom alloc] initWithScrollView:_homeTableView position:EGORefreshHeader ];
        _refreshHeaderView.delegate = self;
        
        [_homeTableView addSubview:_refreshHeaderView];
        
    }
    
}
-(void)initRefreshFooterView{
    
    if(!_refreshFooterView){
        
        _refreshFooterView = [[EGORefreshCustom alloc] initWithScrollView:_homeTableView position:EGORefreshFooter];
        _refreshFooterView.delegate = self;
        
        _homeTableView.tableFooterView = _refreshFooterView;
    }
    
}

//如果没有数据，那么要告诉用户表是空的
-(void)showNoDataAlert{
    
    
    
    self.tableViewMask = [UIView new];
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
    _homeTableView.contentOffset = CGPointMake(0, -60);
    [self performPullDownRefresh];
}

-(void)performPullDownRefresh{
    
    _reloading = YES;
    
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    NSString *postRouter = nil;
    NSDictionary *postParam = nil;
        postRouter = [self.requestURL valueForKey:@"requestRouter"];
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",nil];
    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        [self.homeTableViewCell removeAllObjects];
        //如果存在数据，那么就初始化tableView
        if(responseArray != (id)[NSNull null] ){
            if(self.noDataAlert){
                self.noDataAlert.hidden = YES;
                [self.noDataAlert removeFromSuperview];
            }
            
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
            }
            if([self.homeTableViewCell count]>4){
                if(self.tableViewMask){
                    self.tableViewMask = nil;
                    [self.tableViewMask removeFromSuperview];
                }
                [self initRefreshFooterView];
                
            }else{
                //去除分割线
                _homeTableView.tableFooterView = self.tableViewMask;

            }
            
            
        }else{
            [self.delegate showHUD:@"没有内容~"];            
            [self.delegate dismissHUD];
            [self showNoDataAlert];
        }
        
        [_homeTableView reloadData];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.delegate showHUD:@"网络请求失败~"];
        [self.delegate dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
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

        
        postRouter = [self.requestURL valueForKey:@"requestRouter"];
        postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:p],@"p",nil];

    
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        
        if(responseArray == (id)[NSNull null]){
            //如果是最后一页
            [self.delegate showHUD:@"已经是最后一页了"];
            [self.delegate dismissHUD];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
        }else{
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
                [_homeTableView reloadData];
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.delegate showHUD:@"网络请求失败~"];
        [self.delegate dismissHUD];
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        
        app.networkActivityIndicatorVisible=!app.networkActivityIndicatorVisible;
    }];
    ++p;
    
}
- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_homeTableView];
    
    
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




@end
