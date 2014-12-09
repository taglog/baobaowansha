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

@interface BabyInfoViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETextItem *nameItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *dateTimeItem;
@property (strong, readwrite, nonatomic) RESegmentedItem *sexSegmentItem;
@property (strong, readwrite, nonatomic) RESegmentedItem *babamamaSelectItem;

@property (strong, readwrite, nonatomic) RETableViewItem *buttonItem;

// indicate whether information is synced with server end
//@property (nonatomic) BOOL synced;


@end

@implementation BabyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    self.title = @"宝贝信息";
    
    [self createSettingTableCells];

    //NSLog(@"NEED REMOVE this flag before publishing(in BabyInfoViewController)");
    //TODO: remove following line after test
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BabyInfoSynced"];
    

    
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
    
    self.sexSegmentItem = [RESegmentedItem itemWithTitle:@"宝贝性别: " segmentedControlTitles:@[@"男孩儿", @"女孩儿"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        //NSLog(@"Value: %li", (long)item.value);
    }];
    
    self.babamamaSelectItem = [RESegmentedItem itemWithTitle:@"我是: " segmentedControlTitles:@[@"爸爸", @"妈妈", @"其他"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
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
    
    NSString * btnTitle = @"更新";
    
 
    self.buttonItem = [RETableViewItem itemWithTitle:btnTitle accessoryType:UITableViewCellAccessoryNone  selectionHandler:^(RETableViewItem *item) {
            item.title = @"更新中, 请稍后...";
            [item setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self syncBabyInfoSettings];
            [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    self.buttonItem.textAlignment = NSTextAlignmentCenter;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"babyInfoSynced"]) {
        btnTitle = @"已更新";
        self.buttonItem.title = btnTitle;
        [self.buttonItem setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    [section addItem:self.buttonItem];
 
    return section;
}

- (void) syncBabyInfoSettings
{
    // TODO: sync with server side
    
    AFHTTPRequestOperationManager *afnmanager = [AFHTTPRequestOperationManager manager];
    afnmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSMutableDictionary *dict = [self formatBabyInfo];
    [afnmanager POST:@"http://blogtest.yhb360.com/test/syncbabyinfo.php" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //[self.buttonItem s:];
        //[self.buttonItem setSelectionStyle:UITableViewCellSelectionStyleNone];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"babyInfoSynced"];
        NSLog(@"Sync successed: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sync Error: %@", error);
        //self.buttonItem.title = @"出错了, 请重试...";
    }];
    
}


// get plist path
- (NSString *) dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"babyinfo.plist"];
}






@end
