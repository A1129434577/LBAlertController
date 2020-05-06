//
//  MBAlertController.m
//  mbp_purse
//
//  Created by 刘彬 on 16/7/15.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBAlertController.h"
#import "LBPresentTransitions.h"

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

@interface LBAlertController ()
{
    LBPresentTransitions *_transitions;
}
@end
@implementation LBAlertController

- (instancetype)initWithAlertTitle:(NSString *)title message:(NSString *)message
{
    self = [super init];
    if (self) {
        _transitions = [LBPresentTransitions new];
        _transitions.coverViewType = LBTransitionsCoverViewAlpha0_5;
        _transitions.contentMode = LBTransitionsContentModeCenter;
        self.transitioningDelegate = _transitions;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        _titleLabelInset = UIEdgeInsetsMake(15, 25, 15, 25);
        _messageLabelInset = UIEdgeInsetsMake(0, 25, 25, 25);
        
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
    
    
    self.view.frame = CGRectMake((self.viewWidth==0)?50:((CGRectGetWidth(self.view.bounds)-self.viewWidth)/2), 0, (self.viewWidth==0)?(CGRectGetWidth(self.view.bounds)-50*2):self.viewWidth, 0);
    
    CGFloat alertTitleWidth = CGRectGetWidth(self.view.frame)-_titleLabelInset.left-_titleLabelInset.right;
    CGFloat alertTitleHeight = [_alertTitleLabel sizeThatFits:CGSizeMake(alertTitleWidth, MAXFLOAT)].height;
    if (alertTitleHeight == 0) {
        _titleLabelInset.top = 0;
        _titleLabelInset.bottom = 0;
    }
    _alertTitleLabel.frame = CGRectMake(_titleLabelInset.left, _titleLabelInset.top, alertTitleWidth, alertTitleHeight);
    [self.view addSubview:_alertTitleLabel];
    
    
    CGFloat alertMessageWidth = CGRectGetWidth(self.view.frame)-_messageLabelInset.left-_messageLabelInset.right;
    CGFloat alertMessageHeight = [_alertMessageLabel sizeThatFits:CGSizeMake(alertMessageWidth, CGFLOAT_MAX)].height;
    if (alertMessageHeight == 0) {
        _messageLabelInset.top = 0;
        _messageLabelInset.bottom = 0;
    }
    _alertMessageLabel.frame = CGRectMake(_messageLabelInset.left, CGRectGetMaxY(_alertTitleLabel.frame)+_titleLabelInset.bottom+_messageLabelInset.top, alertMessageWidth, alertMessageHeight);
    [self.view addSubview:_alertMessageLabel];
    
    _userView.frame = CGRectMake((CGRectGetWidth(self.view.frame)-CGRectGetWidth(_userView.frame))/2, CGRectGetMaxY(_alertMessageLabel.frame)+_messageLabelInset.bottom, CGRectGetWidth(_userView.frame), CGRectGetHeight(_userView.frame));
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
            actionBtn.frame = CGRectMake((CGRectGetWidth(weakSelf.view.bounds)-CGRectGetWidth(actionBtn.bounds))/2, CGRectGetMaxY(weakSelf.alertMessageLabel.frame)+weakSelf.messageLabelInset.bottom+CGRectGetHeight(weakSelf.userView.frame)+heightCurrentSum+idx*10, CGRectGetWidth(actionBtn.bounds), CGRectGetHeight(actionBtn.bounds));
            [weakSelf.view  addSubview:actionBtn];
            
            heightCurrentSum += CGRectGetHeight(actionBtn.bounds);
        }];
    }else{//button横排模式
        __block CGFloat widthCurrentSum = 0;
        [_buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull actionBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            actionBtn.frame = CGRectMake(widthCurrentSum+horizontalSpace*(idx+1), CGRectGetMaxY(weakSelf.alertMessageLabel.frame)+weakSelf.messageLabelInset.bottom+CGRectGetHeight(weakSelf.userView.frame), CGRectGetWidth(actionBtn.bounds), CGRectGetHeight(actionBtn.bounds));
            [weakSelf.view  addSubview:actionBtn];
            
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
