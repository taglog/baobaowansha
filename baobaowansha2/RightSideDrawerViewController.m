//
//  RightSideDrawerViewController.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/12/11.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "MMSideDrawerSectionHeaderView.h"
#import "RightSideDrawerViewController.h"
#import "BabyInfoViewController.h"
#import "CollectionHeaderView.h"
#import "CollectionViewCell.h"

@interface RightSideDrawerViewController ()

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UISearchBar *tagSearchBar;
@property (nonatomic, retain) UITableView *tagSearchTableView;
@property (nonatomic, retain) UIView *tagSelectedView;
@property (nonatomic, retain) UIButton *tagSelectedButton;
@property (nonatomic, retain) NSMutableDictionary *tagCellNumberSelected;
@property (nonatomic, retain) NSMutableArray *tagSearchTableViewCell;
@end

@implementation RightSideDrawerViewController


@synthesize collectionView;
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor * viewBackgroundColor;
    if(OSVersionIsAtLeastiOS7()){
        viewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                              green:113.0/255.0
                                               blue:115.0/255.0
                                              alpha:1.0];
    }
    else {
        viewBackgroundColor = [UIColor colorWithRed:77.0/255.0
                                              green:79.0/255.0
                                               blue:80.0/255.0
                                              alpha:1.0];
    }
    
    
    [self.view setBackgroundColor:viewBackgroundColor];

    [self.mm_drawerController setMaximumRightDrawerWidth:240.0];
    
    self.responseData =
    @{@"banner":
          @{@"imgurl":@"chrismas.jpg", @"title":@"圣诞节",
            @"imgurl":@"winter.jpeg", @"title":@"冬天",
            @"imgurl":@"newyear.jpg", @"title":@"春节",
            @"imgurl":@"halloween.jpeg", @"title":@"万圣节"
            },
      
      @"collections":
          @[ @{@"sectionTitle":@"潜能", @"sectionItems":
                   @[@{@"title":@"运动", @"tags":@"运动",@"imgurl":@"basketball.png"},
                     @{@"title":@"认知", @"tags":@"认知",@"imgurl":@"pen.png"},
                     @{@"title":@"语言", @"tags":@"语言",@"imgurl":@"phone"},
                     ]
               },
             
             @{@"sectionTitle":@"季节", @"sectionItems":
                   @[@{@"title":@"下雪", @"tags":@"下雪",@"imgurl":@"snow.png"},
                     @{@"title":@"落叶", @"tags":@"落叶",@"imgurl":@"leaf.png"},
                     @{@"title":@"雨后", @"tags":@"雨后",@"imgurl":@"rain.png"},
                     @{@"title":@"夏日", @"tags":@"夏日",@"imgurl":@"sun"},
                     @{@"title":@"刮风", @"tags":@"刮风",@"imgurl":@"wind"},
                     @{@"title":@"炎热", @"tags":@"炎热",@"imgurl":@"hot"}
                     ]
               },
             @{@"sectionTitle":@"场景", @"sectionItems":
                   @[@{@"title":@"起床时", @"tags":@"起床时",@"imgurl":@"getup"},
                     @{@"title":@"晚饭后", @"tags":@"晚饭后",@"imgurl":@"dinner"},
                     @{@"title":@"公园", @"tags":@"公园",@"imgurl":@"garden"},
                     @{@"title":@"等餐", @"tags":@"等餐",@"imgurl":@"chair"},
                     @{@"title":@"吃饭时", @"tags":@"吃饭时",@"imgurl":@"fork"},
                     @{@"title":@"逛街时", @"tags":@"逛街时",@"imgurl":@"walking"},
                     ]
               },
             @{@"sectionTitle":@"节日", @"sectionItems":
                   @[@{@"title":@"圣诞节", @"tags":@"圣诞节",@"imgurl":@"santa"},
                     @{@"title":@"春节", @"tags":@"春节",@"imgurl":@"home"},
                     @{@"title":@"万圣节", @"tags":@"万圣节",@"imgurl":@"halloween.png"},
                     @{@"title":@"母亲节", @"tags":@"母亲节",@"imgurl":@"mama"},
                     @{@"title":@"儿童节", @"tags":@"儿童节",@"imgurl":@"childday"},
                     @{@"title":@"端午节", @"tags":@"端午节",@"imgurl":@"duanwu"}
                     ]
               },
             @{@"sectionTitle":@"家庭成员", @"sectionItems":
                   @[@{@"title":@"妈妈(爸爸)", @"tags":@"妈妈(爸爸)",@"imgurl":@"baba"},
                     @{@"title":@"父母", @"tags":@"父母",@"imgurl":@"mama2"},
                     @{@"title":@"全部参与", @"tags":@"全部参与",@"imgurl":@"allparents"}
                     ]
               }
             
             
             ]
      };
    

   
    
   
    
    
    [self initScrollView];
    [self initTagSelectedLabel];
    [self initTagCollectionView];
 
    [self initTagSearchBar];
    [self initTagSearchTableView];
   
    
    
 
    
    
}
-(void)initScrollView{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 240, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
     [self.view addSubview:scrollView];
}
-(void)initTagCollectionView{
    
    //演示的时候不需要折叠
    //    NSArray* collections = [self.responseData objectForKey:@"collections"];
    //    self.sectionFoldFlags = [[NSMutableArray alloc] initWithCapacity:collections.count];
    //    for (int i=0; i<collections.count; i++) {
    //        NSArray* items =  [[collections objectAtIndex:i] objectForKey:@"sectionItems"];
    //
    //        if([items count]>3){
    //            [self.sectionFoldFlags addObject:[NSNumber numberWithBool:YES]];
    //        }else{
    //            [self.sectionFoldFlags addObject:[NSNumber numberWithBool:NO]];
    //
    //        }
    //    }
    
    
    // add collection view
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 74, 240, 800) collectionViewLayout:flowLayout];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"ttcell"];
    
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    self.collectionView.backgroundColor = [UIColor colorWithRed:110.0/255.0 green:113.0/255.0 blue:115.0/255.0 alpha:1.0];
    [self.collectionView setScrollEnabled:NO];
    
    [scrollView addSubview:self.collectionView];
    
}
-(void)initTagSelectedLabel{
    
    self.tagSelectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 50)];
    
    UILabel *tagSelectedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60.0,20.0f)];
    tagSelectedLabel.text = @"已选择 : ";
    tagSelectedLabel.font = [UIFont systemFontOfSize:13.0];
    tagSelectedLabel.textColor = [UIColor lightTextColor];
    [self.tagSelectedView addSubview:tagSelectedLabel];
    
    self.tagSelectedButton = [[UIButton alloc]initWithFrame:CGRectMake(65, 0, self.view.frame.size.width - 80, 30)];

    self.tagSelectedButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    self.tagSelectedButton.backgroundColor = [UIColor colorWithRed:89.0f/255.0f green:93.0f/255.0f blue:97.0f/255.0f alpha:1.0];
    self.tagSelectedButton.layer.cornerRadius = 3.0;
    self.tagSelectedButton.titleLabel.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];
    UIImageView *tagRemoveMark = [[UIImageView alloc]initWithFrame:CGRectMake(self.tagSelectedButton.frame.size.width - 26,7,16,16)];
    tagRemoveMark.tintColor = [UIColor whiteColor];
    tagRemoveMark.image = [UIImage imageNamed:@"wrong"];
    tagRemoveMark.tintColor = [UIColor whiteColor];
    [self.tagSelectedButton addSubview:tagRemoveMark];
    
    [self.tagSelectedButton addTarget:self action:@selector(tagSelectedButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tagSelectedView addSubview:self.tagSelectedButton];
    
    [scrollView addSubview:self.tagSelectedView];
    
}
-(void)initTagSearchBar{
    
    self.tagSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 24, self.view.frame.size.width, 40)];
    self.tagSearchBar.placeholder = @"搜索您感兴趣的标签";
    self.tagSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.tagSearchBar.delegate = self;
    
    [scrollView addSubview:self.tagSearchBar];

}

