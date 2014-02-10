//
//  CanastaGameTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaGameObserver.h"
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
@property (nonatomic) NSUInteger turn;
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
    
    context(@"with observer", ^{
        __block id gameObserver;
        
        beforeEach(^{
            gameObserver = [KWMock mockForProtocol:@protocol(CanastaGameObserver)];
        });
        
        it(@"doesn't let players keep red threes", ^{
            [[NSNotificationCenter defaultCenter] addObserver:gameObserver selector:@selector(newRedThree) name:@"new red three" object:nil];
            
            NSMutableArray *cards = [NSMutableArray new];
            [cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
            [cards addObject:[CanastaCard newWithRank:THREE suit:HEARTS]];
            [cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
            [cards addObject:[CanastaCard newWithRank:THREE suit:HEARTS]];
            for (NSInteger i = 0; i < 43; i++) {
                [cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
            }
            game.deck.cards = cards;
            
            [[gameObserver should] receive:@selector(newRedThree) withCount:2];
            
            for (NSInteger i = 1; i < 5; i++) {
                [[[[game hand:i] size] should] equal:@11];
                for (CanastaCard *card in [game hand:i].cards) {
                    [[@([card isRedThree]) should] beNo];
                }
            }
            [[[[game team:2] redThreeCount] should] equal:@1];
            [[[[game team:1] redThreeCount] should] equal:@0];
            [game draw];
            [[[[game team:1] redThreeCount] should] equal:@1];
            [[[[game hand:1] size] should] equal:@12];
            [[NSNotificationCenter defaultCenter] removeObserver:gameObserver];
        });
        
        describe(@"game interface", ^{
            context(@"with a rigged game", ^{
                beforeEach(^{
                    [[game hand:1].cards removeAllObjects];
                    [[game hand:1] takeCards:@[[CanastaCard newWithRank:THREE suit:CLUBS],
                                               [CanastaCard newWithRank:SEVEN suit:DIAMONDS],
                                               [CanastaCard newWithRank:SEVEN suit:HEARTS],
                                               [CanastaCard newWithRank:SEVEN suit:SPADES]]];
                    
                    game.discardPile.cards = [@[[CanastaCard newWithRank:ACE suit:SPADES]] mutableCopy];
                    [game.deck.cards addObject:[CanastaCard newWithRank:NINE suit:SPADES]];
                    [game.deck.cards addObject:[CanastaCard newWithRank:ACE suit:SPADES]];
                    
                });
                
                it(@"allows drawing cards", ^{
                    [[NSNotificationCenter defaultCenter] addObserver:gameObserver selector:@selector(handChanged) name:@"hands changed" object:nil];
                    [[[gameObserver should] receive] handChanged];
                    
                    [game draw];
                    [[[game hand:1].cards[4] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                    [[@([game canDraw]) should] beNo];
                    [game draw];
                    [[[game hand:1].cards[4] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                    
                    CanastaGame *game2 = [CanastaGame new];
                    [[[[game2 hand:1] size] should] equal:@11];
                    [game2.deck.cards removeAllObjects];
                    [[@([game2 canDraw]) should] beNo];
                    [game2 draw];
                    [[[[game2 hand:1] size] should] equal:@11];
                    [[NSNotificationCenter defaultCenter] removeObserver:gameObserver];
                });
                
                it(@"can stage and run discards", ^{
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter addObserver:gameObserver selector:@selector(newTurn) name:@"new turn" object:nil];
                    [notificationCenter addObserver:gameObserver selector:@selector(discardPileChanged) name:@"discard pile changed" object:nil];
                    [game stageDiscard:1];
                    [[@([game turnValid]) should] beNo];
                    
                    [game draw];
                    [[@([game turnValid]) should] beYes];
                    [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                    [[[game stagedDiscard] should] equal:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
                    
                    [[[[game hand:1] size] should] equal:@4];
                    [game stageDiscard:0];
                    [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
                    [[[game stagedDiscard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
                    
                    [game unstageDiscard];
                    [[@([game turnValid]) should] beNo];
                    [[[game stagedDiscard] should] beNil];
                    [game finishTurn];
                    [[@(game.turn) should] equal:@1];
                    
                    [game stageDiscard:0];
                    [[[game stagedDiscard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
                    
                    [[[gameObserver should] receive] newTurn];
                    [[[gameObserver should] receive] discardPileChanged];
                    [game finishTurn];
                    [[[game.discardPile topCard] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
                    [[[game stagedDiscard] should] beNil];
                    [[@(game.turn) should] equal:@2];
                    [[NSNotificationCenter defaultCenter] removeObserver:gameObserver];
                });
                
                it(@"properly handles drawing cards across multiple turns", ^{
                    for (NSInteger i = 0; i < 8; i ++) {
                        [[@([game canDraw]) should] beYes];
                        [game draw];
                        [game stageDiscard:0];
                        [game finishTurn];
                    }
                });
                
                it(@"can stage and run melds", ^{
                    [[NSNotificationCenter defaultCenter] addObserver:gameObserver selector:@selector(stagedMeldsChanged) name:@"staged melds changed" object:nil];
                    [[gameObserver should] receive:@selector(stagedMeldsChanged) withCount:5];
                    
                    [[game hand:1] takeCard:[CanastaCard newJoker:BLACK]];
                    
                    [[@([game turnValid]) should] beNo];
                    
                    [[@([game meldSlotCount]) should] equal:@1];
                    
                    [[@([game canStageMeld:0 cardIndex:0]) should] beNo];
                    [game stageMeld:0 cardIndex:0];
                    [[@([game meldSlotCount]) should] equal:@1];
                    
                    [[@([game canStageMeld:1 cardIndex:0]) should] beNo];
                    [[@([game canStageMeld:1 cardIndex:1]) should] beNo];
                    [[@([game canStageMeld:0 cardIndex:1]) should] beYes];
                    
                    [game stageMeld:0 cardIndex:1];
                    [[@([game meldSlotCount]) should] equal:@2];
                    [[@([game turnValid]) should] beNo];
                    
                    [game draw];
                    [[@([game turnValid]) should] beNo];
                    
                    [[@([game canStageMeld:0 cardIndex:1]) should] beYes];
                    [[@([game canStageMeld:0 cardIndex:3]) should] beNo];
                    [[@([game canStageMeld:0 cardIndex:4]) should] beYes];
                    [[@([game canStageMeld:1 cardIndex:1]) should] beNo];
                    [[@([game canStageMeld:1 cardIndex:3]) should] beYes];
                    [[@([game canStageMeld:1 cardIndex:4]) should] beNo];
                    
                    [game stageMeld:0 cardIndex:1];
                    [game stageMeld:0 cardIndex:1];
                    [game stageDiscard:0];
                    [[[game stagedMeld:0].cards[0] should] equal:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
                    [[@([game turnValid]) should] beYes];
                    
                    [game stageMeld:1 cardIndex:0];
                    [[@([game turnValid]) should] beNo];
                    
                    [game unstageTopCardInMeld:1];
                    [[@([game meldSlotCount]) should] equal:@2];
                    
                    [[@([game stagedScore]) should] equal:@15];
                    
                    [game finishTurn];
                    
                    [[[game team:1].meldCount should] equal:@1];
                  
                    [[NSNotificationCenter defaultCenter] removeObserver:gameObserver];
                });
                
                it(@"can add to existing melds", ^{
                    [game draw];
                    [game stageMeld:0 cardIndex:1];
                    [game stageMeld:0 cardIndex:1];
                    [game stageMeld:0 cardIndex:1];
                    [game stageDiscard:0];
                    [game finishTurn];
                    
                    [[game hand:1] takeCard:[CanastaCard newWithRank:SEVEN suit:CLUBS]];
                    
                    game.turn = 1;
                    
                    [[@([game meldSlotCount]) should] equal:@2];
                    
                    [game draw];
                    
                    [[@([game canStageMeld:0 cardIndex:0]) should] beYes];
                    [[@([game canStageMeld:1 cardIndex:0]) should] beNo];
                    [[@([game canStageMeld:0 cardIndex:1]) should] beNo];
                    
                    [game stageMeld:0 cardIndex:0];
                    [game stageDiscard:0];
                    [game finishTurn];
                    
                    CanastaMeld *meld = [game team:1].melds[0];
                    [[meld.cards[0] should] equal:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
                    [[meld.cards[1] should] equal:[CanastaCard newWithRank:SEVEN suit:HEARTS]];
                    [[meld.cards[2] should] equal:[CanastaCard newWithRank:SEVEN suit:SPADES]];
                    [[meld.cards[3] should] equal:[CanastaCard newWithRank:SEVEN suit:CLUBS]];
                    
                    game.turn = 1;
                    
                    [[[meld size] should] equal:@4];
                    
                    [game unstageTopCardInMeld:0];
                    [[[meld size] should] equal:@4];
                });
            });
        });
    });
});

SPEC_END