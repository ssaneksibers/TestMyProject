//
//  BBLevelManger.h
//  BumBom
//
//  Created by Alexander Shipin on 29/12/15.
//  Copyright © 2015 Alexander Shipin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BBBombManager;

typedef enum {
    BBLevelMangerMessageTypeEndLevel,
    BBLevelMangerMessageTypeStartLevel,
    BBLevelMangerMessageTypeFaild
}BBLevelMangerMessageType;

@protocol BBLevelMangerDelegate <NSObject>

- (void) showAlertText:(NSString*) alertText
                 title:(NSString*) title
                  type:(BBLevelMangerMessageType) type;


@end

@interface BBLevelManger : NSObject

+ (NSArray<BBLevelManger*>*) levels;

+ (instancetype) levelMangerWithActionStart:(BOOL (^)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate)) actionStart
                                  endAction:(BOOL (^)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate)) actionEnd
                                  nextLevel:(BOOL (^)(BBBombManager* bomb,id<BBLevelMangerDelegate> delegate)) nextLevelAction;


@property (nonatomic,weak) id<BBLevelMangerDelegate> delegate;

- (void) startLevel:(BBBombManager*) bomManager;
- (BOOL) nextLevel:(BBBombManager*) bomManager;
- (BOOL) endLevel:(BBBombManager*) bomManager;

@end
