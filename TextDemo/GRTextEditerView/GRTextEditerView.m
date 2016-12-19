//
//  GRTextEditerView.m
//  TextDemo
//
//  Created by liangzhimy on 16/12/14.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRTextEditerView.h"
#import "GRReadonlyTextView.h"

static const CGFloat __GRYPercent = .40;
static const CGFloat __GRTextViewHeight = 43;
static const CGFloat __GRAnimationDuration = .2;
static const CGFloat __GRMinTouchWidth = 50;
static const CGFloat __GRMinTouchHeight = 50;
static const CGFloat __GREditFinishButtonAlpha = .5f;
static const CGFloat __GRHalf = .5f;

@interface GRTextEditerView () <GRReadonlyTextViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *editFinishButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) GRReadonlyTextView *readonlyTextView;

@end

@implementation GRTextEditerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.textView.backgroundColor = [UIColor clearColor]; 
    self.isEditing = TRUE;
}

- (void)config {
    CGFloat yOffset = self.frame.size.height * __GRYPercent;
    [self layoutIfNeeded];
    self.textView.frame = CGRectMake(0, yOffset, self.frame.size.width, __GRTextViewHeight);
    self.textView.scrollEnabled = FALSE;
    self.textView.delegate = self;
    self.textView.textColor = [UIColor blackColor];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.textView addGestureRecognizer:panGesture];
    self.readonlyTextView.color = [UIColor blackColor];
    
    [self.containerView addSubview:self.readonlyTextView];
    self.readonlyTextView.frame = self.textView.frame;
    self.readonlyTextView.delegate = self;
    [self.containerView layoutIfNeeded];
    [self.readonlyTextView layoutIfNeeded];
    [self.readonlyTextView layoutSubviews];
    
    self.isEditing = TRUE;
}

- (void)readonlyTextViewTapGesture:(id)sender {
    self.isEditing = TRUE;
}

- (void)__changeReadonlyViewCenterIfMoveOutside {
    CGRect intersectionRect = CGRectIntersection(self.frame, self.readonlyTextView.frame);
    if (intersectionRect.size.width < __GRMinTouchWidth &&
        intersectionRect.size.height < __GRMinTouchHeight) {
        CGFloat centerX = self.readonlyTextView.center.x;
        CGFloat centerY = self.readonlyTextView.center.y;
        
        if (centerX > self.frame.size.width) {
            centerX = self.frame.size.width - self.readonlyTextView.frame.size.width * __GRHalf;
        } else if (centerX < 0) {
            centerX = self.readonlyTextView.frame.size.width * __GRHalf;
        }
        
        if (centerY > self.frame.size.height) {
            centerY = self.frame.size.height - self.readonlyTextView.frame.size.height * __GRHalf;
        } else if (centerY < 0) {
            centerY = self.readonlyTextView.frame.size.height * __GRHalf;
        }
        
        self.readonlyTextView.center = CGPointMake(centerX, centerY);
    }
}

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    
    if (isEditing) {
        self.editFinishButton.enabled = TRUE;
        self.readonlyTextView.hidden = TRUE;
        self.editFinishButton.hidden = FALSE;
        [self.textView becomeFirstResponder];
       
        [self __becomeEditingAnimationWithCompletion:^{
            self.textView.hidden = FALSE;
        }];
    } else {
        if (self.textView.text.length == 0) {
            self.readonlyTextView.frame = self.textView.frame;
            self.readonlyTextView.transform = self.textView.transform;
        }
        
        [self.textView endEditing:YES];
        [self endEditing:YES];
        
        self.editFinishButton.enabled = TRUE;
        
        self.textView.hidden = TRUE;
        self.readonlyTextView.text = self.textView.text;
        self.readonlyTextView.bounds = self.textView.bounds;
        [self.readonlyTextView layoutIfNeeded];
        [self.readonlyTextView layoutSubviews];
        
        [self __changeReadonlyViewCenterIfMoveOutside];
        [self __becomeReadonlyAnimationWithCompletion:^{
            self.readonlyTextView.hidden = FALSE;
        }];
    }
}

- (void)__disableEditWithoutChangeFrame {
    _isEditing = FALSE; 
    self.editFinishButton.enabled = FALSE;
    self.editFinishButton.hidden = TRUE;
    self.textView.hidden = TRUE;
    self.readonlyTextView.text = self.textView.text;
    self.readonlyTextView.bounds = self.textView.bounds;
    self.readonlyTextView.hidden = FALSE;
    [self.textView endEditing:YES]; 
    [self endEditing:YES]; 
}

