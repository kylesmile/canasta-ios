//
//  CanastaMeldTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaMeld.h"

SPEC_BEGIN(CanastaMeldTests);

describe(@"Canasta Meld", ^{
    __block CanastaMeld *meld;
    beforeEach(^{
        meld = [CanastaMeld newWithCards:@[[CanastaCard newWithRank:SEVEN suit:HEARTS],
                                           [CanastaCard newWithRank:SEVEN suit:SPADES],
                                           [CanastaCard newWithRank:SEVEN suit:CLUBS]]];
    });
    
    it(@"knows its size", ^{
        [[[meld size] should] equal:@3];
    });
    
    it(@"can add more cards", ^{
        [meld addCard:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
        [[[meld size] should] equal:@4];
        
        [[meld.cards should] containObjects:[CanastaCard newWithRank:SEVEN suit:HEARTS],
         [CanastaCard newWithRank:SEVEN suit:SPADES],
         [CanastaCard newWithRank:SEVEN suit:CLUBS], [CanastaCard newWithRank:SEVEN suit:DIAMONDS], nil];
    });
    
    it(@"can be natural or mixed", ^{
        [[@([meld isNatural]) should] beYes];
        [[@([meld isMixed]) should] beNo];
        
        [meld addCard:[CanastaCard newWithRank:TWO suit:HEARTS]];
        
        [[@([meld isNatural]) should] beNo];
        [[@([meld isMixed]) should] beYes];
    });
    
    it(@"has a rank", ^{
        [[@([meld rank]) should] equal:@(SEVEN)];
        
        NSArray *cards = @[[CanastaCard newJoker:BLACK], [CanastaCard newWithRank:TWO suit:HEARTS], [CanastaCard newWithRank:NINE suit:SPADES], [CanastaCard newWithRank:NINE suit:HEARTS]];
        CanastaMeld *meld2 = [CanastaMeld newWithCards:cards];
        
        [[@([meld2 rank]) should] equal:@(NINE)];
    });
    
    it(@"can be a Canasta", ^{
        [meld addCards:@[[CanastaCard newWithRank:SEVEN suit:HEARTS],
                         [CanastaCard newWithRank:SEVEN suit:DIAMONDS],
                         [CanastaCard newWithRank:SEVEN suit:CLUBS],
                         [CanastaCard newWithRank:SEVEN suit:DIAMONDS]]];
        
        [[[meld size] should] equal:@7];
        [[@([meld isCanasta]) should] beYes];
        
        [meld addCard:[CanastaCard newWithRank:SEVEN suit:SPADES]];
        
        [[[meld size] should] equal:@8];
        [[@([meld isCanasta]) should] beYes];
    });
});

SPEC_END