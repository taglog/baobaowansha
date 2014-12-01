//
//  PostViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/14.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "PostViewController.h"
#import "CommentTableViewCell.h"
#import "DTTiledLayerWithoutFade.h"
#import "AFNetworking.h"
#import "CommentCreateViewController.h"

@interface PostViewController ()
{
    CGFloat padding;
    CGRect _frame;
    
}
//scrollView里放入textView和评论的tableView
@property(nonatomic,retain) UIScrollView *postScrollView;
@property(nonatomic,retain) DTAttributedTextView *textView;
@property(nonatomic,retain) UITableView *commentTableView;

@property(nonatomic,retain) UIButton *commentCreateButton;
//接收到的post数据
@property(nonatomic,strong) NSDictionary *postDict;

//把postTitle放入textView里面一起显示
@property(nonatomic,strong)NSString *postTitle;
@property(nonatomic,strong)NSString *postContent;
@property(nonatomic,strong)NSString *htmlPostContent;

//得到计算过后的textViewSize
@property(nonatomic,assign)CGSize textViewSize;

//上拉刷新的评论
@property (nonatomic,retain)EGORefreshCustom *refreshFooterView;

//用来更新tableViewCell的数组
@property(nonatomic,strong)NSMutableArray *commentTableViewCell;

//是否reloading标志
@property (nonatomic,assign)BOOL reloading;

//postID
@property(nonatomic,assign)NSInteger postID;

@end

@implementation PostViewController

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comment24x24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushCommentViewController)];
    commentButton.tintColor = [UIColor blackColor];
    UIBarButtonItem *fixedSpaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceButton.width = 10;
    UIBarButtonItem *collectionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star32x32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(collect)];
    collectionButton.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[collectionButton,fixedSpaceButton,commentButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)initViewWithDict:(NSDictionary *)dict{
    
    _postDict = dict;
    _postID = [[dict valueForKey:@"ID"]integerValue];
    _frame = self.view.frame;
    
    //初始化textView
    [self initTextView];
    
    //根据textView的大小
    _postScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 64.0f)];
    _postScrollView.contentSize = CGSizeMake(self.view.frame.size.width, _textViewSize.height + 667);
    _postScrollView.delegate = self;
    
    //初始化底部的Button
    _commentCreateButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60.0f, self.view.frame.size.width, 60.0f)];
    _commentCreateButton.backgroundColor = [UIColor redColor];
    [_commentCreateButton addTarget:self action:@selector(pushCommentCreateViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentCreateButton];
    [self.view addSubview:_postScrollView];
    //根据textView的大小，设置tableView的origin.y
    [self initTableView];
    [self initCommentTableView];
    
    [_postScrollView addSubview:_textView];
    
    
        
}

//初始化textView
-(void)initTextView{
    
    self.postTitle = [_postDict valueForKey:@"post_title"];
    self.postContent = [_postDict valueForKey:@"post_content"];
    
    //初始化PostTitle
    NSString *htmlPostTitleStart = @"<h2 style='font-size:26px;color:#33333;margin:10px 0'>";
    NSString *htmlPostTitleWithStart = [htmlPostTitleStart stringByAppendingString:self.postTitle];
    NSString *htmlPostTItleWithEnd = [htmlPostTitleWithStart stringByAppendingString:@"</h2>"];
    self.htmlPostContent = [htmlPostTItleWithEnd stringByAppendingString:self.postContent];
    
    //初始化DTTextView
    _textView = [[DTAttributedTextView alloc] init];
    
    
    _textView.shouldDrawImages = NO;
    _textView.shouldDrawLinks = NO;
    _textView.scrollEnabled = NO;
    _textView.textDelegate = self;
    
    
    [_textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    _textView.contentInset = UIEdgeInsetsMake(10, 15, 14, 15);
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    _textView.attributedString = [self _attributedStringForSnippetUsingiOS6Attributes:NO];
    
    _textViewSize = [self getTextViewHeight:_textView.attributedString];
    _textView.frame = CGRectMake(0, 0, _frame.size.width, _textViewSize.height + 128.0f);
    
}

-(CGSize)getTextViewHeight:(NSAttributedString *)string{
    
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:string];
    
    CGRect maxRect = CGRectMake(10, 20, _frame.size.width, CGFLOAT_HEIGHT_UNKNOWN);
    NSRange entireString = NSMakeRange(0, [string length]);
    DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireString];
    
    CGSize sizeNeeded = [layoutFrame frame].size;
    
    return sizeNeeded;
}

