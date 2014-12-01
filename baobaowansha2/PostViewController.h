//
//  PostViewController.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/14.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAttributedTextView.h"
#import "DTLazyImageView.h"
#import "DTCoreText.h"
#import "EGORefreshCustom.h"

@interface PostViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,EGORefreshDelegate>

-(void)initViewWithDict:(NSDictionary *)dict;


@end
