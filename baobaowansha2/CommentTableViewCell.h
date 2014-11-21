//
//  CommentTableViewCell.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/19.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property(nonatomic,strong)NSDictionary *commentViewCell;

-(void)setDataWithDict:(NSDictionary *)dict;

@end
