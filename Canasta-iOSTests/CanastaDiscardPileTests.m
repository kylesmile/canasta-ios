//
//  CanastaDiscardPileTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaDiscardPile.h"

SPEC_BEGIN(CanastaDiscardPileTests)

describe(@"Canasta Discard Pile", ^{
    __block CanastaDiscardPile *discardPile;
    
    beforeEach(^{
        discardPile = [CanastaDiscardPile new];
    });
    
    it(@"knows its size", ^{
        [[[discardPile size] should] equal:@0];
        
        [discardPile discard:[CanastaCard newWithRank:THREE suit:CLUBS]];
        [[[discardPile size] should] equal:@1];
    });
    
    context(@"with cards discarded", ^{
        
        beforeEach(^{
            [discardPile discard:[CanastaCard newWithRank:ACE suit:SPADES]];
        });
        
        it(@"tells its top card", ^{
            [[[discardPile topCard] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
        });
        
        it(@"knows if it is frozen", ^{
            CanastaDiscardPile *pile2 = [CanastaDiscardPile new];
            CanastaDiscardPile *pile3 = [CanastaDiscardPile new];
            
            [pile2 discard:[CanastaCard newWithRank:THREE suit:HEARTS]];
            [pile3 discard:[CanastaCard newJoker:RED]];
            
            [[@([discardPile isFrozen]) should] beNo];
            
            [discardPile discard:[CanastaCard newWithRank:TWO suit:HEARTS]];
            
            [[@([discardPile isFrozen]) should] beYes];
            [[@([pile2 isFrozen]) should] beYes];
            [[@([pile3 isFrozen]) should] beYes];
            
            [discardPile discard:[CanastaCard newWithRank:ACE suit:SPADES]];
            [pile2 discard:[CanastaCard newWithRank:JACK suit:HEARTS]];
            [pile3 discard:[CanastaCard newWithRank:TEN suit:DIAMONDS]];
            
            [[@([discardPile isFrozen]) should] beYes];
            [[@([pile2 isFrozen]) should] beYes];
            [[@([pile3 isFrozen]) should] beYes];
        });
        
        it(@"knows if it is locked", ^{
            [[@([discardPile isLocked]) should] beNo];
            
            [discardPile discard:[CanastaCard newWithRank:THREE suit:DIAMONDS]];
            [[@([discardPile isLocked]) should] beYes];
            
            [discardPile discard:[CanastaCard newJoker:BLACK]];
            [[@([discardPile isLocked]) should] beYes];
            
            [discardPile discard:[CanastaCard newWithRank:THREE suit:SPADES]];
            [[@([discardPile isLocked]) should] beYes];
            
            [discardPile discard:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
            [[@([discardPile isLocked]) should] beNo];
        });
        
        it(@"knows what card froze it", ^{
            [[[discardPile freezingCard] should] beNil];
            
            [discardPile discard:[CanastaCard newJoker:RED]];
            [[[discardPile freezingCard] should] equal:[CanastaCard newJoker:RED]];
            
            [discardPile discard:[CanastaCard newWithRank:TWO suit:CLUBS]];
            [[[discardPile freezingCard] should] equal:[CanastaCard newWithRank:TWO suit:CLUBS]];
            
            [discardPile discard:[CanastaCard newWithRank:SEVEN suit:HEARTS]];
            [[[discardPile freezingCard] should] equal:[CanastaCard newWithRank:TWO suit:CLUBS]];
        });
        
        it(@"allows taking the pile", ^{
            [discardPile discard:[CanastaCard newWithRank:JACK suit:DIAMONDS]];
            
            NSArray *cards = [discardPile take];
            
            [[@([cards count]) should] equal:@2];
            [[cards[0] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
            [[cards[1] should] equal:[CanastaCard newWithRank:JACK suit:DIAMONDS]];
            
            [[[discardPile size] should] equal:@0];
        });
    });
});

SPEC_END
