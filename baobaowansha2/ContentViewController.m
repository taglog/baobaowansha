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

@interface ContentViewController ()

@property (nonatomic,assign)BOOL reloading;

@property (nonatomic,strong)NSMutableArray *homeTableViewCell;

@property (nonatomic,retain)EGORefreshCustom *refreshHeaderView;

@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

@property (nonatomic,strong)NSArray *addOnCell;


@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self){
        self.view.backgroundColor = [UIColor clearColor];
        [self setInitData];
       
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setInitData{
    
    //初始化homeTableViewCell
    self.homeTableViewCell = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost/baobaowansha/post/table?type=%lu&p=1",(unsigned long)_type] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        for(NSString *responseDict in responseArray){
            NSDictionary *dict = [responseArray valueForKey:responseDict];
            [self.homeTableViewCell addObject:dict];
            [self initTableView];
            [self initRefreshView];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}



//初始化tableView
-(void)initTableView{

    
    if(!_homeTableView){
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame =CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
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
    
    [cell setDataWithDict:self.homeTableViewCell[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostViewController *post = [[PostViewController alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost/baobaowansha/post/post?id=%@",[self.homeTableViewCell[indexPath.row] objectForKey:@"ID"]] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSDictionary *responseDict = [responseObject valueForKey:@"data"];
        
        [post setPostWithDict:responseDict];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [self.navigationController pushViewController:post animated:YES];
    
}


#pragma mark 下拉数据刷新
- (void)reloadTableViewDataSource{
//下拉刷新的数据处理
    if(_refreshHeaderView.pullDown){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"http://localhost/baobaowansha/post/table?type=%ld&p=1",(long)_type] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            for(NSString *responseDict in responseArray){
                NSDictionary *dict = [responseArray valueForKey:responseDict];
                [self.homeTableViewCell addObject:dict];
                [_homeTableView reloadData];
                _reloading = YES;
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];

    }
//上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        static int p = 2;

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"http://localhost/baobaowansha/post/table?type=%ld&p=%d",(long)_type,p] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            for(NSString *responseDict in responseArray){
                NSDictionary *dict = [responseArray valueForKey:responseDict];
                [self.homeTableViewCell addObject:dict];
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
