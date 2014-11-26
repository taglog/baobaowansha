//
//  PickerView.h
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/24.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickerViewDelegate
-(void)dateSelected;
-(void)datePickerCanceled;
@end
@interface PickerView : UIView

@property(nonatomic,strong)UIDatePicker *datePicker;

@property(nonatomic,retain)id<PickerViewDelegate> delegate;

@end
