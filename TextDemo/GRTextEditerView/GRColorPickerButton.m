//
//  GRColorPickerButton.m
//  TextDemo
//
//  Created by liangzhimy on 16/12/15.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRColorPickerButton.h"

static const CGFloat __GRAnimationDuration = .1f;
static const CGFloat __GRMinScale = .8;
static const CGFloat __GRNormalScale = 1.f;

@interface GRColorPickerButton ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) void (^clickBlock)(id sender);

@end

@implementation GRColorPickerButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.containerView.layer.cornerRadius = self.frame.size.width * .5; 
    self.containerView.layer.masksToBounds = TRUE;
    self.containerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.containerView.layer.borderWidth = 1.f;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.containerView addGestureRecognizer:tapGesture]; 
}

- (void)setButtonColor:(UIColor *)buttonColor {
    self.containerView.backgroundColor = buttonColor; 
}

- (UIColor *)buttonColor {
    return self.containerView.backgroundColor;
}

- (void)tapGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self __startAnimation];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self __endAnimation];
            if (self.clickBlock) {
                self.clickBlock(self);
            } 
        }
            break;
        default:
            [self __endAnimation];
            break;
    }
}

- (void)__startAnimation {
    CGFloat sx = __GRMinScale;
    CGFloat sy = __GRMinScale;
    [UIView animateWithDuration:__GRAnimationDuration animations:^{
        self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy);
    }];
}

- (void)__endAnimation {
    CGFloat sx = __GRNormalScale;
    CGFloat sy = __GRNormalScale;
    [UIView animateWithDuration:__GRAnimationDuration animations:^{
        self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy); 
    }];
}

- (void)addClickBlock:(void (^)(id sender))clickblock {
    self.clickBlock = clickblock;
}

@end
