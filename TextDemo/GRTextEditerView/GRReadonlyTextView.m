//
//  GRReadonlyTextView.m
//  TextDemo
//
//  Created by liangzhimy on 16/12/14.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRReadonlyTextView.h"

static const CGFloat __GRWidthDelta = 50.f;
static const CGFloat __GRHeightDelta = 50.f;
static const CGFloat __GRHalf = .5;

@interface GRReadonlyTextView () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *touchButton;
@end

@implementation GRReadonlyTextView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self __config]; 
    }
    return self; 
}

- (void)__config {
    [self __addGestureRecognizerToView:self];
    self.textView.text = @""; 
    self.textView.editable = FALSE;
    self.textView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor]; 
} 

- (void)dealloc {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.bounds;
    self.touchButton.frame = self.bounds;
}

#pragma mark - method 
- (void)setText:(NSString *)text {
    _text = text;
    _textView.text = text; 
}

- (void)setColor:(UIColor *)color {
    self.textView.textColor = color; 
}

- (UIColor *)color {
    return self.textView.textColor; 
} 

#pragma mark - method
- (IBAction)buttonPressed:(id)sender {
    if (self.delegate) {
        [self.delegate readonlyTextView:self touchEnd:nil]; 
    }
}

#pragma mark - gesture
- (void)__addGestureRecognizerToView:(UIView *)view {
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    rotationGestureRecognizer.delegate = self;
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    pinchGestureRecognizer.delegate = self;
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    panGestureRecognizer.delegate = self; 
    [view addGestureRecognizer:panGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
} 

- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -__GRHalf * __GRWidthDelta, -__GRHalf * __GRHeightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
