# LBAlertController
```objc
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
userView.text = @"这里可以添加userView";
userView.backgroundColor = [UIColor cyanColor];
alertC.userView = userView;
[self presentViewController:alertC animated:YES completion:nil];
```
![](https://github.com/A1129434577/LBAlertController/blob/master/LBAlertController.png?raw=true)
