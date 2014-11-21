//
//  User.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/20.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "User.h"
@interface User()

@property (readwrite, nonatomic, assign) NSUInteger userID;
@property (readwrite, nonatomic, copy) NSString *userSex;
@property (readwrite, nonatomic, copy) NSDate *userBabyBirthday;

@end
@implementation User

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        
        self.userID = (NSUInteger)[[dict valueForKey:@"userID"] integerValue];
        self.userSex = [dict valueForKey:@"userSex"];
        self.userBabyBirthday = [dict valueForKey:@"userBabyBirthday"];
    
    
    }
    
    return self;
}
@end
