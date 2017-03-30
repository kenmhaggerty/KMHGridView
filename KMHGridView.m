//
//  KMHGridView.m
//  KMHGridView
//
//  Created by Ken M. Haggerty on 3/29/17.
//  Copyright © 2017 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Private) //

#pragma mark - // IMPORTS (Private) //

#import "KMHGridView.h"

#pragma mark - // KMHGridView //

#pragma mark Imports

#include <asl.h>

#pragma mark Notifications

NSString * const KMHGridViewWillAddCellNotification = @"kKMHGridViewWillAddCellNotification";
NSString * const KMHGridViewDidAddCellNotification = @"KMHGridViewDidAddCellNotification";
NSString * const KMHGridViewWillRemoveCellNotification = @"KMHGridViewWillRemoveCellNotification";
NSString * const KMHGridViewDidRemoveCellNotification = @"KMHGridViewDidRemoveCellNotification";

NSString * const KMHGridViewNotificationObjectKey = @"object";
NSString * const KMHGridViewNotificationRowKey = @"row";
NSString * const KMHGridViewNotificationColKey = @"col";

#pragma mark Constants

NSTimeInterval const KMHGridViewAnimationSpeed = 0.18f;

#pragma mark Implementation

@implementation KMHGridView

#pragma mark // Setters and Getters (Public) //

@synthesize rows = _rows;
@synthesize cols = _cols;

- (void)setRows:(NSUInteger)rows {
    [self setRows:rows animated:NO];
}

- (void)setCols:(NSUInteger)cols {
    [self setCols:cols animated:NO];
}

#pragma mark // Inits and Loads //

- (id)initWithFrame:(CGRect)frame rows:(NSUInteger)rows cols:(NSUInteger)cols {
    self = [super initWithFrame:frame];
    if (self) {
        self.axis = UILayoutConstraintAxisVertical;
        self.distribution = UIStackViewDistributionFillEqually;
        self.alignment = UIStackViewAlignmentFill;
        
        self.rows = rows;
        self.cols = cols;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame rows:1 cols:1];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    for (int row = 0; row < self.rows; row++) {
        for (int col = 0; col < self.cols; col++) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewWillAddCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : self[row][col], KMHGridViewNotificationRowKey : @(row), KMHGridViewNotificationColKey : @(col)}];
        }
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    for (int row = 0; row < self.rows; row++) {
        for (int col = 0; col < self.cols; col++) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewDidAddCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : self[row][col], KMHGridViewNotificationRowKey : @(row), KMHGridViewNotificationColKey : @(col)}];
        }
    }
}

#pragma mark // Public Methods (Custom Indexed Subscripting) //

- (NSArray <UIView *> *)objectAtIndexedSubscript:(NSUInteger)idx {
    return ((UIStackView *)self.arrangedSubviews[idx]).arrangedSubviews;
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    asl_log(NULL, NULL, 4, "cannot set row after initialization");
}

#pragma mark // Public Methods (Setters) //

- (void)setRows:(NSUInteger)rows animated:(BOOL)animated {
    if (rows == self.rows) {
        return;
    }
    
    _rows = rows;
    
    for (NSUInteger i = self.arrangedSubviews.count; i < rows; i++) {
        [self insertRowAtIndex:i animated:animated];
    }
    for (NSUInteger i = self.arrangedSubviews.count; i > rows; i--) {
        [self removeRowAtIndex:i-1 animated:animated];
    }
}

- (void)setCols:(NSUInteger)cols animated:(BOOL)animated {
    if (cols == self.cols) {
        return;
    }
    
    _cols = cols;
    
    for (UIStackView *row in self.arrangedSubviews) {
        for (NSUInteger i = row.arrangedSubviews.count; i < cols; i++) {
            [self insertColumnAtIndex:i animated:animated];
        }
        for (NSUInteger i = row.arrangedSubviews.count; i > cols; i--) {
            [self removeColumnAtIndex:i-1 animated:animated];
        }
    }
}

#pragma mark // Public Methods (General) //

- (void)insertRowAtIndex:(NSUInteger)index animated:(BOOL)animated {NSMutableArray *cells = [NSMutableArray arrayWithCapacity:self.cols];
    UIView *cell;
    while (cells.count < self.cols) {
        cell = [[UIView alloc] init];
        [cells addObject:cell];
    }
    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:cells];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.distribution = UIStackViewDistributionFillEqually;
    row.alignment = UIStackViewAlignmentFill;
    row.hidden = YES;
    [self insertArrangedSubview:row atIndex:index];
    for (int i = 0; i < cells.count; i++) {
        cell = cells[i];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewWillAddCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(index), KMHGridViewNotificationColKey : @(i)}];
    }
    [UIView animateWithDuration:(animated ? KMHGridViewAnimationSpeed : 0.0f) animations:^{
        row.hidden = NO;
    } completion:^(BOOL finished) {
        for (int i = 0; i < cells.count; i++) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewDidAddCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(index), KMHGridViewNotificationColKey : @(i)}];
        }
    }];
}

- (void)removeRowAtIndex:(NSUInteger)index animated:(BOOL)animated {
    UIStackView *row = self.arrangedSubviews[index];
    NSArray *cells = row.arrangedSubviews;
    UIView *cell;
    for (int i = 0; i < cells.count; i++) {
        cell = cells[i];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewWillRemoveCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(index), KMHGridViewNotificationColKey : @(i)}];
    }
    [UIView animateWithDuration:(animated ? KMHGridViewAnimationSpeed : 0.0f) animations:^{
        row.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeArrangedSubview:row];
        for (int i = 0; i < cells.count; i++) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewDidRemoveCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(index), KMHGridViewNotificationColKey : @(i)}];
        }
    }];
}

- (void)insertColumnAtIndex:(NSUInteger)index animated:(BOOL)animated {
    UIStackView *row;
    UIView *cell;
    for (int i = 0; i < self.arrangedSubviews.count; i++) {
        row = self.arrangedSubviews[i];
        cell = [[UIView alloc] init];
        cell.hidden = YES;
        [row insertArrangedSubview:cell atIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewWillAddCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(i), KMHGridViewNotificationColKey : @(index)}];
        [UIView animateWithDuration:(animated ? KMHGridViewAnimationSpeed : 0.0f) animations:^{
            cell.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewDidAddCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(i), KMHGridViewNotificationColKey : @(index)}];
        }];
    }
}

- (void)removeColumnAtIndex:(NSUInteger)index animated:(BOOL)animated {
    UIStackView *row;
    UIView *cell;
    for (int i = 0; i < self.arrangedSubviews.count; i++) {
        row = self.arrangedSubviews[i];
        cell = row.arrangedSubviews[index];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewWillRemoveCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(i), KMHGridViewNotificationColKey : @(index)}];
        [UIView animateWithDuration:(animated ? KMHGridViewAnimationSpeed : 0.0f) animations:^{
            cell.hidden = YES;
        } completion:^(BOOL finished) {
            [row removeArrangedSubview:cell];
            [[NSNotificationCenter defaultCenter] postNotificationName:KMHGridViewDidRemoveCellNotification object:self userInfo:@{KMHGridViewNotificationObjectKey : cell, KMHGridViewNotificationRowKey : @(i), KMHGridViewNotificationColKey : @(index)}];
        }];
    }
}

@end
