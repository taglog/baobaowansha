//
//  LeftSideDrawerViewController.m
//  baobaowansha2
//
//  Created by PanYongfeng on 14/11/21.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "LeftSideDrawerViewController.h"
#import "MMSideDrawerTableViewCell.h"


#import "HomeViewController.h"
#import "BabyInfoViewController.h"
#import "CollectionViewController.h"
#import "SettingsViewController.h"
#import "FeedbackViewController.h"
#import "CommentViewController.h"

@interface LeftSideDrawerViewController ()

@end

@implementation LeftSideDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentController = @"HomeViewControllerID";
    self.navHome = self.mm_drawerController.centerViewController;
    

    // display parameters: setting to 240 points
    [self.mm_drawerController setMaximumLeftDrawerWidth:200.0];
    
    // opener drawer gesture parameters:
    self.mm_drawerController.openDrawerGestureModeMask ^= MMOpenDrawerGestureModePanningNavigationBar^MMOpenDrawerGestureModePanningCenterView^MMOpenDrawerGestureModeBezelPanningCenterView;
    
    // close drawer gestrure parameters:
    self.mm_drawerController.closeDrawerGestureModeMask ^= MMCloseDrawerGestureModePanningNavigationBar^MMCloseDrawerGestureModePanningCenterView^MMCloseDrawerGestureModeBezelPanningCenterView^MMCloseDrawerGestureModeTapNavigationBar^MMCloseDrawerGestureModeTapCenterView^MMCloseDrawerGestureModePanningDrawerView;
    
    
    // shadow parameter: no shadow
    [self.mm_drawerController setShowsShadow:!self.mm_drawerController.showsShadow];
    
    // stretch drawer
    [self.mm_drawerController setShouldStretchDrawer:!self.mm_drawerController.shouldStretchDrawer];
    //[self initHeaderSection];
    
}