#pragma mark Custom Views on Text

- (NSAttributedString *)_attributedStringForSnippetUsingiOS6Attributes:(BOOL)useiOS6Attributes
{
    // Load HTML data
    NSString *html = self.htmlPostContent;
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(_frame.size.width-30.0, _frame.size.height - 280.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
                                    [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
                                    @"Helvetica Neue", DTDefaultFontFamily,
                                    @"purple", DTDefaultLinkColor,
                                    @"red", DTDefaultLinkHighlightColor,
                                    callBackBlock, DTWillFlushBlockCallBack,
                                    [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                                    [NSNumber numberWithInt:16],DTDefaultFontSize,
                                    nil];
    
    if (useiOS6Attributes)
    {
        [options setObject:[NSNumber numberWithBool:YES] forKey:DTUseiOS6Attributes];
    }
    
    //[options setObject:[NSURL fileURLWithPath:readmePath] forKey:NSBaseURLDocumentOption];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    
    return string;
}



- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTVideoTextAttachment class]])
    {
        // removed temp for no video is supported
    }
    else if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL)
        {
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = NO;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            // use normal push action for opening URL
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            // demonstrate combination with long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            [button addGestureRecognizer:longPress];
            
            [imageView addSubview:button];
        }
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
    {
        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
        videoView.attachment = attachment;
        
        return videoView;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    CGColorRef color = [textBlock.backgroundColor CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    
    return YES; // draw standard background
}


#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button
{
    NSURL *URL = button.URL;
    
    if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
    {
        [[UIApplication sharedApplication] openURL:[URL absoluteURL]];
    }
    else
    {
        if (![URL host] && ![URL path])
        {
            
            // possibly a local anchor link
            NSString *fragment = [URL fragment];
            
            if (fragment)
            {
                [_textView scrollToAnchorNamed:fragment animated:NO];
            }
        }
    }
}


- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
        
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]])
        {
            //UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
            //[action showFromRect:button.frame inView:button.superview animated:YES];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [gesture locationInView:_textView];
        NSUInteger tappedIndex = [_textView closestCursorIndexToPoint:location];
        
        NSString *plainText = [_textView.attributedString string];
        NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];
        
        __block NSRange wordRange = NSMakeRange(0, 0);
        
        [plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (NSLocationInRange(tappedIndex, enclosingRange))
            {
                *stop = YES;
                wordRange = substringRange;
            }
        }];
        
        NSString *word = [plainText substringWithRange:wordRange];
        NSLog(@"%lu: '%@' word: '%@'", (unsigned long)tappedIndex, tappedChar, word);
    }
}


#pragma mark - DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that matchin this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        [_textView relayoutText];
    }
}

//初始化评论栏

#pragma  mark 评论 tableView delegate
-(void)initCommentTableView{
    
    //初始化homeTableViewCell
    self.commentTableViewCell = [[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://localhost/baobaowansha/comment/get?id=%li&p=1",(long)_postID] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSArray *responseArray = [responseObject valueForKey:@"data"];
        if(responseArray != (id)[NSNull null]){
            for(NSString *responseDict in responseArray){
                NSDictionary *dict = [responseArray valueForKey:responseDict];
                [self.commentTableViewCell addObject:dict];
            }
            
            [self resetCommentTableViewHeight:self.commentTableViewCell];
            
            [self initRefreshView];
            
        }else{
            
            UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(100,100, 100, 100)];
            label.text = @"没有评论";
            [self.view addSubview:label];
            
            
            
            
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//初始化tableView
-(void)initTableView{
    
    if(!_commentTableView){
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _textViewSize.height + 128, self.view.frame.size.width, self.view.frame.size.height)];
        
        _commentTableView.scrollEnabled = NO;
        
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [_postScrollView addSubview:_commentTableView];
        [_commentTableView setSeparatorInset:UIEdgeInsetsZero];
        UIView *commentTableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
        commentTableHeader.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0 alpha:1.0];
        UILabel *commentTableHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, 100.0f, 20.0f)];
        commentTableHeaderLabel.text = @"评论";
        commentTableHeaderLabel.font = [UIFont systemFontOfSize:14.0f];
        [commentTableHeader addSubview:commentTableHeaderLabel];
        _commentTableView.tableHeaderView = commentTableHeader;
    }
}

