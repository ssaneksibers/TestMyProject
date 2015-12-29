//
//  BBBombManager.m
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import "BBBombManager.h"

@interface BBBombManager ()

@property (nonatomic,assign) BBBomb* bombs;
@property (nonatomic,assign) NSInteger numberOfBomb;

@end

@implementation BBBombManager{
    NSMutableDictionary* _resultDictionary;
}

- (instancetype)initWithArea:(CGPoint)area {
    self = [super init];
    if (self) {
        _area = area;
        _bombs = NULL;
        _deltaVel = 4.;
    }
    return self;
}

- (void)dealloc {
    if (self.bombs) {
        free(self.bombs);
    }
}

- (void) reloadWithNumberBombs:(NSInteger) numberOfBombs{
    self.numberOfBomb =  numberOfBombs;
    if (self.bombs) {
        free(self.bombs);
    }
    _resultDictionary = [NSMutableDictionary new];
    self.bombs = malloc( sizeof(BBBomb) * numberOfBombs);
    for (int i = 0; i < numberOfBombs; i++) {
        self.bombs[i].position = CGPointMake((float)(rand() % (int)self.area.x),
                                             (float)(rand() % (int)self.area.y));
        
        self.bombs[i].velocitu = CGPointMake(((float)(rand() % (int)self.area.x) / self.area.x  - 0.5) * self.deltaVel,
                                             ((float)(rand() % (int)self.area.y) / self.area.y  - 0.5) * self.deltaVel);
        self.bombs[i].isActivState = NO;
        self.bombs[i].curentRadius = self.minRadius;
        self.bombs[i].time = 0;
        self.bombs[i].type = 0;
    }
}

- (void) reloadWithNumberBombs:(NSInteger) numberOfBombs
              countWithTypeOne:(NSInteger) numberOne
            countWithNumberTwo:(NSInteger) numberTwo{
    self.numberOfBomb =  numberOfBombs + numberTwo + numberOne;
    if (self.bombs) {
        free(self.bombs);
    }
    self.bombs = malloc( sizeof(BBBomb) * (numberOfBombs + numberTwo + numberOne));
    for (int i = 0; i < numberOfBombs + numberTwo + numberOne; i++) {
        self.bombs[i].position = CGPointMake((float)(rand() % (int)self.area.x),
                                             (float)(rand() % (int)self.area.y));
        
        self.bombs[i].velocitu = CGPointMake(((float)(rand() % (int)self.area.x) / self.area.x  - 0.5) * self.deltaVel,
                                             ((float)(rand() % (int)self.area.y) / self.area.y  - 0.5) * self.deltaVel);
        self.bombs[i].isActivState = NO;
        self.bombs[i].curentRadius = self.minRadius;
        self.bombs[i].time = 0;
        self.bombs[i].time = 0;
        if (i < numberOne) {
            self.bombs[i].type = 1;
        } else if (i -  numberOne < numberTwo) {
            self.bombs[i].type = 2;
        }
    }
}


- (void) nextStepWithTime:(float) time{
    for (int i = 0; i < self.numberOfBomb; i++) {
        if (self.bombs[i].isActivState) {
            self.bombs[i].time += time;
            NSLog(@"%f",self.bombs[i].time);
            if (self.bombs[i].time > self.timeRadius * 2.) {
                [self removeBombWithIndex:i];
                i--;
            } else {
                if (self.bombs[i].type != 2) {
                    self.bombs[i].curentRadius +=
                    ((self.bombs[i].time > self.timeRadius)?-1.:1) *
                    (self.maxRadius - self.minRadius) / self.timeRadius * time;
                } else {
                    self.bombs[i].time += time * 3.;
                    self.bombs[i].curentRadius = self.maxRadius * 1.5;
                }
                if (self.bombs[i].type != 1 || self.bombs[i].time > self.timeRadius) {
                    for (int j = 0; j < self.numberOfBombs; j++) {
                        if (j != i && !self.bombs[j].isActivState){
                            float length =
                            (self.bombs[i].position.x - self.bombs[j].position.x) *
                            (self.bombs[i].position.x - self.bombs[j].position.x) +
                            (self.bombs[i].position.y - self.bombs[j].position.y) *
                            (self.bombs[i].position.y - self.bombs[j].position.y);
                            
                            if (length < self.bombs[i].curentRadius * self.bombs[i].curentRadius +
                                self.bombs[j].curentRadius * self.bombs[j].curentRadius) {
                                [self activBombAtIndex:j];
                            }
                        }
                    }
                }
            }
        } else {
            self.bombs[i].position.x += self.bombs[i].velocitu.x;
            self.bombs[i].position.y += self.bombs[i].velocitu.y;
            if (self.bombs[i].position.x < 0 || self.bombs[i].position.x > self.area.x) {
                self.bombs[i].velocitu.x = -self.bombs[i].velocitu.x;
            }
            if (self.bombs[i].position.y < 0 || self.bombs[i].position.y > self.area.y) {
                self.bombs[i].velocitu.y = -self.bombs[i].velocitu.y;
            }
        }
    }
}

- (NSInteger) numberOfBombs{
    return _numberOfBomb;
}

- (BBBomb*) bombsAtIndex:(NSInteger) index{
    return &self.bombs[index];
}

- (void) activBombAtIndex:(NSInteger) index{
    if (!self.bombs[index].isActivState) {
        self.bombs[index].isActivState = YES;
        self.bombs[index].time = 0;
    }
}

- (NSDictionary *)resultDictionary{
    return _resultDictionary;
}

#pragma mark - private
- (void) removeBombWithIndex:(NSInteger) index{
    if (self.numberOfBomb - 1 != index) {
        self.bombs[index] = self.bombs[self.numberOfBomb - 1];
        _resultDictionary[@(self.bombs[index].type)] = @([_resultDictionary[@(self.bombs[index].type)] integerValue] + 1);
    }
    self.numberOfBomb--;
}

@end
