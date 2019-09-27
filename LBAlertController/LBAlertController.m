//
//  MBAlertController.m
//  mbp_purse
//
//  Created by 刘彬 on 16/7/15.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBAlertController.h"
#import "LBCustemPresentTransitions.h"

@implementation LBAlertActionButton
- (instancetype)initWithBounds:(CGRect)frame action:(void (^)(LBAlertActionButton * _Nonnull))action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.action = action;
        [self addTarget:self action:@selector(alertActionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)alertActionButtonAction{
    __weak typeof(self) weakSelf = self;
    self.action?self.action(weakSelf):NULL;
}

@end

@implementation LBAlertController

- (instancetype)initWithAlertTitle:(NSString *)title message:(NSString *)message
{
    self = [super init];
    if (self) {
        LBCustemPresentTransitions *transitions = [LBCustemPresentTransitions shareInstanse];
        transitions.contentMode = LBViewContentModeCenter;
        self.transitioningDelegate = transitions;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        _alertTitle = title;
        _alertMessage = message;
        
        _buttonArray = [[NSMutableArray alloc] init];
        
        _alertTitleLabel = [[UILabel alloc] init];
        _alertTitleLabel.font = [UIFont systemFontOfSize:15];
        _alertTitleLabel.text = title;
        _alertTitleLabel.numberOfLines = 0;
        _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        _alertMessageLabel = [[UILabel alloc] init];
        _alertMessageLabel.text = message;
        _alertMessageLabel.font = [UIFont systemFontOfSize:14];
        _alertMessageLabel.numberOfLines = 0;
        _alertMessageLabel.textAlignment = NSTextAlignmentCenter;
        _alertMessageLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}
-(void)loadView{
    [super loadView];
    self.view.layer.cornerRadius = 8;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.view.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-250)/2, 0, 250, 0);
    CGFloat alertTitleWidth = CGRectGetWidth(self.view.frame)-15*2;
    _alertTitleLabel.frame = CGRectMake((CGRectGetWidth(self.view.frame)-alertTitleWidth)/2, 15, alertTitleWidth, [_alertTitleLabel sizeThatFits:CGSizeMake(alertTitleWidth, MAXFLOAT)].height);
    [self.view addSubview:_alertTitleLabel];
    
    
    CGFloat alertMessageWidth = CGRectGetWidth(self.view.bounds)-25*2;
    _alertMessageLabel.frame = CGRectMake((CGRectGetWidth(self.view.frame)-alertMessageWidth)/2, CGRectGetMaxY(_alertTitleLabel.frame), alertMessageWidth, [_alertMessageLabel sizeThatFits:CGSizeMake(alertMessageWidth, CGFLOAT_MAX)].height+(_alertMessage.length?30:0));
    [self.view addSubview:_alertMessageLabel];
    
    _userView.frame = CGRectMake((CGRectGetWidth(self.view.frame)-CGRectGetWidth(_userView.frame))/2, CGRectGetMaxY(_alertMessageLabel.frame), CGRectGetWidth(_userView.frame), CGRectGetHeight(_userView.frame));
    [self.view addSubview:_userView];
    
    
    __block CGFloat widthSum = 0;
    [_buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull actionBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        widthSum += CGRectGetWidth(actionBtn.bounds);
    }];
    CGFloat horizontalSpace = (CGRectGetWidth(self.view.bounds)-widthSum)/(_buttonArray.count+1);
    typeof(self) __weak weakSelf = self;
    if (horizontalSpace < 0) {//button竖排模式
        __block CGFloat heightCurrentSum = 0;
        [_buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull actionBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            actionBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)-CGRectGetWidth(actionBtn.bounds))/2, CGRectGetMaxY(weakSelf.alertMessageLabel.frame)+CGRectGetHeight(weakSelf.userView.frame)+heightCurrentSum+idx*10, CGRectGetWidth(actionBtn.bounds), CGRectGetHeight(actionBtn.bounds));
            [self.view  addSubview:actionBtn];
            
            heightCurrentSum += CGRectGetHeight(actionBtn.bounds);
        }];
    }else{//button横排模式
        __block CGFloat widthCurrentSum = 0;
        [_buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull actionBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            actionBtn.frame = CGRectMake(widthCurrentSum+horizontalSpace*(idx+1), CGRectGetMaxY(weakSelf.alertMessageLabel.frame)+CGRectGetHeight(weakSelf.userView.frame), CGRectGetWidth(actionBtn.bounds), CGRectGetHeight(actionBtn.bounds));
            [self.view  addSubview:actionBtn];
            
            widthCurrentSum += CGRectGetWidth(actionBtn.bounds);
        }];
    }
    
    
    CGRect contentViewFrame = self.view.frame;
    contentViewFrame.size.height = CGRectGetMaxY((_buttonArray.count?_buttonArray.lastObject:(_userView?_userView:_alertMessageLabel)).frame);
    self.view.frame = contentViewFrame;
}

-(void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment{
    _messageTextAlignment = messageTextAlignment;
    _alertMessageLabel.textAlignment = messageTextAlignment;
}

- (void)setUserView:(UIView *)userView{
    _userView = userView;
    [self loadView];
}

-(void)setAlertTitle:(NSString *)alertTitle{
    _alertTitle = alertTitle;
    _alertTitleLabel.text = alertTitle;
    [self loadView];
}

-(void)setAlertMessage:(NSString *)alertMessage{
    _alertMessage = alertMessage;
    _alertMessageLabel.text = alertMessage;
    [self loadView];
}

-(void)addActionButton:(LBAlertActionButton *)actionButton{
    [_buttonArray addObject:actionButton];
    [self loadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