// 此处有一点小技巧，为了能让月龄badge能在设置之后得到更新，我们故意使用了viewWillAppear方法，从而可以在MMDrawerController.left...中调用，
// 因为left...放得是一个UIViewController类

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self setHeaderWords:@"0"];
    [self setSubLableWords:@"宝贝年龄"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"babyBirthday"]) {
        NSDate * babybirthday = [[NSUserDefaults standardUserDefaults] objectForKey:@"babyBirthday"];
        NSTimeInterval intv = -1*babybirthday.timeIntervalSinceNow;
        double inDays = intv/(24*3600);
        NSLog(@"baby days is %f", inDays);
        if (inDays < 0) {
            [self setHeaderWords:@"0"];
            [self setSubLableWords:@"宝贝周龄"];
        } else if (inDays < 7*12) {
            int inWeeks = inDays/7;
            [self setHeaderWords:[NSString stringWithFormat:@"%d",inWeeks]];
            [self setSubLableWords:@"宝贝周龄"];
        } else if (inDays < 24*30) {
            int inMonths = inDays/30;
            NSLog(@"in months %d", inMonths);
            [self setHeaderWords:[NSString stringWithFormat:@"%d",inMonths]];
            [self setSubLableWords:@"宝贝月龄"];
        } else {
            int inYears = inDays/365;
            int restDays = (int)inDays%365;
            int inMonths = restDays/30;
            NSString *stringInt = [NSString stringWithFormat:@"%d",inYears];
            [self setHeaderWords:stringInt];
            stringInt = [NSString stringWithFormat:@"%d岁%d个月",inYears, inMonths];
            [self setSubLableWords:stringInt];
        }
    }
    
    //[self setHeaderImage:@"headerImage.jpg"];
    //[self setHeaderWords:@"66"];
    //[self setSubLableWords:@"dfjd"];
    
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 164.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 90, 90)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:self.headerImage];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0;
        //imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        //imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor colorWithRed:220/255.0f green:87/255.0f blue:116/255.0f alpha:0.8f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 0, 64)];
        label.text = self.headerWords;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:52];
        //label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 0, 20)];
        sublabel.text = self.subLableWords;
        sublabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        //label.backgroundColor = [UIColor clearColor];
        sublabel.textColor = [UIColor colorWithRed:220/255.0f green:223/255.0f blue:226/255.0f alpha:1.0f];
        [sublabel sizeToFit];
        sublabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:sublabel];
        view;
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case MMDrawerSection1:
            return 3;
        case MMDrawerSection2:
            return 2;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    switch (indexPath.section) {
        case MMDrawerSection1:
            if(indexPath.row == 0){
                [cell.textLabel setText:@"首页"];
            } else if(indexPath.row == 1) {
                [cell.textLabel setText:@"我的收藏"];
            } else {
                [cell.textLabel setText:@"我的评论"];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case MMDrawerSection2:
            if(indexPath.row == 0){
                [cell.textLabel setText:@"反馈"];
            }
            else {
                [cell.textLabel setText:@"设置"];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;

        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case MMDrawerSection1:
            return @"我的";
        case MMDrawerSection2:
            return @"设置:";

        default:
            return nil;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section is %d, row is %d", (int)indexPath.section, (int)indexPath.row);
    
    
    switch (indexPath.section) {
        case MMDrawerSection1:{
            if (indexPath.row == 0) {
                if(self.navHome == nil) {
                    UIViewController * centerViewController = [[HomeViewController alloc] init];
                    self.navHome = [[UINavigationController alloc] initWithRootViewController:centerViewController];
                }
                
                if ([self.currentController isEqual: @"HomeViewControllerID"]) {
                    [self.mm_drawerController
                     setCenterViewController:self.navHome
                     withCloseAnimation:YES
                     completion:nil];
                } else {
                    [self.mm_drawerController
                     setCenterViewController:self.navHome
                     withFullCloseAnimation:YES
                     completion:nil];
                    self.currentController = @"HomeViewControllerID";
                }
                
                
            } else if (indexPath.row == 1) {
                if(self.navCollection == nil) {
                    CollectionViewController * collectionViewController = [[CollectionViewController alloc] init];
                    collectionViewController.requestURL = @{@"requestRouter":@"post/mycollection"};

                    self.navCollection = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
                }
                
                if ([self.currentController isEqual: @"CollectionViewControllerID"]) {
                    [self.mm_drawerController
                     setCenterViewController:self.navCollection
                     withCloseAnimation:YES
                     completion:nil];
                } else {
                    [self.mm_drawerController
                     setCenterViewController:self.navCollection
                     withFullCloseAnimation:YES
                     completion:nil];
                    self.currentController = @"CollectionViewControllerID";
                }
                
                
            } else if (indexPath.row == 2){ // row == 1
                if(self.navComment == nil) {
                   CommentViewController * commentViewController = [[CommentViewController alloc] init];
                   commentViewController.requestURL= @{@"requestRouter":@"post/mycomment"};
                    self.navComment = [[UINavigationController alloc] initWithRootViewController:commentViewController];
                }
                if ([self.currentController isEqual: @"CommentViewControllerID"]){
                    [self.mm_drawerController
                     setCenterViewController:self.navComment
                     withCloseAnimation:YES
                     completion:nil];
                } else {
                    [self.mm_drawerController
                     setCenterViewController:self.navComment
                     withFullCloseAnimation:YES
                     completion:nil];
                    self.currentController = @"CommentViewControllerID";
                }
            }
            
            break;

        }

            
        case MMDrawerSection2:
            if (indexPath.row == 0) {
                if(self.navFeedback == nil) {
                    UIViewController * feedbackViewController = [[FeedbackViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    self.navFeedback = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
                }
                
                if ([self.currentController isEqual: @"FeedbackViewControllerID"]) {
                    [self.mm_drawerController
                     setCenterViewController:self.navFeedback
                     withCloseAnimation:YES
                     completion:nil];
                } else {
                    [self.mm_drawerController
                     setCenterViewController:self.navFeedback
                     withFullCloseAnimation:YES
                     completion:nil];
                    self.currentController = @"FeedbackViewControllerID";
                }
                
                
            } else if (indexPath.row == 1){ // row == 1
                if(self.navSetting == nil) {
                    UIViewController * settingViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    self.navSetting = [[UINavigationController alloc] initWithRootViewController:settingViewController];
                }
                if ([self.currentController isEqual: @"SettingViewControllerID"]){
                    [self.mm_drawerController
                     setCenterViewController:self.navSetting
                     withCloseAnimation:YES
                     completion:nil];
                } else {
                    [self.mm_drawerController
                     setCenterViewController:self.navSetting
                     withFullCloseAnimation:YES
                     completion:nil];
                    self.currentController = @"SettingViewControllerID";
                }
            }

            break;
            
        default:
            break;
    }
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
