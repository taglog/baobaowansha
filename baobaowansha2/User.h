//
//  User.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/20.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (readonly,nonatomic,assign) NSUInteger userID;

@property (readonly,nonatomic,copy) NSString *userSex;

@property (readonly,nonatomic,copy) NSDate *userBabyBirthday;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
