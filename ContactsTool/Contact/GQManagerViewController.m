//
//  SettingViewController.m
//  Contact
//
//  Created by gap on 2018/5/8.
//  Copyright © 2018年 gq. All rights reserved.
//

#import "GQManagerViewController.h"
#import "ContactsObjc.h"
#import "GQContactModel.h"
#import "GQSortViewController.h"
#import "NoPhoneViewController.h"
#import "GQContactHeader.h"


@interface GQManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *sameNameArray;
@property (nonatomic, strong)NSMutableArray *samePhoneArray;
//@property (nonatomic, strong)NSMutableArray *noNameArray;
@property (nonatomic, strong)NSMutableArray *noPhoneArray;
@property (nonatomic, strong)NSArray *totalArray;
@property (nonatomic, strong)ContactsObjc *contactObject;
@end

@implementation GQManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"clean", nil);
    
    self.contactObject = [ContactsObjc shareInstance];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    __block NSMutableArray *allAddress = [NSMutableArray arrayWithCapacity:0];
    
    
//    [ContactsObjc allAddressBook:^(NSArray *contacts) {
//        allAddress = [[NSMutableArray alloc] initWithArray:contacts];
//    } authorizationFailure:^{
//        self.authTipView.hidden = NO;
//        return ;
//    }];
    
    NSArray *addressArray = self.contactObject.contactsArray;
    self.sameNameArray = [[[NSMutableArray alloc] init] mutableCopy];
    self.samePhoneArray = [[[NSMutableArray alloc] init] mutableCopy];
//    self.noNameArray = [[[NSMutableArray alloc] init] mutableCopy];
    self.noPhoneArray = [[NSMutableArray alloc] init];
    [self.contactObject.contactsArray enumerateObjectsUsingBlock:^(GQContactModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        if ([model.fullName isEqualToString:@"*无姓名"]) {
//            [self.noNameArray addObject:model];
//        }
        
        if (model.mobileArray.count == 0) {
            [self.noPhoneArray addObject:model];
        }
        
        __block NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        __block NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        __block BOOL isDup = NO;
        
        __block NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc] init];
        __block NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        
        [addressArray enumerateObjectsUsingBlock:^(GQContactModel *obj, NSUInteger index, BOOL * _Nonnull stop) {
            
            if (index == idx) {
                *stop = YES;
                return ;
            }
            
            for (NSString *phone in model.mobileArray) {
                if ([obj.mobileArray containsObject:phone]) {
                    [phoneArray addObject:obj];
                    [phoneArray addObject:model];
                    [phoneDic setObject:phoneArray forKey:@"data"];
                    [phoneDic setObject:phone forKey:@"key"];
                    [self.samePhoneArray addObject:phoneDic];
                }
            }
            
            if ([model.fullName isEqualToString:obj.fullName] && idx != index && idx > index && ![obj.fullName isEqualToString:@"*无姓名 "]) {
                [tmpArray addObject:obj];
                isDup = YES;
            }
            
        }];
        
        if (isDup) {
            [tmpArray addObject:model];
//            [dic setObject:tmpArray forKey:model.fullName];
            [dic setObject:model.fullName forKey:@"key"];
            [dic setObject:tmpArray forKey:@"data"];
            [self.sameNameArray addObject:dic];
        }
    
    }];
    self.totalArray = @[self.sameNameArray,self.samePhoneArray,self.noPhoneArray];
    
    dispatch_main_async_safe(^{
        [self.tableView reloadData];
    });

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.sectionIndexColor = [UIColor grayColor];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)switchChanged:(UISwitch *)sender {
    BOOL value = sender.on;
    NSLog(@"value switch :%@",value ? @"YES":@"NO");
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kPrivateContact];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = NSLocalizedString(@"duplicateName", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.sameNameArray.count];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"duplicatePhone", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.samePhoneArray.count];
            
        } else {
            
            cell.textLabel.text = NSLocalizedString(@"noPhoneNumber", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.noPhoneArray.count];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else {
        
        static NSString* cellIdentifier = @"switchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"HELLO";
        UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        cell.accessoryView = switchBtn;
        switchBtn.on = [[NSUserDefaults standardUserDefaults] boolForKey:kPrivateContact];
        [switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3: 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSArray *array = self.totalArray[indexPath.row];
        if (array.count == 0) {
           
            [SVProgressHUD way_dismissThenShowInfoWithStatus:NSLocalizedString(@"noContactToClean", @"")];
            
        } else {
            
            if (indexPath.row == 2) {
                NoPhoneViewController *vc = [[NoPhoneViewController alloc] initWithData:self.noPhoneArray];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                NSArray *typeArray = @[@"0",@"1",@"2"];
                GQSortViewController *viewController = [[GQSortViewController alloc] initWithType:[typeArray[indexPath.row] integerValue] data:self.totalArray[indexPath.row]];
                viewController.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
