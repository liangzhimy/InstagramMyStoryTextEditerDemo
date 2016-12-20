//
//  ViewController.m
//  TextDemo
//
//  Created by liangzhimy on 16/12/14.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "ViewController.h"
#import "GRTextEditerView.h"
#import "GRColorPickerView.h"

static const CGFloat __GRDefaultPickerOffsetY = 20;

@interface ViewController () <GRColorPickerViewDelegate>

@property (strong, nonatomic) GRTextEditerView *textEditerView;
@property (strong, nonatomic) GRColorPickerView *pickerColorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerColorViewContraint;
@property (weak, nonatomic) IBOutlet UIView *textEditerContainerView;
@property (weak, nonatomic) IBOutlet UIView *colorPickerContainerView;

@end

@implementation ViewController

- (void)dealloc {
    [self __removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self __addObserver];
    
    [self.textEditerContainerView addSubview:self.textEditerView];
    [self.textEditerContainerView layoutIfNeeded];
    self.textEditerView.frame = self.textEditerContainerView.bounds;
    [self.textEditerView config];
    self.textEditerView.fixTopHeight = 40.f;
    
    self.textEditerView.color = [UIColor redColor];
    
    [self.colorPickerContainerView layoutIfNeeded];
    [self.colorPickerContainerView addSubview:self.pickerColorView];
    self.pickerColorView.frame = self.colorPickerContainerView.bounds;
    self.colorPickerContainerView.hidden = TRUE; 
    
    [self.pickerColorView bindWithColors:@[
                                           [UIColor whiteColor],
                                           [UIColor redColor],
                                           [UIColor blackColor],
                                           [UIColor greenColor],
                                           [UIColor grayColor],
                                           [UIColor yellowColor],
                                           [UIColor purpleColor],
                                           [UIColor whiteColor],
                                           [UIColor redColor],
                                           [UIColor blackColor],
                                           [UIColor greenColor],
                                           [UIColor grayColor],
                                           [UIColor yellowColor],
                                           [UIColor purpleColor],
                                           [UIColor whiteColor],
                                           [UIColor redColor],
                                           [UIColor blackColor],
                                           [UIColor greenColor],
                                           [UIColor grayColor],
                                           [UIColor yellowColor],
                                           [UIColor purpleColor],
                                           [UIColor whiteColor],
                                           [UIColor redColor],
                                           [UIColor blackColor],
                                           [UIColor greenColor],
                                           [UIColor grayColor],
                                           [UIColor yellowColor],
                                           [UIColor purpleColor],
                                           [UIColor whiteColor],
                                           [UIColor redColor],
                                           [UIColor blackColor],
                                           [UIColor greenColor],
                                           [UIColor grayColor],
                                           [UIColor yellowColor],
                                           [UIColor purpleColor],
                                           [UIColor whiteColor],
                                           [UIColor redColor],
                                           [UIColor blackColor],
                                           [UIColor greenColor],
                                           [UIColor grayColor],
                                           [UIColor yellowColor],
                                           [UIColor purpleColor]
                                           ]]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - GRTextEditerView
- (GRTextEditerView *)textEditerView {
    if (!_textEditerView) {
        NSArray *array = [[NSBundle bundleForClass:[GRTextEditerView class]] loadNibNamed:@"GRTextEditerView" owner:nil options:nil];
        _textEditerView = [array lastObject]; 
    }
    return _textEditerView;
}

- (GRColorPickerView *)pickerColorView {
    if (!_pickerColorView) {
        _pickerColorView = [[GRColorPickerView alloc] init];
        _pickerColorView.delegate = self;
    }
    return _pickerColorView;
}

#pragma mark - GRColorPickerViewDelegate

- (void)colorPickerView:(id)sender pickerColor:(UIColor *)color {
    self.textEditerView.color = color;
} 

#pragma mark - observer keyboard

- (void)__addObserver {
    [self __addObserverKeyboard]; 
} 

- (void)__removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
} 

- (void)__addObserverKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    self.pickerColorViewContraint.constant = height + __GRDefaultPickerOffsetY;
    self.colorPickerContainerView.hidden = FALSE;
   
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.pickerColorViewContraint.constant = __GRDefaultPickerOffsetY;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
        self.colorPickerContainerView.hidden = TRUE;
    }];
}

@end
