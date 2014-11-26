//
//  PickerView.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/24.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    NSDate *now = [NSDate date];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f,40.0f, self.bounds.size.width, 180.0f)];
    [self.datePicker setDate:now animated:NO];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    UILabel *datePickerLabel = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, 0.0f, self.bounds.size.width - 120.0f, 40.0f)];
    datePickerLabel.text =@"请选择您宝宝的生日";
    datePickerLabel.font = [UIFont systemFontOfSize:12.0f];
    datePickerLabel.textAlignment = NSTextAlignmentCenter;
    datePickerLabel.textColor = [UIColor whiteColor];
    datePickerLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:86.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
    
    UIButton *datePickerCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.0f, 60.0f, 40.0f)];
    [datePickerCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    datePickerCancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    datePickerCancelButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:86.0f/255.0f blue:170.0f/255.0f alpha:1.0f];
    [datePickerCancelButton addTarget:self.delegate action:@selector(datePickerCanceled) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *datePickerConfirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 60.0f, 0.0f, 60.0f, 40.0f)];
    [datePickerConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    datePickerConfirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    datePickerConfirmButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:86.0f/255.0f blue:170.0f/255.0f alpha:1.0f];    [datePickerConfirmButton addTarget:self.delegate action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.datePicker];
    [self addSubview:datePickerLabel];
    [self addSubview:datePickerCancelButton];
    [self addSubview:datePickerConfirmButton];
    
    return self;
}


@end
