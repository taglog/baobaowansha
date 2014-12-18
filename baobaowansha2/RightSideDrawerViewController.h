//
//  RightSideDrawerViewController.h
//  baobaowansha2
//
//  Created by PanYongfeng on 14/12/11.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "UIViewController+MMDrawerController.h"
#import "MMSideDrawerTableViewCell.h"
#import "iCarousel.h"

@protocol RightSideDrawerDelegate <NSObject>

-(void)tagSelected;

@end



@interface RightSideDrawerViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) iCarousel * carousel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, retain) NSDictionary* responseData;
@property (nonatomic, retain) NSMutableArray * sectionFoldFlags;

@property (nonatomic,retain) id <RightSideDrawerDelegate>delegate;
@end