- (void)__becomeEditingAnimationWithCompletion:(void (^)())completion {
    self.editFinishButton.alpha = 0.f;
    
    CGFloat radians = atan2f(self.textView.transform.b, self.readonlyTextView.transform.a);
    CGFloat xScale = self.textView.transform.a;
    CGFloat yScale = self.textView.transform.d;
    
    UIView *view = [self.readonlyTextView.textView snapshotViewAfterScreenUpdates:FALSE];
    if (view) {
        view.center = self.readonlyTextView.center;
        view.transform = self.readonlyTextView.transform;
        [self.containerView addSubview:view];
    } 
    
    [UIView animateWithDuration:__GRAnimationDuration animations:^{
        if (view) {
            view.transform = CGAffineTransformMakeRotation(radians);
            view.center = self.textView.center;
            view.transform = CGAffineTransformScale(view.transform, xScale, yScale);
        }
        self.editFinishButton.alpha = __GREditFinishButtonAlpha;
        self.editFinishButton.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        if (!finished) {
            return;
        }
        
        if (view) {
        [view removeFromSuperview];
        }
        
        if (completion) {
            completion();
        } 
    }];
} 

- (CGFloat)__xscale:(CGAffineTransform)transform {
    CGAffineTransform t = transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat)__yscale:(CGAffineTransform)transform {
    CGAffineTransform t = transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (void)__becomeReadonlyAnimationWithCompletion:(void (^)())completion {
    CGFloat radians = atan2f(self.readonlyTextView.transform.b, self.readonlyTextView.transform.a);
    CGFloat xScale = self.readonlyTextView.transform.a;
    CGFloat yScale = self.readonlyTextView.transform.d;
    
    xScale = [self __xscale:self.readonlyTextView.transform];
    yScale = [self __yscale:self.readonlyTextView.transform]; 
    
    UIView *view = [self.textView snapshotViewAfterScreenUpdates:FALSE];
    if (view) {
        view.frame = self.textView.frame;
        [self.textView.superview addSubview:view];
    }
    
    self.textView.hidden = TRUE;
    
    [UIView animateWithDuration:__GRAnimationDuration animations:^{
        if (view) {
            view.transform = CGAffineTransformMakeRotation(radians);
            view.center = self.readonlyTextView.center;
            view.transform = CGAffineTransformScale(view.transform, xScale, yScale);
            self.editFinishButton.backgroundColor = [UIColor clearColor];
        }
    } completion:^(BOOL finished) {
        if (!finished) {
            return;
        } 
        
        if (view) {
            [view removeFromSuperview];
        }
        
        if (completion) {
            completion();
        }
    }];
} 

- (IBAction)editFinishButtonPressed:(id)sender {
    if (self.isEditing) {
        self.isEditing = FALSE;
        [self endEditing:YES];
        [self.textView endEditing:YES];
    } else {
        self.isEditing = TRUE;
        [self.textView becomeFirstResponder];
    } 
}

#pragma mark - property
- (void)setColor:(UIColor *)color {
    self.textView.textColor = color;
    self.readonlyTextView.color = color; 
}

- (UIColor *)color {
    return self.readonlyTextView.color; 
}

#pragma mark - lazy property
- (GRReadonlyTextView *)readonlyTextView {
    if (!_readonlyTextView) {
        NSArray *array = [[NSBundle bundleForClass:[GRReadonlyTextView class]] loadNibNamed:@"GRReadonlyTextView" owner:nil options:nil];
        _readonlyTextView = array.lastObject;
    }
    return _readonlyTextView;
}

#pragma mark - GRReadonlyTextViewDelegate
- (void)readonlyTextView:(GRReadonlyTextView *)readonlyTextView touchEnd:(id)touch {
    self.isEditing = TRUE;
    [self.textView becomeFirstResponder];
}

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGFloat fixedHeight = textView.frame.size.height;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    CGFloat offsetY = newFrame.size.height - fixedHeight;
    textView.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y - offsetY, newFrame.size.width, newFrame.size.height);
}

#pragma mark - Gesture 

- (void)panGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self.textView.text.length == 0) {
        return;
    }
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: { 
            if (self.isEditing) {
                [self __disableEditWithoutChangeFrame];
            }
            
            self.readonlyTextView.text = self.textView.text;
            self.readonlyTextView.transform = CGAffineTransformIdentity;
            self.readonlyTextView.center = self.textView.center;
            
            CGPoint translation = [panGestureRecognizer translationInView:self];
            [self.readonlyTextView setCenter:(CGPoint){self.readonlyTextView.center.x + translation.x, self.readonlyTextView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:self];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGestureRecognizer translationInView:self];
            [self.readonlyTextView setCenter:(CGPoint){self.readonlyTextView.center.x + translation.x, self.readonlyTextView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:self];
        }
            break;
        default:
            break;
    }
} 

@end
