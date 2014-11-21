//
//  PostView.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostView : UIView

@property(nonatomic,strong)UILabel *postTitle;
@property(nonatomic,strong)UIImageView *postHeaderImage;
@property(nonatomic,strong)UITextView *postContent;

-(id)initWithDict:(NSDictionary *)dict frame:(CGRect)frame;

@end