//初始化下拉刷新header
-(void)initRefreshView{
   
    _refreshFooterView = [[EGORefreshCustom alloc] initWithTableView:_postScrollView position:EGORefreshFooter];
    _refreshFooterView.delegate = self;
    _refreshFooterView.frame = CGRectMake(0, _postScrollView.contentSize.height, self.view.frame.size.width, 100.0f);
    [_postScrollView addSubview:_refreshFooterView];
    
}


#pragma mark -commentTableView 委托实现

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentTableViewCell.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Comment";
    CommentTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell setDataWithDict:self.commentTableViewCell[indexPath.row] frame:_frame];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [CommentTableViewCell heightForCellWithDict:self.commentTableViewCell[indexPath.row] frame:self.view.frame];
}

-(void)resetCommentTableViewHeight:(NSMutableArray *)commentTableViewCell{
    
    CGFloat height = 0;
    NSUInteger length = [commentTableViewCell count];
    for(int i = 0;i < length ; i++){
        height  += [CommentTableViewCell heightForCellWithDict:commentTableViewCell[i] frame:_frame];
    }
    
    [_commentTableView reloadData];
    
    [_postScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _textViewSize.height + height + 128)];
    
    [_commentTableView setFrame:CGRectMake(0, _textViewSize.height + 128, self.view.frame.size.width, height)];
    [_refreshFooterView setFrame:CGRectMake(0, _postScrollView.contentSize.height, self.view.frame.size.width, 100.0f)];
    
}
#pragma mark 下拉数据刷新
- (void)reloadTableViewDataSource{

    //上拉刷新的数据处理
    if(_refreshFooterView.pullUp){
        static int p = 2;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"http://localhost/baobaowansha/comment/get?id=%ld&p=%d",(long)_postID,p] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
            
            NSArray *responseArray = [responseObject valueForKey:@"data"];
            if(responseArray != (id)[NSNull null]){
                for(NSString *responseDict in responseArray){
                    NSDictionary *dict = [responseArray valueForKey:responseDict];
                    [_commentTableViewCell addObject:dict];
                }
                 _reloading = YES;
                [self resetCommentTableViewHeight:self.commentTableViewCell];
                [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0f];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        ++p;
        
    }
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_commentTableView];
    
}

#pragma mark - _postScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y > (_textViewSize.height - 400.0f)){
        [self.view bringSubviewToFront:_commentCreateButton];
        [UIView animateWithDuration:0.3 animations:^{
            _commentCreateButton.frame = CGRectMake(0,self.view.frame.size.height - 60, self.view.frame.size.width, 60.0f);
        //如果更改scrollView的frame，那么就会发生底部的抖动，这该怎么办
//            _postScrollView.frame = CGRectMake(0, 64.0f, self.view.frame.size.width, self.view.frame.size.height - 124.0f);
        }  completion:^(BOOL finished){
            
        }];

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            
        _commentCreateButton.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, 60.0f);
            
    }  completion:^(BOOL finished){
        
    }];
        
    }
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshCustom *)view{
    [self reloadTableViewDataSource];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshCustom *)view{
    
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshCustom *)view{
    
    return [NSDate date];
    
}
//创建评论的View
-(void)pushCommentCreateViewController{
    CommentCreateViewController *commentCreateViewController = [[CommentCreateViewController alloc]init];
    [self.navigationController presentViewController:commentCreateViewController animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
