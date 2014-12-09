//
//  BabyInfoViewController.m
//  baobaowansha2
//  babyinfo has 2 status: stored locally/synced remotely
//  press sync btn will only sync remotely.
//
//  Created by 刘昕 on 14/11/17.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "BabyInfoViewController.h"
#import "RETableViewManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "LeftSideDrawerViewController.h"

@interface BabyInfoViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETextItem *nameItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *dateTimeItem;
@property (strong, readwrite, nonatomic) RESegmentedItem *sexSegmentItem;
@property (strong, readwrite, nonatomic) RESegmentedItem *babamamaSelectItem;

//@property (strong, readwrite, nonatomic) RETableViewItem *buttonItem;

// indicate whether information is synced with server end
//@property (nonatomic) BOOL synced;


@end

@implementation BabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    self.title = @"宝贝信息";
    
    [self createSettingTableCells];
    
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSMutableDictionary *)formatBabyInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.nameItem.value forKey:@"babyName"];
    [dict setObject:[NSNumber numberWithInteger:self.sexSegmentItem.value] forKey:@"babySex"];
    [dict setObject:[NSNumber numberWithInteger:self.babamamaSelectItem.value] forKey:@"babaOrMama"];
    [dict setObject:self.dateTimeItem.value forKey:@"babyBirthday"];
    return dict;
}

- (void) applicationWillResignActive:(NSNotification *)notification
{
    NSString *filePath = [self dataFilePath];
    NSMutableDictionary *dict = [self formatBabyInfo];
    [dict writeToFile:filePath atomically:YES];
    NSLog(@"Baby Information is persistented into plist: %@", dict);
}



/*
#pragma mark - Navigation
 */

- (void) createSettingTableCells
{
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    
    RETableViewSection *babySection = [RETableViewSection sectionWithHeaderTitle:@"宝贝设置" footerTitle:@""];
    [self.manager addSection:babySection];
    RETableViewSection *mamaSection = [RETableViewSection sectionWithHeaderTitle:@"父母设置" footerTitle:@"信息展示可能会针对父母有所不同"];
    [self.manager addSection:mamaSection];
    [self addButton];
    
    // Add items
    //
    self.nameItem = [RETextItem itemWithTitle:@"宝贝昵称: " value:@" " placeholder:@""];
    
    NSDate *myDate = [NSDate date];
    self.dateTimeItem = [REDateTimeItem itemWithTitle:@"宝贝生日: " value:myDate placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    self.dateTimeItem.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.dateTimeItem.textAlignment = NSTextAlignmentCenter;
    
    self.sexSegmentItem = [RESegmentedItem itemWithTitle:@"宝贝性别: " segmentedControlTitles:@[@"女孩", @"男孩", @"龙凤胎"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        //NSLog(@"Value: %li", (long)item.value);
    }];
    
    self.babamamaSelectItem = [RESegmentedItem itemWithTitle:@"我是: " segmentedControlTitles:@[@"妈妈", @"爸爸", @"其他"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        //NSLog(@"Value: %li", (long)item.value);
    }];
    
    
    // TODO: load plist information as init value
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        self.nameItem.value = [dict valueForKey:@"babyName"];
        self.sexSegmentItem.value = [[dict valueForKey:@"babySex"] integerValue];
        self.dateTimeItem.value = [dict valueForKey:@"babyBirthday"];
        self.babamamaSelectItem.value = [[dict valueForKey:@"babaOrMama"] integerValue];
        
    } else {
        NSLog(@"file is not exist");
    }
    
    
    [mamaSection addItem:self.babamamaSelectItem];
    [babySection addItem:self.nameItem];
    [babySection addItem:self.sexSegmentItem];
    [babySection addItem:self.dateTimeItem];
    
    
    // register callback for plist storage
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:app];
}


- (RETableViewSection *)addButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    NSString * btnTitle = @"保存";
    
 
    RETableViewItem * buttonItem = [RETableViewItem itemWithTitle:btnTitle accessoryType:UITableViewCellAccessoryNone  selectionHandler:^(RETableViewItem *item) {
            item.title = @"保存中...";
            // save baby birthday into UserDefaults for leftSideDrawerViewController header image use
            [[NSUserDefaults standardUserDefaults] setObject:self.dateTimeItem.value forKey:@"babyBirthday"];
            //[self.appDelegate.drawerController.leftDrawerViewController initHeaderSection];
            [self syncBabyInfoSettings:item];
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    
    [section addItem:buttonItem];
 
    return section;
}

- (void) syncBabyInfoSettings: (RETableViewItem *)item
{
    // TODO: sync with server side
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"保存中...";
    [HUD showInView:self.view];
    HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    
    
    NSString * userInfoURL = [self.appDelegate.rootURL stringByAppendingString:@"/serverside/user_info.php"];
    
    
    AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
    afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dict = [self formatBabyInfo];

//    [afnmanager POST:@"http://blogtest.yhb360.com/test/syncbabyinfo.php" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[self.buttonItem s:];
        //[self.buttonItem setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"babyInfoSynced"];

    [dict setObject:self.appDelegate.generatedUserID forKey:@"userIdStr"];
    NSLog(@"sending: %@", dict);
    [afnmanager POST:userInfoURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        item.title = @"保存";
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
        
        

        NSLog(@"Sync successed: %@", responseObject);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userHasLogged"];
            HUD.textLabel.text = @"保存成功";
            HUD.detailTextLabel.text = nil;
            
            HUD.layoutChangeAnimationDuration = 0.4;
            HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        });
        //[self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sync Error: %@", error);
        item.title = @"保存失败, 请重试";
        [HUD dismiss];
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];

    }];
    
}


// get plist path
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"babyinfo.plist"];
}






@end
