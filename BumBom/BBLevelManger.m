//
//  BBLevelManger.m
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import "BBLevelManger.h"
#import "BBBombManager.h"

@interface BBLevelManger ()

@property (nonatomic,copy) BOOL (^actionStart)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate);
@property (nonatomic,copy) BOOL (^actionEnd)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate);
@property (nonatomic,copy) BOOL (^actionNextLevel)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate);

@end

@implementation BBLevelManger

+ (NSArray<BBLevelManger *> *)levels {
    static NSArray* list;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list = @[[BBLevelManger levelMangerWithActionStart:^BOOL(BBBombManager *bomb, id<BBLevelMangerDelegate> delegate) {
            [bomb reloadWithNumberBombs:40];
            return YES;
        }
                                                 endAction:^BOOL(BBBombManager *bomb, id<BBLevelMangerDelegate> delegate) {
                                                     return NO;
                                                 }
                                                 nextLevel:^BOOL(BBBombManager *bomb, id<BBLevelMangerDelegate> delegate) {
                                                     return NO;
                                                 }
                                               numberOfTap:10]];
    });
    return list;
}

+ (instancetype) levelMangerWithActionStart:(BOOL (^)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate)) actionStart
                                  endAction:(BOOL (^)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate)) actionEnd
                                  nextLevel:(BOOL (^)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate)) actionNextLevel
                                numberOfTap:(NSInteger)numberOfTap{
    BBLevelManger* levelManager = [self new];
    levelManager.actionStart = actionStart;
    levelManager.actionEnd = actionEnd;
    levelManager.actionNextLevel = actionNextLevel;
    levelManager.numberOfTap = numberOfTap;
    return levelManager;
}

- (BOOL)nextLevel:(BBBombManager *)bomManager{
    if (self.actionNextLevel) {
         return self.actionNextLevel(bomManager,self.delegate);
    }
    return NO;
}

- (BOOL)endLevel:(BBBombManager *)bomManager {
    if (self.actionEnd) {
        return self.actionEnd(bomManager,self.delegate);
    }
    return NO;
}

- (void)startLevel:(BBBombManager *)bomManager {
    self.currentTap = self.numberOfTap;
    if (self.actionStart) {
        self.actionStart(bomManager,self.delegate);
    }
}

@end
