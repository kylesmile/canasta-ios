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

@interface CanastaDeck (Testing)
@property (nonatomic, strong) NSMutableArray *cards;
@end

@interface CanastaHand (Testing)
@property (nonatomic, strong) NSMutableArray *cards;
@end

@interface CanastaDiscardPile (Testing)
@property (nonatomic, strong) NSMutableArray *cards;
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
    
    it(@"doesn't let players keep red threes", ^{
        NSMutableArray *cards = [NSMutableArray new];
        [cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
        [cards addObject:[CanastaCard newWithRank:THREE suit:HEARTS]];
        [cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
        [cards addObject:[CanastaCard newWithRank:THREE suit:HEARTS]];
        for (NSInteger i = 0; i < 43; i++) {
            [cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
        }
        game.deck.cards = cards;
        for (NSInteger i = 1; i < 5; i++) {
            [[[[game hand:i] size] should] equal:@11];
            for (CanastaCard *card in [game hand:i].cards) {
                [[@([card isRedThree]) should] beNo];
            }
        }
        [[[[game team:2] redThreeCount] should] equal:@1];
        [game draw];
        [[[[game team:1] redThreeCount] should] equal:@1];
        [[[[game hand:1] size] should] equal:@12];
    });
    
    describe(@"game interface", ^{
        context(@"with a rigged game", ^{
            beforeEach(^{
                [[game hand:1].cards removeAllObjects];
                [[game hand:1] takeCards:@[[CanastaCard newWithRank:SEVEN suit:DIAMONDS],
                                           [CanastaCard newWithRank:SEVEN suit:HEARTS],
                                           [CanastaCard newWithRank:SEVEN suit:SPADES],
                                           [CanastaCard newWithRank:THREE suit:CLUBS]]];
                game.discardPile.cards = [@[[CanastaCard newWithRank:ACE suit:SPADES]] mutableCopy];
                [game.deck.cards addObject:[CanastaCard newWithRank:NINE suit:SPADES]];
                [game.deck.cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
                
            });
            
            it(@"allows drawing cards", ^{
                [game draw];
                [[[game hand:1].cards[4] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                [[@([game canDraw]) should] beNo];
                [game draw];
                [[[game hand:1].cards[4] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
            });
            
            it(@"can stage and run discards", ^{
                [game draw];
                
                [game stageDiscard:0];
                [[@([game turnValid]) should] beYes];
                [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                [[[game stagedDiscard] should] equal:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
                
                [[[[game hand:1] size] should] equal:@4];
                [game stageDiscard:2];
                [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                [[[game stagedDiscard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
                
                [game unstageDiscard];
                [[@([game turnValid]) should] beNo];
                [[[game stagedDiscard] should] beNil];
                [game finishTurn];
                [[@(game.turn) should] equal:@1];
                
                [game stageDiscard:4];
                [[[game stagedDiscard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
                
                [game finishTurn];
                [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
                [[[game stagedDiscard] should] beNil];
                [[@(game.turn) should] equal:@2];
            });
            
//            it(@"can stage and run melds", ^{
//                [[game hand:1].cards addObject:[CanastaCard newJoker:BLACK]];
//                [[@([game meldSlotCount]) should] equal:@1];
//                [[@([game canStageMeld:0 cardIndex:0]) should] beYes];
//                [game stageMeld:0 cardIndex:0];
//                [[@([game meldSlotCount]) should] equal:@2];
//                [[[game canStageMeld:1 cardIndex:0] should] beNo];
//                [[[game canStageMeld:0 cardIndex:0] should] beYes];
//            });
        });
    });
});

SPEC_END
