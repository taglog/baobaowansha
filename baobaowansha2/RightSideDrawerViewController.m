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
@property (nonatomic, strong) NSMutableArray *carouselItems;
@property (nonatomic, retain) UIScrollView * scrollView;
@end

@implementation RightSideDrawerViewController



@synthesize carousel;
@synthesize carouselItems;
@synthesize collectionView;
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.mm_drawerController setMaximumRightDrawerWidth:240.0];
    
    NSString * responseData = \
    @"{\"banner\":[\
        {\"imgurl\":\"christmas.jpg\", \"title\":\"圣诞节\"}, \
        {\"imgurl\":\"newyear.jpg\", \"title\":\"新年\"},\
        {\"imgurl\":\"chun.jpg\", \"title\":\"春节\"},\
        {\"imgurl\":\"travel.jpg\", \"title\":\"旅行\"}\
    ],\
    \"collections\": [\
        {\"sectionTitle\":\"潜能\", \"sectionItems\": [\
            {\"title\":\"运动\", \"tags\":\"运动\"},\
            {\"title\":\"认知\", \"tags\":\"认知\"},\
            {\"title\":\"动手能力\", \"tags\":\"动手能力\"},\
            {\"title\":\"测试\", \"tags\":\"测试\"}\
        ]},\
        {\"sectionTitle\":\"参与人数\", \"sectionItems\": [\
            {\"title\":\"一大一小\", \"tags\":\"一大一小\"},\
            {\"title\":\"两大一小\", \"tags\":\"两大一小\"},\
            {\"title\":\"测试\", \"tags\":\"测试\"},\
            {\"title\":\"全部参与\", \"tags\":\"全部参与\"}\
        ]},\
        {\"sectionTitle\":\"场景\", \"sectionItems\": [\
            {\"title\":\"起床时\", \"tags\":\"起床时\"},\
            {\"title\":\"晚饭后\", \"tags\":\"晚饭后\"},\
            {\"title\":\"公园\", \"tags\":\"公园\"}\
        ]},\
        {\"sectionTitle\":\"时长\", \"sectionItems\": [\
            {\"title\":\"5分钟\", \"tags\":\"5分钟\"},\
            {\"title\":\"半小时\", \"tags\":\"半小时\"},\
            {\"title\":\"周末\", \"tags\":\"周末\"}\
        ]}\
    ]\
    }";
    

    
    NSData *data = [responseData   dataUsingEncoding:NSUTF8StringEncoding];

    NSError* error;
    self.rightDrawerModelInJson = [NSJSONSerialization
                                            JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                            error:&error];
    
    //NSLog(@"Json parsed with Error code: %@", error);
    NSArray* collections = [self.rightDrawerModelInJson objectForKey:@"collections"];
    self.sectionFoldFlags = [[NSMutableArray alloc] initWithCapacity:collections.count];
    for (int i=0; i<collections.count; i++) {
        [self.sectionFoldFlags addObject:[NSNumber numberWithBool:YES]];
    }
    
    self.carouselItems = [NSMutableArray array];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    imageView1.image = [UIImage imageNamed:@"christmas.jpg"];
    [self.carouselItems addObject:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    imageView2.image = [UIImage imageNamed:@"newyear.jpg"];
    [self.carouselItems addObject:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    imageView3.image = [UIImage imageNamed:@"chun.jpg"];
    [self.carouselItems addObject:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    imageView4.image = [UIImage imageNamed:@"travel.jpg"];
    [self.carouselItems addObject:imageView4];
    
    
    
    
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 140)];
    self.carousel.type = 1;
    
    [self.carousel setDelegate:self];
    [self.carousel setDataSource:self];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 240, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(240, 600);
    [scrollView addSubview:self.carousel];
    //[self.view addSubview:self.carousel];
    
    [self.carousel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    
    // add collection view
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140, 240, 460) collectionViewLayout:flowLayout];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"ttcell"];
    
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setScrollEnabled:NO];
    
    [scrollView addSubview:self.collectionView];
    //[self.view addSubview:self.collectionView];
    
    
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
    
    [self.view addSubview:scrollView];
    [self.view setBackgroundColor:viewBackgroundColor];

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Table view data source
 



#pragma mark -
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
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
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


- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

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
            return value * 1.05f;
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
    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}



#pragma mark - collectionView delegate

//设置分区

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray* collections = [self.rightDrawerModelInJson objectForKey:@"collections"];
    //NSLog(@"number of sections in right drawer is %d", collections.count);
    return collections.count;
}

//每个分区上的元素个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* collections = [self.rightDrawerModelInJson objectForKey:@"collections"];
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
        NSArray* collections = [self.rightDrawerModelInJson objectForKey:@"collections"];
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
    
    
    NSArray* collections = [self.rightDrawerModelInJson objectForKey:@"collections"];
    NSArray* items =  [[collections objectAtIndex:indexPath.section] objectForKey:@"sectionItems"];
    cell.label.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.tags = [[items objectAtIndex:indexPath.row] objectForKey:@"tags"];
    
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
    NSLog(@"cell tags is %@", cell.tags);
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:217/255.0
                                                       green:217/255.0
                                                        blue:217/255.0
                                                       alpha:0.9];
    
    if ([cell.tags isEqual: @"more"]) {
        self.sectionFoldFlags[indexPath.section] = [NSNumber numberWithBool:NO];
        NSArray* collections = [self.rightDrawerModelInJson objectForKey:@"collections"];
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
    NSLog(@"Selected item of section:%d, row:%d", indexPath.section, indexPath.row);
    // TODO: add a selected mark
    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    if ([cell isSel]) {
        [cell setSel:NO];
    } else {
        [cell setSel:YES];
    }

    [self.mm_drawerController setCenterViewController:self.mm_drawerController.centerViewController
                                   withCloseAnimation:YES
                                           completion:nil];
    
}

- (void)collectionView:(UICollectionView *)colView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Deselecte at section:%d, row:%d", indexPath.section, indexPath.row);
    CollectionViewCell* cell = (CollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    [cell setSel:NO];
}



@end