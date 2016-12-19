//
//  GRTextEditerView.h
//  TextDemo
//
//  Created by liangzhimy on 16/12/14.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRTextEditerView : UIView

@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) UIColor *color; 

- (void)config;

@end
