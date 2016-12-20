//
//  GRTextEditerView.h
//  TextDemo
//
//  Created by liangzhimy on 16/12/14.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRTextEditerView;

@protocol GRTextEditerViewDelegate <NSObject>

- (void)textEditer:(GRTextEditerView *)editerView changedEditing:(BOOL)isEditing;

@end

@interface GRTextEditerView : UIView

@property (assign, nonatomic) CGFloat fixTopHeight;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) UIColor *color;
@property (weak, nonatomic) id<GRTextEditerViewDelegate> delegate;

- (void)config;

@end
