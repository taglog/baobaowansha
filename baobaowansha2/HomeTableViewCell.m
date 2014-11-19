//
//  HomeTableViewCell.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/12.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell()

//缩略图
@property (nonatomic,weak) UIImageView *image;

//标题
@property (nonatomic,weak) UILabel *title;

//摘要
@property (nonatomic,weak) UILabel *introduction;

//适合年龄
@property (nonatomic,weak) UILabel *age;

//收藏人数
@property (nonatomic,weak) UILabel *collectionNumber;

//评论人数
@property (nonatomic,weak) UILabel *commentNumber;

@end

@implementation HomeTableViewCell

//初始化Cell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //添加缩略图
        UIImageView *image = [[UIImageView alloc] init];
        [self.contentView addSubview:image];
        self.image = image;
        
        //添加标题
        UILabel *title = [[UILabel alloc] init];
        [self.contentView addSubview:title];
        self.title = title;
        
        //添加摘要
        UILabel *introduction = [[UILabel alloc] init];
        [self.contentView addSubview:introduction];
        self.introduction = introduction;
        
        //添加适合年龄
        UILabel *age = [[UILabel alloc] init];
        [self.contentView addSubview:age];
        self.age = age;
        
        //添加收藏人数
        UILabel *collectionNumber = [[UILabel alloc] init];
        [self.contentView addSubview:collectionNumber];
        self.collectionNumber = collectionNumber;
        
        //添加评论人数
        UILabel *commentNumber = [[UILabel alloc] init];
        [self.contentView addSubview:commentNumber];
        self.commentNumber = commentNumber;
        
        [self initWithFrame];
    }
    return self;
}

//给Cell中的key赋值
-(void)initWithDict:(NSDictionary *)dict{
    
    self.image.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    
    self.title.text = [dict objectForKey:@"title"];
    
    self.introduction.text = [dict objectForKey:@"introduction"];
    
    self.age.text = [dict objectForKey:@"age"];
    
    self.collectionNumber.text = [NSString stringWithFormat:@"收藏 %@",[dict objectForKey:@"collectionNumber"]];
    
    self.commentNumber.text = [NSString stringWithFormat:@"评论 %@",[dict objectForKey:@"commentNumber"]];
    
}

//设置Cell子控件的frame
-(void)initWithFrame{
    //padding
    CGFloat padding = 15.0;
    UIColor *detailColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0];
    
    //缩略图的frame
    self.image.frame = CGRectMake(padding, padding, 100.0, 100.0);
    self.image.contentMode = UIViewContentModeScaleToFill;
    
    //标题的frame
    self.title.frame = CGRectMake(125.0, padding, self.frame.size.width - 100.0, 20.0);
    self.title.textColor = [UIColor blackColor];
    self.title.font = [UIFont systemFontOfSize:20.0];
    
    //摘要的frame
    self.introduction.frame = CGRectMake(125.0, 30.0,self.frame.size.width - 100.0, 60.0);
    self.introduction.font = [UIFont systemFontOfSize:14.0];
    self.introduction.textColor = detailColor;
    self.introduction.numberOfLines = 2;
    [self.introduction setLineBreakMode:NSLineBreakByWordWrapping];
    
    //年龄的frame
    self.age.frame = CGRectMake(125.0, 86.0, 100.0, 30);
    self.age.font = [UIFont systemFontOfSize:14.0];
    self.age.textColor = detailColor;
    
    //收藏数量的frame
    self.collectionNumber.frame = CGRectMake(225.0, 86.0, 60.0, 30.0);
    self.collectionNumber.font = [UIFont systemFontOfSize:14.0];
    self.collectionNumber.textColor = detailColor;
    
    //评论数量的frame
    self.commentNumber.frame = CGRectMake(285.0, 86.0, 60.0, 30.0);
    self.commentNumber.font  = [UIFont systemFontOfSize:14.0];
    self.commentNumber.textColor = detailColor;
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
