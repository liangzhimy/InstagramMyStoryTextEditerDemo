//
//  GRColorPickerButton.h
//  TextDemo
//
//  Created by liangzhimy on 16/12/15.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRColorPickerButton : UIView

@property (strong, nonatomic) UIColor *buttonColor;

- (void)addClickBlock:(void (^)(id sender))clickblock;

@end
