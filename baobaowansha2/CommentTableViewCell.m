//
//  CommentTableViewCell.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/19.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CommentTableViewCell.h"
@interface CommentTableViewCell()

@property(nonatomic,weak)UIImageView *userImage;

@property(nonatomic,weak)UILabel *userName;

@property(nonatomic,weak)UILabel *stairsNumber;

@property(nonatomic,weak)UILabel *userBabyAge;

@property(nonatomic,weak)UITextView *userComment;

@property(nonatomic,weak)UILabel *commentTime;

@end

@implementation CommentTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        //用户名
        UILabel *userName = [[UILabel alloc] init];
        [self.contentView addSubview:userName];
        self.userName = userName;
        
        //宝宝年龄
        UILabel *userBabyAge = [[UILabel alloc] init];
        [self.contentView addSubview:userBabyAge];
        self.userBabyAge = userBabyAge;
        
        //用户评论
        UITextView *userComment = [[UITextView alloc] init];
        [self.contentView addSubview:userComment];
        self.userComment = userComment;
        
        //评论时间
        UILabel *commentTime = [[UILabel alloc] init];
        [self.contentView addSubview:commentTime];
        self.commentTime = commentTime;
        
        //楼层标识
        UILabel *stairsNumber = [[UILabel alloc] init];
        [self.contentView addSubview:stairsNumber];
        self.stairsNumber = stairsNumber;
        
        [self setFrame];
    }
    
    return self;
}
-(void)setDataWithDict:(NSDictionary *)dict{
    
    self.userName.text = [dict objectForKey:@"userName"];
    
    self.userBabyAge.text = [dict objectForKey:@"userBabyAge"];
    
    self.userComment.text = [dict objectForKey:@"userComment"];
    
    self.commentTime.text = [dict objectForKey:@"commentTime"];
    
    self.stairsNumber.text = [dict objectForKey:@"stairsNumber"];
    
}

-(void)setFrame{
    
    CGFloat paddingHor = 15.0f;
    CGFloat paddingVer = 10.0f;
    
    self.userName.frame = CGRectMake(paddingHor, paddingVer,280,20.0f);
    self.userName.font = [UIFont systemFontOfSize:14.0f];
    self.userName.textColor = [UIColor colorWithRed:254.0f/255.f green:70.0f/255.f blue:116.0f/255.f alpha:1.0];
    
    self.userBabyAge.frame = CGRectMake(250.0f, paddingVer, 80.0f, 20.0f);
    self.userBabyAge.font = [UIFont systemFontOfSize:12.0f];
    self.userBabyAge.textColor = [UIColor colorWithRed:119.0f/255.f green:119.0f/255.f blue:119.0f/255.f alpha:1.0];

    self.userComment.frame = CGRectMake(paddingVer, paddingVer + 20.0f,300, 60.0f);
    self.userComment.font = [UIFont systemFontOfSize:16.0f];

    self.commentTime.frame = CGRectMake(paddingHor, paddingVer + self.userComment.frame.size.height +10.0f, 100.0f, 20.0f);
    self.commentTime.font = [UIFont systemFontOfSize:12.0f];
    self.commentTime.textColor = [UIColor colorWithRed:119.0f/255.f green:119.0f/255.f blue:119.0f/255.f alpha:1.0];

    self.stairsNumber.frame = CGRectMake(290, paddingVer + self.userComment.frame.size.height +10.0f, 20.0f, 20.0f);
    self.stairsNumber.textColor = [UIColor colorWithRed:119.0f/255.f green:119.0f/255.f blue:119.0f/255.f alpha:1.0];
    self.stairsNumber.font = [UIFont systemFontOfSize:12.0f];

    
    
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
