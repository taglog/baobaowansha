//
//  CollectionHeaderView.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/12/15.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width, self.frame.size.height)];
        self.sectionHeader.text = @"title is not set";
        self.sectionHeader.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        self.sectionHeader.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];
        [self.sectionHeader sizeToFit];
        self.sectionHeader.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.sectionHeader];

    }
    
    
    return self;
}


@end
