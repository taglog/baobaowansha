//
//  CommentCreateViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/12/2.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "CommentCreateViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@interface CommentCreateViewController ()

@property(nonatomic,strong)UITextView *commentTextView;
//该post的ID
@property(nonatomic,assign)NSInteger postID;
//post到后台的字典
@property(nonatomic,strong)NSDictionary *commentPostParams;

@property (nonatomic,retain)AppDelegate *appDelegate;
@end

@implementation CommentCreateViewController

-(id)initWithID:(NSInteger)postID{
    self = [super init];
    self.postID = postID;
    return self;
}

- (void)loadView {
    [super loadView];
    //提交按钮
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"checkmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(commentSubmit)];
    submitButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    //自定义leftBarButtonItem以取代返回按钮
    UIBarButtonItem *backButtonCustom = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    backButtonCustom.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = backButtonCustom;
    self.view.backgroundColor = [UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1.0f];
    
    self.title = @"写评论";
    
    _commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(15.0f, 15.0f, self.view.frame.size.width - 30.0f , 250.0f)];
    
    _commentTextView.textColor = [UIColor blackColor];
    
    _commentTextView.delegate = self;
    
    _commentTextView.backgroundColor = [UIColor whiteColor];
    
    _commentTextView.returnKeyType = UIReturnKeyDefault;
    
    _commentTextView.keyboardType = UIKeyboardTypeDefault;
    _commentTextView.font = [UIFont systemFontOfSize:14.0f];
   
    _commentTextView.text = @"请在此输入您的评论";
    
    _commentTextView.textColor = [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1.0f];
    
    _commentTextView.scrollEnabled = YES;
    
    _commentTextView.contentInset = UIEdgeInsetsMake(15.0f, 0.0f, 10.0f, 10.0f);
    _commentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _commentTextView.layer.borderWidth = 1;
    
    _commentTextView.layer.borderColor = [[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]CGColor];

    [self.view addSubview:_commentTextView];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请在此输入您的评论"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)commentSubmit{
    
    NSString *text = _commentTextView.text;
   
    //如果用户输入不为空
    if(![text isEqualToString:@""] && ![text isEqualToString:@"请在此输入您的评论"]){
        
        NSString *documentsDirectory = @"/Users/liuxin/Documents/documents";
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
        NSDictionary *userInfo;
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            userInfo = [[NSDictionary alloc]initWithContentsOfFile:filePath];
            self.commentPostParams = @{@"comment_post_ID":[NSNumber numberWithInteger:_postID],@"comment_content":text,@"comment_author":[userInfo valueForKey:@"userName"]};
         }
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *commentCreateRouter = @"/comment/create";
        NSString *commentCreateRequestUrl = [self.appDelegate.rootURL stringByAppendingString:commentCreateRouter];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:commentCreateRequestUrl  parameters:self.commentPostParams success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSInteger status = [[responseObject valueForKey:@"status"]integerValue];
            if(status == 1){
                
                NSDictionary *commentToPostViewController = [NSDictionary dictionaryWithObjectsAndKeys:[userInfo valueForKey:@"userName"],@"comment_author",text,@"comment_content",[responseObject valueForKey:@"comment_date"],@"comment_date",[responseObject valueForKey:@"comment_id"],@"comment_id", nil];
                //输入完成，应该跳回到上一页，同时把上一页的tableView刷新
                [self.delegate commentCreateSuccess:commentToPostViewController];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                //否则的话，弹出一个指示层
                
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@",error);
        }];
        
    }else{
        //用户没有输入的时候，该做些什么
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
