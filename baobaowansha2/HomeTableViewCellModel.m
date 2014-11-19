//
//  HomeTableViewCellModel.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "HomeTableViewCellModel.h"

@implementation HomeTableViewCellModel

+(instancetype)initHomeTableCell:(NSDictionary *)dict{
    
    HomeTableViewCellModel *cell = [[self alloc] init];
    [cell setValuesForKeysWithDictionary:dict];
    return cell;
}

@end
