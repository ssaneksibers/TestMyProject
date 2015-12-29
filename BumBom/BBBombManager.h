//
//  BBBombManager.h
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct {
    CGPoint position;
    CGPoint velocitu;
    BOOL isActivState;
    float curentRadius;
    float time;
    NSInteger type;
} BBBomb;


@interface BBBombManager : NSObject

@property (nonatomic,strong,readonly) NSDictionary* resultDictionary;

@property (nonatomic,assign) CGPoint area;
@property (nonatomic,assign) CGFloat maxRadius;
@property (nonatomic,assign) CGFloat minRadius;
@property (nonatomic,assign) CGFloat timeRadius;
@property (nonatomic,assign) CGFloat deltaVel;

- (instancetype) initWithArea:(CGPoint) area;
- (void) reloadWithNumberBombs:(NSInteger) numberOfBombs;

- (void) reloadWithNumberBombs:(NSInteger) numberOfBombs
              countWithTypeOne:(NSInteger) numberOne
            countWithNumberTwo:(NSInteger) numberTwo;

- (void) nextStepWithTime:(float) time;
- (NSInteger) numberOfBombs;
- (BBBomb*) bombsAtIndex:(NSInteger) index;

- (void) activBombAtIndex:(NSInteger) index;

@end
