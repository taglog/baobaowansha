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
@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)UILabel *postTitle;
@property(nonatomic,strong)UITextView *postContent;

@end

@implementation PostView

//初始化PostView的样式
-(id)initWithDict:(NSDictionary *)dict frame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    _dict = dict;
    self.backgroundColor = [UIColor whiteColor];
    //标题栏
    self.postTitle = [[UILabel alloc] init];
    self.postTitle.text = [dict valueForKey:@"post_title"];
    self.postTitle.textColor = [UIColor blackColor];
    
    
    _textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1000)];
    
    // we draw images and links via subviews provided by delegate methods
    _textView.shouldDrawImages = NO;
    _textView.shouldDrawLinks = NO;
    
    [_textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _textView.contentInset = UIEdgeInsetsMake(20, 15, 14, 15);
    _textView.scrollEnabled = NO;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:_textView];
    
    
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _textView.frame.size.height, frame.size.width,1000)];
    
    
    [self addSubview:self.commentTableView];
    
    
    [self addSubview:_postTitle];

    
    [self setNeedsLayout];
    
    
    return self;


}

-(void)layoutSubviews{
    
    padding = 15.0f;
    
    //标题栏
    _postTitle.frame = CGRectMake(padding, padding, self.frame.size.width - 2*padding, 25.0f);
    _postTitle.textColor = [UIColor blackColor];
    _postTitle.font = [UIFont systemFontOfSize:20.0f];
    
}
@end
