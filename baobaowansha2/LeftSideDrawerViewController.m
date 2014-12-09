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
    
    [self setHeaderImage:@"headerImage.jpg"];
    [self setHeaderWords:@"15个月"];
    
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:self.headerImage];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = self.headerWords;
        //label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
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
                    UIViewController * collectionViewController = [[CollectionViewController alloc] init];
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
                    UIViewController * commentViewController = [[CommentViewController alloc] init];
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
