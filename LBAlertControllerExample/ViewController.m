//
//  ViewController.m
//  LBAlertControllerExample
//
//  Created by 刘彬 on 2019/9/27.
//  Copyright © 2019 刘彬. All rights reserved.
//

#import "ViewController.h"
#import "LBAlertController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showAlert];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showAlert];
}

-(void)showAlert{
    LBAlertController *alertC = [[LBAlertController alloc] initWithAlertTitle:@"提示" message:@"这是一个自定义弹窗"];
    
    
    typeof(self) __weak weakSelf = self;
    LBAlertActionButton *actionCancelBtn = [[LBAlertActionButton alloc] initWithBounds:CGRectMake(0, 0, CGRectGetWidth(alertC.view.frame)/2, 50) action:^(LBAlertActionButton *sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [actionCancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    actionCancelBtn.backgroundColor = [UIColor orangeColor];
    actionCancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actionCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alertC addActionButton:actionCancelBtn];
    
    
    LBAlertActionButton *actionBtn = [[LBAlertActionButton alloc] initWithBounds:CGRectMake(0, 0, CGRectGetWidth(actionCancelBtn.bounds), CGRectGetHeight(actionCancelBtn.bounds)) action:^(LBAlertActionButton *sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [actionBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [actionBtn setTitle:@"确定" forState:UIControlStateNormal];
    [alertC addActionButton:actionBtn];
    
    UILabel *userView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    userView.textAlignment = NSTextAlignmentCenter;
    userView.text = @"你可以在这里做任何事情";
    userView.backgroundColor = [UIColor cyanColor];
    alertC.userView = userView;
    [self presentViewController:alertC animated:YES completion:nil];

}

@end
