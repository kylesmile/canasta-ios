//
//  CanastaDumbRobotTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaDumbRobot.h"
#import "CanastaGame.h"

SPEC_BEGIN(CanastaDumbRobotTests)

describe(@"Canasta Dumb Robot", ^{
    it(@"can take a turn", ^{
        CanastaDumbRobot *robot = [CanastaDumbRobot new];
        CanastaGame *game = [CanastaGame new];
        robot.game = game;
        [[@(game.turn) should] equal:@1];
        [robot takeTurn];
        [[@(game.turn) should] equal:@2];
    });
});

SPEC_END
