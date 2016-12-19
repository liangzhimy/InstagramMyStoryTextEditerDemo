//
//  GRColorPickerCollectionViewCell.m
//  TextDemo
//
//  Created by liangzhimy on 16/12/15.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRColorPickerCollectionViewCell.h"

static const CGFloat __GRAnimationDuration = .1f;
static const CGFloat __GRMinScale = .8;
static const CGFloat __GRNormalScale = 1.f;
static const CGFloat __GRHalf = .5f;
static const CGFloat __GRColorBorderWidth = 1.f;

@interface GRColorPickerCollectionViewCell ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorContainerView;
@property (strong, nonatomic) void (^clickBlock)(id sender);

@end

@implementation GRColorPickerCollectionViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.colorContainerView.layer.cornerRadius = self.frame.size.width * __GRHalf;
    self.colorContainerView.layer.masksToBounds = TRUE;
    self.colorContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.colorContainerView.layer.borderWidth = __GRColorBorderWidth;
    
    UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.minimumPressDuration = 0.f;
    tapGesture.delegate = self;
    [self.colorContainerView addGestureRecognizer:tapGesture];
}

- (void)setButtonColor:(UIColor *)buttonColor {
    self.colorContainerView.backgroundColor = buttonColor;
}

- (UIColor *)buttonColor {
    return self.colorContainerView.backgroundColor;
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
        self.colorContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy);
    }];
}

- (void)__endAnimation {
    CGFloat sx = __GRNormalScale;
    CGFloat sy = __GRNormalScale;
    [UIView animateWithDuration:__GRAnimationDuration animations:^{
        self.colorContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, sx, sy);
    }];
}

- (void)addClickBlock:(void (^)(id sender))clickblock {
    self.clickBlock = clickblock;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
} 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        return YES; 
    }
    return NO; 
} 

@end
