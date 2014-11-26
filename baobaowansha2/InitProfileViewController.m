//
//  InitProfileViewController.m
//  baobaowansha2
//
//  Created by 刘昕 on 14/11/24.
//  Copyright (c) 2014年 刘昕. All rights reserved.
//

#import "InitProfileViewController.h"
#import "PickerView.h"
#import "HomeViewController.h"
#import "SlideViewController.h"

@interface InitProfileViewController ()

@property(nonatomic,retain)NSDictionary *userInfo;
@property(nonatomic,retain)NSDate *userBabyBirthday;
//存储tableViewCell数据的key
@property(nonatomic,retain)NSArray *userTableViewCellKeys;
@property(nonatomic,retain)NSMutableArray *userTableViewCellValues;

@property(nonatomic,strong)TableView *tableView;
@property(nonatomic,strong)PickerView *datePicker;

@end

@implementation InitProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.userTableViewCellKeys = @[@"宝宝性别",@"您的性别",@"宝宝生日"];
    self.userTableViewCellValues =[[NSMutableArray alloc]initWithArray:@[@"",@"",@""]];
    
    self.view.backgroundColor = [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0f/255.0f green:86.0f/255.0f blue:170.0f/255.0f alpha:1.0f];    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], UITextAttributeTextColor, nil];
    self.title = @"请输入您的基本信息";
    self.tableView = [[TableView alloc]initWithFrame:CGRectMake(0.0f, 104.0f, self.view.bounds.size.width, self.view.frame.size.height - 240.0f)];
    self.tableView.tableView.delegate = self;
    self.tableView.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *ID = @"prototype";
    
    //创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    [cell setSelectionStyle:(UITableViewCellSelectionStyleGray)];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    cell.textLabel.text = [self.userTableViewCellKeys objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =[self.userTableViewCellValues objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.2f];
    switch (indexPath.row) {
        case 0:
            [self setBabySex];
            break;
        case 1:
            [self setUserSex];
            break;
        case 2:
            [self setUserBabyBirthday];
            break;
        default:
            break;
    }
    
}
- (void)deselect

{
    [self.tableView.tableView deselectRowAtIndexPath:[self.tableView.tableView  indexPathForSelectedRow] animated:YES];
}

#pragma mark - 三个按钮的动作设置
-(void)setBabySex{
    [self datePickerCanceled];
    UIActionSheet *setBabySexActionSheet = [[UIActionSheet alloc]initWithTitle:@"宝宝性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男宝宝",@"女宝宝", nil];
    setBabySexActionSheet.tag = 1;
    [setBabySexActionSheet showInView:self.view];
}

-(void)setUserSex{
    [self datePickerCanceled];
    UIActionSheet *setUserSexActionSheet = [[UIActionSheet alloc]initWithTitle:@"您的角色" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我是爸爸",@"我是妈妈", nil];
    setUserSexActionSheet.tag = 2;
    [setUserSexActionSheet showInView:self.view];
}

-(void)setUserBabyBirthday{
    self.datePicker = [[PickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 240.0f, self.view.bounds.size.width, 240.0f)];
    [self.view addSubview:self.datePicker];
    
}


#pragma mark - 按钮动作的delegate

//ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //选择宝宝性别的delegate
    //1是男，2是女
    if(actionSheet.tag == 1){
        if (buttonIndex == 0) {
            [self.userTableViewCellValues replaceObjectAtIndex:0 withObject:@"男宝宝"];
        }else{
            [self.userTableViewCellValues replaceObjectAtIndex:0 withObject:@"女宝宝"];
        }
    }else if(actionSheet.tag == 2){
        if (buttonIndex == 0) {
            [self.userTableViewCellValues replaceObjectAtIndex:1 withObject:@"我是爸爸"];
        }else{
            [self.userTableViewCellValues replaceObjectAtIndex:1 withObject:@"我是妈妈"];
        }
    }
    [self.tableView.tableView reloadData];
    
}

//日期选择
-(void)dateSelected{
    if(self.datePicker){
        NSDate *selected = [self.datePicker.datePicker date];
        self.userBabyBirthday = selected;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *selectedDate =[formatter stringFromDate:selected];
        
        [self.userTableViewCellValues replaceObjectAtIndex:2 withObject:selectedDate];
        [self.tableView.tableView reloadData];
        [self.datePicker removeFromSuperview];
    }
}

-(void)datePickerCanceled{
    if(self.datePicker){
        [self.datePicker removeFromSuperview];
    }
}



#pragma mark - 完成设置后，把信息保存到本地数据，同时将信息发送到服务器

-(void)infoComplete{
    //三个字段都填写完成
    if(![self.userTableViewCellValues[0]  isEqual: @""]&![self.userTableViewCellValues[1]  isEqual: @""]&![self.userTableViewCellValues[2]  isEqual: @""]){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingString:@"UserInfo.plist"];
        
        self.userInfo = @{@"userBabySex":self.userTableViewCellValues[0] ,@"userSex":self.userTableViewCellValues[1],@"userBabyBirthday":self.userBabyBirthday};
        [self.userInfo writeToFile:filePath atomically:YES];
        
        //创建左侧菜单
        LeftViewController *leftVC = [[LeftViewController alloc] init];
        
        //创建带navigationController的homeViewController
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:homeVC];
        
        //创建滑动页面
        SlideViewController *slideVC = [[SlideViewController alloc] initWithLeftViewController:leftVC navigationController:navigation];
        
        [self presentViewController:slideVC animated:YES completion:^{
            [self.view removeFromSuperview];
        }];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
