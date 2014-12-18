//
//  CollectionViewCell.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/12/15.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic) BOOL bSel;
@property (nonatomic, retain) UIImageView *badgeView;

@end

@implementation CollectionViewCell

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.imageView = [[UIImageView alloc] init];
        
        self.iconView = [[UIImageView alloc] init];
        
        self.label = [[UILabel alloc] init];
        
        self.bSel = NO;
        
        self.badgeView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}
-(void)setDataWithDict:(NSDictionary *)dict{
    
    
    self.iconView.image = [UIImage imageNamed:[dict valueForKey:@"imgurl"]];
    
    self.iconView.tintColor = [UIColor grayColor] ;
    
    self.label.text = [dict valueForKey:@"tags"];
    
    self.tags = [dict valueForKey:@"tags"];
    
    
    [self setNeedsLayout];
}

- (BOOL) isSel
{
    //NSLog(@"%hhd", self.bSel);
    return self.bSel;
}

- (void) setSel:(BOOL) bs
{
    self.bSel = bs;
    if (bs) {
        self.badgeView.image = [UIImage imageNamed:@"check.png"];
    } else {
        self.badgeView.image = [UIImage imageNamed:@""];
    }
}

//设置frame
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 81, 81);
    self.imageView.layer.borderColor = [UIColor colorWithRed:(94/255.0) green:(97/255.0) blue:(99/255.0) alpha:1.0f].CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    
    self.iconView.frame = CGRectMake(28, 16, 24, 24);
    
    
    self.label.frame = CGRectMake(0, 50, 80, 16);
    self.label.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.label.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    self.badgeView.frame = CGRectMake(60, 5, 15, 15);
    
}
@end
