//
//  CollectionViewCell.h
//  baobaowansha2
//
//  Created by PanYongfeng on 14/12/15.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) NSString * tags;

@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *label;

- (BOOL) isSel;
- (void) setSel:(BOOL) bs;

-(void)setDataWithDict:(NSDictionary *)dict;
@end
