//
//  GRReadonlyTextView.h
//  TextDemo
//
//  Created by liangzhimy on 16/12/14.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRReadonlyTextView; 

@protocol GRReadonlyTextViewDelegate <NSObject>

- (void)readonlyTextView:(GRReadonlyTextView *)readonlyTextView touchEnd:(id)touch; 

@end

@interface GRReadonlyTextView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) id<GRReadonlyTextViewDelegate> delegate;
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *color; 

@end
