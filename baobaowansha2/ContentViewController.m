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

@property (nonatomic,strong)NSDictionary *requestURL;

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,strong)NSMutableArray *homeTableViewCell;

@property (nonatomic,retain)EGORefreshCustom *refreshHeaderView;

@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

@property (nonatomic,retain)AppDelegate *appDelegate;

@end

@implementation ContentViewController

-(id)initWithURL:(NSDictionary *)dict type:(NSInteger)index{
    self = [super init];
    self.requestURL = dict;
    self.type = index;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(self){
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.delegate showHUD];
        //初始化数据
        [self setInitData];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


-(void)setInitData{
    
    //初始化homeTableViewCell
    self.homeTableViewCell = [[NSMutableArray alloc]init];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    
    NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        //如果存在数据，那么就初始化tableView
        if(responseArray != NULL){
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
            }
            [self initTableView];
            [self initRefreshView];
            
        }else{
            //如果没有数据，那么要告诉用户表是空的
            [self noDataAlert];
        }
        [self.delegate dismissHUD];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.delegate dismissHUD];
        [self noDataAlert];
    }];
    
}

-(void)noDataAlert{
    UILabel *noDataAlert = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height-64)/2, self.view.frame.size.width, 40.0f)];
    noDataAlert.text = @"网络连接失败";
    noDataAlert.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noDataAlert];


}


//初始化tableView
-(void)initTableView{
    
    
    if(!_homeTableView){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        [_homeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_homeTableView];
    
    
}

//初始化下拉刷新header
-(void)initRefreshView{
    
    //初始化headerView
    _refreshHeaderView = [[EGORefreshCustom alloc] initWithTableView:_homeTableView position:EGORefreshHeader ];
    _refreshHeaderView.delegate = self;
    
    
    _refreshFooterView = [[EGORefreshCustom alloc] initWithTableView:_homeTableView position:EGORefreshFooter];
    _refreshFooterView.delegate = self;
    
    [_homeTableView addSubview:_refreshHeaderView];
    _homeTableView.tableFooterView = _refreshFooterView;
    
    
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
    
    
    PostViewController *post = [[PostViewController alloc] init];
    NSDictionary *requestParam = [NSDictionary dictionaryWithObjectsAndKeys:[self.homeTableViewCell[indexPath.row] objectForKey:@"ID"],@"id",self.appDelegate.generatedUserID,@"userIdStr",nil];
    NSString *postRouter = @"/post/post";
    NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:postRequestUrl parameters:requestParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        [post initViewWithDict:responseDict];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [post noDataAlert];
    }];
    [self.navigationController pushViewController:post animated:YES];
    
}


#pragma mark 下拉数据刷新
- (void)reloadTableViewDataSource{
    //下拉刷新的数据处理
    if(_refreshHeaderView.pullDown){
        
        
        NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
        NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
        
        NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",nil];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
            }
                 [_homeTableView reloadData];
                 _reloading = YES;
                 [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
    //上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        static int p = 2;
        
        NSString *postRouter = [self.requestURL valueForKey:@"requestRouter"];
        NSString *postRequestUrl = [self.appDelegate.rootURL stringByAppendingString:postRouter];
        
        NSDictionary *postParam =[NSDictionary dictionaryWithObjectsAndKeys:self.appDelegate.generatedUserID,@"userIdStr",[NSNumber numberWithInteger:self.type],@"type",[NSNumber numberWithInt:1],@"p",nil];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:postRequestUrl parameters:postParam success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            for(NSDictionary *responseDict in responseArray){
                [self.homeTableViewCell addObject:responseDict];
                [_homeTableView reloadData];
                _reloading = YES;
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
                
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        ++p;
        
    }
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
