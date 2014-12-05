//
//  CommentCreateViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/12/2.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentCreateDelegate

-(void)commentCreateSuccess:(NSDictionary*)dict;

@end
@interface CommentCreateViewController : UIViewController<UITextViewDelegate>

-(id)initWithID:(NSInteger)postID;
@property(nonatomic,retain)id<CommentCreateDelegate>delegate;

@end