-(void)initTagSearchTableView{
    
    self.tagSearchTableViewCell = [[NSMutableArray alloc]init];
    
    self.tagSearchTableView = [[UITableView alloc]initWithFrame:CGRectMake(240, 74, self.view.frame.size.width,self.view.frame.size.height)];
    self.tagSearchTableView.backgroundColor = [UIColor colorWithRed:110.0f/255.0f green:113.0f/255.0f blue:115.0f/255.0f alpha:1.0];
    self.tagSearchTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tagSearchTableView.separatorColor = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
    self.tagSearchTableView.delegate = self;
    self.tagSearchTableView.dataSource = self;
    UIView *tableViewMask = [UIView new];
    tableViewMask.backgroundColor =[UIColor clearColor];
    self.tagSearchTableView.tableFooterView = tableViewMask;
    
    
    [scrollView addSubview:self.tagSearchTableView];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.tagSearchBar.showsCancelButton = YES;
    
    scrollView.scrollEnabled = NO;
    
    [self.tagSearchBar becomeFirstResponder];
    NSArray *subViews;
    if (OSVersionIsAtLeastiOS7) {
        subViews = [(self.tagSearchBar.subviews[0]) subviews];
    }
    else {
        subViews = self.tagSearchBar.subviews;
    }
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelbutton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
            [cancelbutton setTitleColor:[UIColor lightTextColor] forState:UIControlStateSelected];
            cancelbutton.titleLabel.font = [UIFont systemFontOfSize:15];
            break;
        }
    }
    self.tagSearchTableViewCell = [NSMutableArray arrayWithArray:@[@"你好",@"我好",@"他好",@"她不好",@"你好",@"我好",@"他好",@"她不好"]];
    [self.tagSearchTableView reloadData];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                     animations:^{
                         //开始动画
                         [self.tagSearchTableView setFrame:CGRectMake(0, 74, self.view.frame.size.width ,self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                     }];

    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchBarCancel];
}
-(void)searchBarCancel{
    scrollView.scrollEnabled = YES;
    self.tagSearchBar.showsCancelButton = NO;
    [self.tagSearchBar resignFirstResponder];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromRight //设置动画类型
                     animations:^{
                         //开始动画
                         [self.tagSearchTableView setFrame:CGRectMake(240, 74, self.view.frame.size.width,self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                     }];
}
#pragma mark - tagSearchTableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.tagSearchTableViewCell.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ID = @"taglist";
    
    //创建cell
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor colorWithRed:110.0f/255.0f green:113.0f/255.0f blue:115.0f/255.0f alpha:1.0];
    cell.textLabel.textColor = [UIColor lightTextColor];
    if(indexPath.row == 0){
        cell.textLabel.text = @"热门标签";
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        
        cell.textLabel.text = self.tagSearchTableViewCell[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tagSearchTableView cellForRowAtIndexPath:indexPath];
    [self.tagSelectedButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                     animations:^{
                         //开始动画
                         [self.collectionView setFrame:CGRectMake(0, 124, self.view.frame.size.width ,self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         
                         // 动画结束时的处理
                         [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController
                                                        withCloseAnimation:YES
                                                                completion:nil];
                         //点击标签之后，回到主界面，并且刷新
                         
                         [self.delegate tagSelected:cell.textLabel.text];
                         [self searchBarCancel];
                     }];
    
    
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - collectionView delegate

//设置分区

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray* collections = [self.responseData objectForKey:@"collections"];
    //NSLog(@"number of sections in right drawer is %d", collections.count);
    return collections.count;
}

//每个分区上的元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* collections = [self.responseData objectForKey:@"collections"];
    NSArray* items =  [[collections objectAtIndex:section] objectForKey:@"sectionItems"];
    //NSLog(@"after init section value:%hhd", [[self.sectionFoldFlags objectAtIndex:section] boolValue]);
    if (YES == [[self.sectionFoldFlags objectAtIndex:section] boolValue]) {
        //NSLog(@"Items number in section is 3");
        return 3;
    } else {
        //NSLog(@"use itemcount Items number in section is %d", items.count);
        return items.count;
    }
}


// 设置 header 和 footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)tcollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [tcollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSArray* collections = [self.responseData objectForKey:@"collections"];
        headerView.sectionHeader.text =  [[collections objectAtIndex:indexPath.section] objectForKey:@"sectionTitle"];
        
        reusableview = headerView;
    }
    
    return reusableview;
}



