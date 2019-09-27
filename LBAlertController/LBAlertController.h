//
//  MBAlertController.h
//  mbp_purse
//
//  Created by 刘彬 on 16/7/15.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAlertActionButton : UIButton
@property (nonatomic,copy,nullable)void (^action)(LBAlertActionButton *_Nonnull sender);
- (instancetype _Nonnull)initWithBounds:(CGRect)frame action:(void (^_Nullable)(LBAlertActionButton *_Nonnull sender))action;
@end

@interface LBAlertController : UIViewController
@property (nonatomic,strong,readonly,nonnull)UILabel *alertTitleLabel;
@property (nonatomic,strong,readonly,nonnull)UILabel *alertMessageLabel;
@property (nonatomic,assign)NSTextAlignment messageTextAlignment;
@property (nonatomic,strong,nullable)UIView *userView;
@property (nonatomic,copy,nullable) NSString *alertTitle;
@property (nonatomic,copy,nullable) NSString *alertMessage;
@property (nonatomic,strong,readonly,nullable)NSMutableArray<LBAlertActionButton *> *buttonArray;

- (nonnull instancetype)initWithAlertTitle:(nullable NSString*)title message:(nullable NSString *)message;

-(void)addActionButton:(LBAlertActionButton *_Nonnull)actionButton;
@end
