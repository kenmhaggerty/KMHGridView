//
//  KMHGridView.h
//  KMHGridView
//
//  Created by Ken M. Haggerty on 3/29/17.
//  Copyright © 2017 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES (Public) //

#pragma mark - // IMPORTS (Public) //

#import <UIKit/UIKit.h>

#pragma mark - // KMHGridView //

#pragma mark Notifications

extern NSString * const KMHGridViewWillAddCellNotification;
extern NSString * const KMHGridViewDidAddCellNotification;
extern NSString * const KMHGridViewWillRemoveCellNotification;
extern NSString * const KMHGridViewDidRemoveCellNotification;

extern NSString * const KMHGridViewNotificationObjectKey;
extern NSString * const KMHGridViewNotificationRowKey;
extern NSString * const KMHGridViewNotificationColKey;

#pragma mark Public Interface

@interface KMHGridView : UIStackView
@property (nonatomic) IBInspectable NSUInteger rows;
@property (nonatomic) IBInspectable NSUInteger cols;

// INITS //

- (id)initWithFrame:(CGRect)frame rows:(NSUInteger)rows cols:(NSUInteger)cols NS_DESIGNATED_INITIALIZER;
- (id)initWithFrame:(CGRect)frame DEPRECATED_MSG_ATTRIBUTE("use -[initWithFrame:rows:cols:].");

// CUSTOM INDEXED SUBSCRIPTING //

- (NSArray <UIView *> *)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(UIStackView *)obj atIndexedSubscript:(NSUInteger)idx;

// SETTERS //

- (void)setRows:(NSUInteger)rows animated:(BOOL)animated;
- (void)setCols:(NSUInteger)cols animated:(BOOL)animated;

// GENERAL //

- (void)insertRowAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeRowAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)insertColumnAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeColumnAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end