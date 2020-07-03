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
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) UIEdgeInsets titleLabelInset;
@property (nonatomic, assign) UIEdgeInsets messageLabelInset;
@property (nonatomic,strong,readonly,nonnull)UILabel *alertTitleLabel;
@property (nonatomic,strong,readonly,nonnull)UITextView *alertMessageTextView;
@property (nonatomic,strong,nullable)UIView *userView;
@property (nonatomic,copy,nullable) id alertTitle;//NSString or NSAttributedString
@property (nonatomic,copy,nullable) id alertMessage;//NSString or NSAttributedString
@property (nonatomic,strong,readonly,nullable)NSMutableArray<LBAlertActionButton *> *buttonArray;

- (nonnull instancetype)initWithAlertTitle:(nullable id)title message:(nullable id)message;

-(void)addActionButton:(LBAlertActionButton *_Nonnull)actionButton;
@end
