//
//  CanastaDumbRobot.h
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaGame.h"

@interface CanastaDumbRobot : NSObject

@property (nonatomic, strong) CanastaGame *game;

- (void)takeTurn;

@end
