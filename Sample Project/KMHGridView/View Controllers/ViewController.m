//
//  ViewController.m
//  KMHGridView
//
//  Created by Ken M. Haggerty on 12/11/16.
//  Copyright © 2016 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES //

#pragma mark - // IMPORTS //

#import "ViewController.h"

#pragma mark - // ViewController //

#pragma mark Imports

#import "KMHGridView.h"

#pragma mark Private Interface

@interface ViewController ()
@property (nonatomic, strong) IBOutlet KMHGridView *gridView;
@property (nonatomic, strong) IBOutlet UIStepper *rowStepper;
@property (nonatomic, strong) IBOutlet UIStepper *colStepper;

// IBACTIONS //

- (IBAction)stepperDidChangeValue:(UIStepper *)sender;

// OBSERVERS //

- (void)addObserversToGridView:(KMHGridView *)gridView;
- (void)removeObserversFromGridView:(KMHGridView *)gridView;

// RESPONDERS //

- (void)gridViewWillAddCell:(NSNotification *)notification;

@end

#pragma mark Implementation

@implementation ViewController

#pragma mark // Inits and Loads //

- (void)dealloc {
    [self removeObserversFromGridView:self.gridView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserversToGridView:self.gridView];
    
    self.rowStepper.value = self.gridView.rows;
    self.colStepper.value = self.gridView.cols;
    
//    self.gridView.accessibilityLabel = BoardAccessibilityLabel;
}

#pragma mark // Private Methods (IBActions) //

- (IBAction)stepperDidChangeValue:(UIStepper *)sender {
    if ([sender isEqual:self.rowStepper]) {
        [self.gridView setRows:sender.value animated:YES];
    }
    else if ([sender isEqual:self.colStepper]) {
        [self.gridView setCols:sender.value animated:YES];
    }
}

#pragma mark // Private Methods (Observers) //

- (void)addObserversToGridView:(KMHGridView *)gridView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gridViewWillAddCell:) name:KMHGridViewWillAddCellNotification object:gridView];
}

- (void)removeObserversFromGridView:(KMHGridView *)gridView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KMHGridViewWillAddCellNotification object:gridView];
}

#pragma mark // Private Methods (Responders) //

- (void)gridViewWillAddCell:(NSNotification *)notification {
    UIView *cell = notification.userInfo[KMHGridViewNotificationObjectKey];
    NSUInteger row = ((NSNumber *)notification.userInfo[KMHGridViewNotificationRowKey]).integerValue;
    NSUInteger col = ((NSNumber *)notification.userInfo[KMHGridViewNotificationColKey]).integerValue;
    
    cell.backgroundColor = (row + col) % 2 ? [UIColor cyanColor] : [UIColor whiteColor];
}

@end
