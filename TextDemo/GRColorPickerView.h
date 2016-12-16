//
//  GRColorPickerView.h
//  TextDemo
//
//  Created by liangzhimy on 16/12/15.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRColorCollectionViewLayout : UICollectionViewFlowLayout

@end


@protocol GRColorPickerViewDelegate <NSObject>

- (void)colorPickerView:(id)sender pickerColor:(UIColor *)color; 

@end

@interface GRColorPickerView : UIView

@property (weak, nonatomic) id<GRColorPickerViewDelegate> delegate;

- (void)bindWithColors:(NSArray <UIColor *>*)colors;

@end
