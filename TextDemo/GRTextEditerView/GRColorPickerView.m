//
//  GRColorPickerView.m
//  TextDemo
//
//  Created by liangzhimy on 16/12/15.
//  Copyright © 2016年 liangzhimy. All rights reserved.
//

#import "GRColorPickerView.h"
#import "GRColorPickerCollectionViewCell.h"

static const CGFloat __GRCollectionViewSectionLeftRight = 24.f;
static const CGFloat __GRCollectionCellWidth = 22.f;
static const CGFloat __GRCollectionCellHeight = 22.f; 
static const CGFloat __GRCollectionMinSpace = 16.f;
static NSString * const __GRCollectionCellIdntifier = @"cellId";

@interface GRColorPickerView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray <UIColor *> *colors;

@end

@implementation GRColorPickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self __config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self __config];
    }
    return self;
}

- (void)__config {
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - property

- (NSArray<UIColor *> *)colors {
    if (!_colors) {
        _colors = [NSArray array];
    }
    return _colors;
} 

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        GRColorCollectionViewLayout *layout = [[GRColorCollectionViewLayout alloc] init];
        layout.itemSize = CGSizeMake(__GRCollectionCellWidth, __GRCollectionCellHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, __GRCollectionViewSectionLeftRight, 0, __GRCollectionViewSectionLeftRight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = __GRCollectionMinSpace;
        layout.minimumLineSpacing = 0.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor brownColor];
        [_collectionView setShowsHorizontalScrollIndicator:FALSE];
        
        UINib *nib = [UINib nibWithNibName:@"GRColorPickerCollectionViewCell"
                                    bundle: [NSBundle mainBundle]];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:__GRCollectionCellIdntifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (void)__colorButtonPressed:(id)sender {
    GRColorPickerCollectionViewCell *cell = (GRColorPickerCollectionViewCell *)sender;
    if (self.delegate) {
        [self.delegate colorPickerView:self pickerColor:cell.buttonColor];
    } 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color = self.colors[indexPath.row];
    
    GRColorPickerCollectionViewCell *cell = (GRColorPickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:__GRCollectionCellIdntifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.buttonColor = color;
    __weak typeof(self) weakSelf = self;
    [cell addClickBlock:^(id sender) {
        [weakSelf __colorButtonPressed:sender];
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(__GRCollectionCellWidth, __GRCollectionCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, __GRCollectionMinSpace, 0, __GRCollectionMinSpace);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return __GRCollectionMinSpace ;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return __GRCollectionMinSpace;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - public method

- (void)bindWithColors:(NSArray <UIColor *>*)colors {
    _colors = colors;
    [self.collectionView reloadData];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return FALSE;
    }
    return TRUE;
} 

@end

static const CGFloat __GRHorizontalOffsetXSpan = 5.f;

@implementation GRColorCollectionViewLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalOffset = proposedContentOffset.x + __GRHorizontalOffsetXSpan;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemOffset = layoutAttributes.frame.origin.x;
        if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOffset - horizontalOffset;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}


@end
