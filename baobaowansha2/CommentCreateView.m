//
//  CommentCreateView.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/12/1.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CommentCreateView.h"

@implementation CommentCreateView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self initViews:frame];
    return self;
}
-(void)initViews:(CGRect)frame{
    UITextView *commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(15.0f, 15.0f, frame.size.height - 30,400)];
    
    
    
    [self addSubview:commentTextView];
    
}
@end