//设置元素内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)tcollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ttcell";
    
    CollectionViewCell *cell = [tcollectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.tags = @"all";
    [cell setSel:NO];
    
    
    NSArray* collections = [self.responseData objectForKey:@"collections"];
    NSArray* items =  [[collections objectAtIndex:indexPath.section] objectForKey:@"sectionItems"];
// 
//    cell.label.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
//    cell.tags = [[items objectAtIndex:indexPath.row] objectForKey:@"tags"];
    
    [cell setDataWithDict:[items objectAtIndex:indexPath.row]];

    if (indexPath.row == 2 && (YES == [[self.sectionFoldFlags objectAtIndex:indexPath.section] boolValue])) {
        cell.label.text = @"更多...";
        cell.tags = @"more";
    }
    
    
    return cell;
    
}


//设置元素的的大小框

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置顶部的大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={25,25};
    return size;
}

//设置元素大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80,80);
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:217/255.0
                                                       green:217/255.0
                                                        blue:217/255.0
                                                       alpha:0.9];
    
    if ([cell.tags isEqual: @"more"]) {
        self.sectionFoldFlags[indexPath.section] = [NSNumber numberWithBool:NO];
        NSArray* collections = [self.responseData objectForKey:@"collections"];
        NSArray* items =  [[collections objectAtIndex:indexPath.section] objectForKey:@"sectionItems"];
        [self.collectionView performBatchUpdates:^{
            NSArray *deleteItems = @[indexPath];
            [self.collectionView reloadItemsAtIndexPaths:deleteItems];
            
            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
            for (int i = 3; i < items.count; i++)
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            
            [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
            
            
            // 重新设置高度
            CGRect newFrame = CGRectMake(0.0, 140.0, 240.0, collectionView.contentSize.height+81*(items.count/3+(items.count%3>0?1:0)-1));
            collectionView.frame = newFrame;
            
            scrollView.contentSize = CGSizeMake(240, scrollView.contentSize.height+81*(items.count/3+(items.count%3>0?1:0)-1));
            
            NSLog(@"new height %f", scrollView.contentSize.height);
            
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn //设置动画类型
                             animations:^{
                                 //开始动画
                                 cell.contentView.backgroundColor = nil;
                             }
                             completion:^(BOOL finished){
                                 // 动画结束时的处理
                             }];
            
        } completion:nil];
        
    }
    
}



- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    NSLog(@"un highlight");
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn //设置动画类型
                     animations:^{
                         //开始动画
                         cell.contentView.backgroundColor = nil;
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                     }];
    
    
}



- (void)collectionView:(UICollectionView *)colView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Selected item of section:%d, row:%d", indexPath.section, indexPath.row);
    // TODO: add a selected mark
    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    if ([cell isSel]) {
        [cell setSel:NO];
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                         animations:^{
                             //开始动画
                             [self.collectionView setFrame:CGRectMake(0, 74, self.view.frame.size.width ,self.view.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             // 动画结束时的处理
                             [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController
                                                            withCloseAnimation:YES
                                                                    completion:nil];
                             
                             [self.delegate tagDeselected];
                         }];
        
        
    } else {
        [cell setSel:YES];
        
        [self.tagSelectedButton setTitle:cell.tags forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                         animations:^{
                             //开始动画
                             [self.collectionView setFrame:CGRectMake(0, 124, self.view.frame.size.width ,self.view.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                             
                             self.tagCellNumberSelected = [NSMutableDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",nil];
                             // 动画结束时的处理
                             [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController
                                                            withCloseAnimation:YES
                                                                    completion:nil];
                             //点击标签之后，回到主界面，并且刷新
                             
                             [self.delegate tagSelected:cell.tags];
                             
                         }];

        
        
    }
    
    
   
    
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Deselecte at section:%d, row:%d", indexPath.section, indexPath.row);
    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    
    [cell setSel:NO];
    
    
}

-(void)tagSelectedButtonClicked{
    if(self.tagCellNumberSelected){
        
        CollectionViewCell* cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[self.tagCellNumberSelected valueForKey:@"indexPath"]];
        
        if ([cell isSel]) {
            [cell setSel:NO];
            self.tagCellNumberSelected = nil;
            
            
        }
    }
    [UIView animateWithDuration:0.4
                           delay:0.0
                         options:UIViewAnimationOptionCurveEaseInOut //设置动画类型
                      animations:^{
                          //开始动画
                          [self.collectionView setFrame:CGRectMake(0, 74, self.view.frame.size.width ,self.view.frame.size.height)];
                      }
                      completion:^(BOOL finished){
                          // 动画结束时的处理
                          [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController
                                                         withCloseAnimation:YES
                                                                 completion:nil];
                          
                          [self.delegate tagDeselected];
                          
                      }];
    
    
}

@end
