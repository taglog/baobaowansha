//
//  PostView.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/18.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCoreText.h"
#import "DTAttributedTextView.h"
#import "DTLazyImageView.h"
#import "DTTiledLayerWithoutFade.h"

@interface PostView : UIScrollView

@property(nonatomic,strong)DTAttributedTextView *textView;
@property(nonatomic,strong)UITableView *commentTableView;

-(id)initWithDict:(NSDictionary *)dict frame:(CGRect)frame;


@end
