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

- (instancetype)initWithAlertTitle:(id)title message:(id)message{
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
        _alertTitleLabel.font = [UIFont systemFontOfSize:17];
        _alertTitleLabel.numberOfLines = 0;
        _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        if ([title isKindOfClass:NSString.self]) {
            _alertTitleLabel.text = title;
        }else if ([title isKindOfClass:NSAttributedString.self]){
            _alertTitleLabel.attributedText = title;
        }
        
        _alertMessageTextView = [[UITextView alloc] init];
        _alertMessageTextView.scrollEnabled = NO;
        _alertMessageTextView.editable = NO;
        
        if ([message isKindOfClass:NSString.self]) {
            _alertMessageTextView.font = [UIFont systemFontOfSize:_alertTitleLabel.font.pointSize-1];
            _alertMessageTextView.textColor = [UIColor darkGrayColor];
            _alertMessageTextView.textAlignment = NSTextAlignmentCenter;
            
            _alertMessageTextView.text = message;
        }else if ([message isKindOfClass:NSAttributedString.self]){
            NSAttributedString *messageAtt = message;
            _alertMessageTextView.attributedText = messageAtt;
            
            //如果富文本没有这几个主要设置，那么给其设置默认值
            __block BOOL messageAttHaveFont = NO;
            __block BOOL messageAttHaveColor = NO;
            __block BOOL messageAttHaveParagraphStyle = NO;
            [messageAtt enumerateAttributesInRange:NSMakeRange(0, messageAtt.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                if (messageAttHaveFont == NO) {
                    if (attrs[NSFontAttributeName]) {
                        messageAttHaveFont = YES;
                    }
                }
                if (messageAttHaveColor == NO) {
                    if (attrs[NSForegroundColorAttributeName]) {
                        messageAttHaveColor = YES;
                    }
                }
                if (messageAttHaveParagraphStyle == NO) {
                    if (attrs[NSParagraphStyleAttributeName]) {
                        messageAttHaveParagraphStyle = YES;
                    }
                }
                
            }];
            
            if (messageAttHaveFont == NO) {
                _alertMessageTextView.font = [UIFont systemFontOfSize:_alertTitleLabel.font.pointSize-1];
            }
            if (messageAttHaveColor == NO) {
                _alertMessageTextView.textColor = [UIColor darkGrayColor];
            }
            if (messageAttHaveParagraphStyle == NO) {
                _alertMessageTextView.textAlignment = NSTextAlignmentCenter;
            }
        }
        
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
        if (_messageLabelInset.top == 0) {
            _messageLabelInset.top = _messageLabelInset.bottom;
        }
    }
    _alertTitleLabel.frame = CGRectMake(_titleLabelInset.left, _titleLabelInset.top, alertTitleWidth, alertTitleHeight);
    [self.view addSubview:_alertTitleLabel];
    
    
    CGFloat alertMessageWidth = CGRectGetWidth(self.view.frame)-_messageLabelInset.left-_messageLabelInset.right;
    CGFloat alertMessageHeight = [_alertMessageTextView sizeThatFits:CGSizeMake(alertMessageWidth, CGFLOAT_MAX)].height;
    if ([self.alertMessage length] == 0) {//UITextView当text未空的时候算出来的高度并不为0，需要手动处理
        alertMessageHeight = 0;
    }
    if (alertMessageHeight == 0) {
        _messageLabelInset.top = 0;
        _messageLabelInset.bottom = 0;
    }
    _alertMessageTextView.frame = CGRectMake(_messageLabelInset.left, CGRectGetMaxY(_alertTitleLabel.frame)+_titleLabelInset.bottom+_messageLabelInset.top, alertMessageWidth, alertMessageHeight);
    [self.view addSubview:_alertMessageTextView];
    
    _userView.frame = CGRectMake((CGRectGetWidth(self.view.frame)-CGRectGetWidth(_userView.frame))/2, CGRectGetMaxY(_alertMessageTextView.frame)+_messageLabelInset.bottom, CGRectGetWidth(_userView.frame), CGRectGetHeight(_userView.frame));
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
            actionBtn.frame = CGRectMake((CGRectGetWidth(weakSelf.view.bounds)-CGRectGetWidth(actionBtn.bounds))/2, CGRectGetMaxY(weakSelf.alertMessageTextView.frame)+weakSelf.messageLabelInset.bottom+CGRectGetHeight(weakSelf.userView.frame)+heightCurrentSum+idx*10, CGRectGetWidth(actionBtn.bounds), CGRectGetHeight(actionBtn.bounds));
            [weakSelf.view  addSubview:actionBtn];
            
            heightCurrentSum += CGRectGetHeight(actionBtn.bounds);
        }];
    }else{//button横排模式
        __block CGFloat widthCurrentSum = 0;
        [_buttonArray enumerateObjectsUsingBlock:^(LBAlertActionButton * _Nonnull actionBtn, NSUInteger idx, BOOL * _Nonnull stop) {
            actionBtn.frame = CGRectMake(widthCurrentSum+horizontalSpace*(idx+1), CGRectGetMaxY(weakSelf.alertMessageTextView.frame)+weakSelf.messageLabelInset.bottom+CGRectGetHeight(weakSelf.userView.frame), CGRectGetWidth(actionBtn.bounds), CGRectGetHeight(actionBtn.bounds));
            [weakSelf.view  addSubview:actionBtn];
            
            widthCurrentSum += CGRectGetWidth(actionBtn.bounds);
        }];
    }
    
    CGRect contentViewFrame = self.view.frame;
    contentViewFrame.size.height = CGRectGetMaxY((_buttonArray.count?_buttonArray.lastObject:(_userView?_userView:_alertMessageTextView)).frame);
    self.view.frame = contentViewFrame;
}

- (void)setUserView:(UIView *)userView{
    _userView = userView;
    [self loadView];
}

-(void)setAlertTitle:(id)alertTitle{
    _alertTitle = alertTitle;
    if ([alertTitle isKindOfClass:NSString.self]) {
        _alertTitleLabel.text = alertTitle;
    }else if ([alertTitle isKindOfClass:NSAttributedString.self]){
        _alertTitleLabel.attributedText = alertTitle;
    }
    
    [self loadView];
}

-(void)setAlertMessage:(id)alertMessage{
    _alertMessage = alertMessage;
    if ([alertMessage isKindOfClass:NSString.self]) {
        _alertMessageTextView.text = alertMessage;
    }else if ([alertMessage isKindOfClass:NSAttributedString.self]){
        _alertMessageTextView.attributedText = alertMessage;
    }
    
    [self loadView];
}

-(void)addActionButton:(LBAlertActionButton *)actionButton{
    [_buttonArray addObject:actionButton];
    [self loadView];
}

@end
