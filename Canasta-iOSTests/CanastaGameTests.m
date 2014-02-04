//
//  CanastaGameTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaGame.h"
#import "CanastaHand.h"
#import "CanastaDeck.h"
#import "CanastaDiscardPile.h"
#import "CanastaTeam.h"

@interface CanastaGame (Testing)
@property (nonatomic, strong) NSArray *hands;
@property (nonatomic, strong) CanastaDeck *deck;
@property (nonatomic, strong) CanastaDiscardPile *discardPile;
@property (nonatomic, strong) NSArray *teams;
@end

SPEC_BEGIN(CanastaGameTests)

describe(@"Canasta Game", ^{
    __block CanastaGame *game;
    
    beforeEach(^{
        game = [CanastaGame new];
    });
    
    it(@"sets up the game", ^{
        [[game.hands shouldNot] beNil];
        [[game.teams shouldNot] beNil];
        [[game.deck shouldNot] beNil];
        [[game.discardPile shouldNot] beNil];
        
        [[[[game hand:1] size] should] equal:@11];
        [[[[game hand:2] size] should] equal:@11];
        [[[[game hand:3] size] should] equal:@11];
        [[[[game hand:4] size] should] equal:@11];
        [[[game.discardPile topCard] should] beKindOfClass:[CanastaCard class]];
    });
    
    it(@"associates players with teams", ^{
        [[@([game teamNumberForPlayer:1]) should] equal:@1];
        [[@([game teamNumberForPlayer:2]) should] equal:@2];
        [[@([game teamNumberForPlayer:3]) should] equal:@1];
        [[@([game teamNumberForPlayer:4]) should] equal:@2];
    });
    
    context(@"with a rigged hand", ^{
        beforeEach(^{
            [[game hand:1] playCards:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 11)]];
            [[game hand:1] takeCards:@[[CanastaCard newWithRank:SEVEN suit:DIAMONDS],
                                       [CanastaCard newWithRank:SEVEN suit:HEARTS],
                                       [CanastaCard newWithRank:SEVEN suit:SPADES],
                                       [CanastaCard newWithRank:THREE suit:CLUBS]]];
        });
        
        it(@"can run moves", ^{
            [[@(game.turn) should] equal:@1];
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
            [game meldRank:SEVEN cardIndexes:indexes];
            [game draw];
            [[[[game hand:1].cards should] have:2] items];
            [game discard:0];
            
            [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
            [[[[[game team:1] melds][0] cards] should] equal:@[[CanastaCard newWithRank:SEVEN suit:DIAMONDS],
                                                              [CanastaCard newWithRank:SEVEN suit:HEARTS],
                                                              [CanastaCard newWithRank:SEVEN suit:SPADES]]];
            [[@(game.turn) should] equal:@2];
        });
    });
});

SPEC_END
