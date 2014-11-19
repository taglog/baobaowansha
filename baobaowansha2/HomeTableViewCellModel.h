//
//  HomeTableViewCellModel.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTableViewCellModel : NSObject

//缩略图
@property (nonatomic,copy) NSString *image;

//标题
@property (nonatomic,copy) NSString *title;

//摘要
@property (nonatomic,copy) NSString *introduction;

//适合年龄
@property (nonatomic,copy) NSString *age;

//收藏人数
@property (nonatomic,copy) NSNumber *collectionNumber;

//评论人数
@property (nonatomic,copy) NSNumber *commentNumber;


#pragma mark - 接口

//初始化cell
+(instancetype)initHomeTableCell:(NSDictionary *)dict;

@end
