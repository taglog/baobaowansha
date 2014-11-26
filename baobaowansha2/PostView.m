//
//  PostView.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "PostView.h"

@interface PostView()
{
    CGFloat padding;
}
@end

@implementation PostView

//初始化PostView的样式
-(id)initWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    //标题栏
    _postTitle = [[UILabel alloc] init];
    _postTitle.text = [dict valueForKey:@"postTitle"];
    _postTitle.textColor = [UIColor blackColor];
    
    //头图
    _postHeaderImage = [[UIImageView alloc] init];
    _postHeaderImage.image = [UIImage imageNamed:[dict valueForKey:@"postHeaderImage"]];
    
    //文章
    _postContent = [[UITextView alloc] init];
    _postContent.text = [dict valueForKey:@"postContent"];
    
    [self initPostStyle];
    
    [self addSubview:_postTitle];
    [self addSubview:_postHeaderImage];
    [self addSubview:_postContent];
    
    return self;


}

-(void)initPostStyle{
    
    padding = 15.0f;
    
    //标题栏
    _postTitle.frame = CGRectMake(padding, padding, self.frame.size.width - 2*padding, 25.0f);
    _postTitle.textColor = [UIColor blackColor];
    _postTitle.font = [UIFont systemFontOfSize:20.0f];
    
    //头图
    CGFloat postHeaderImageHeight =(self.frame.size.width - 2 * padding) * _postHeaderImage.image.size.height/_postHeaderImage.image.size.width;
    
    _postHeaderImage.frame= CGRectMake(padding, _postTitle.frame.size.height + 2 * padding, self.frame.size.width - 2 * padding,postHeaderImageHeight);
    
    //文章
    _postContent.frame = CGRectMake(padding, _postTitle.frame.size.height + postHeaderImageHeight + 3 * padding, self.frame.size.width - 2*padding, self.frame.size.height);
    _postContent.font = [UIFont systemFontOfSize:14.0f];
}

@end
