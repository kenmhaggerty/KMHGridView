//
//  KMHGridViewTests.m
//  KMHGridViewTests
//
//  Created by Ken M. Haggerty on 3/29/17.
//  Copyright © 2017 Ken M. Haggerty. All rights reserved.
//

#pragma mark - // NOTES //

#pragma mark - // IMPORTS //

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import <KIF/KIF.h>

#pragma mark - // KMHGridViewTests //

#pragma mark Imports

#import "KMHGridView.h"

#pragma mark Implementation

SpecBegin(KMHGridViewTests)

describe(@"KMHGridViewTests", ^{
    
#pragma mark // Variables //
    
    __block KMHGridView *gridView;
    
#pragma mark // Constants //
    
    NSTimeInterval defaultTimeout = 1.0f;
    
    NSUInteger rows = 2;
    NSUInteger cols = 3;
    
#pragma mark // Inits and Loads //
    
    beforeAll(^{
        [KIFUITestActor setDefaultTimeout:defaultTimeout];
    });
    
    beforeEach(^{
        gridView = [[KMHGridView alloc] initWithFrame:CGRectZero rows:rows cols:cols];
    });
    
    afterEach(^{
        // before each
    });
    
#pragma mark - // TESTS //
    
    describe(@"grid view", ^{
        
        it(@"can be created", ^{
            
            expect(gridView).toNot.beNil();
        });
        
        describe(@"rows", ^{
            
            it(@"were set", ^{
                
                expect(gridView.rows).to.equal(rows);
            });
            
            it(@"can be added", ^{
                
                gridView.rows = rows+1;
                expect(gridView.rows).to.equal(rows+1);
            });
            
            it(@"can be removed", ^{
                
                gridView.rows = rows-1;
                expect(gridView.rows).to.equal(rows-1);
            });
        });
        
        describe(@"columns", ^{
            
            it(@"were set", ^{
                
                expect(gridView.cols).to.equal(cols);
            });
            
            it(@"can be added", ^{
                
                gridView.cols = cols+1;
                expect(gridView.cols).to.equal(cols+1);
            });
            
            it(@"can be removed", ^{
                
                gridView.cols = cols-1;
                expect(gridView.cols).to.equal(cols-1);
            });
        });
        
        describe(@"cells", ^{
            
            it(@"were created", ^{
                
                for (int row = 0; row < rows; row++) {
                    for (int col = 0; col < cols; col++) {
                        expect(gridView[row][col]).toNot.beNil();
                    }
                }
            });
        });
    });
});

SpecEnd
