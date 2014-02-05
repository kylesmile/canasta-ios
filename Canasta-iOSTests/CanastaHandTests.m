//
//  CanastaHandTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaHand.h"

SPEC_BEGIN(CanastaHandTests)

describe(@"Canasta Hand", ^{
    __block CanastaHand *hand;
    
    beforeEach(^{
        hand = [CanastaHand new];
    });
    
    it(@"knows its size", ^{
        [[[hand size] should] equal:@0];
    });
    
    it(@"can take cards", ^{
        [hand takeCard:[CanastaCard newWithRank:THREE suit:CLUBS]];
        [[[hand size] should] equal:@1];
        
        [hand takeCards:@[[CanastaCard newJoker:RED], [CanastaCard newWithRank:ACE suit:SPADES]]];
        
        [[[hand size] should] equal:@3];
        
        [[hand.cards[0] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
    });
    
    context(@"already containing cards", ^{
        beforeEach(^{
            [hand takeCards:@[[CanastaCard newWithRank:THREE suit:CLUBS], [CanastaCard newJoker:RED], [CanastaCard newWithRank:ACE suit:SPADES]]];
        });
        
        it(@"sorts its cards", ^{
            [hand takeCards:@[[CanastaCard newWithRank:TWO suit:SPADES], [CanastaCard newWithRank:EIGHT suit:DIAMONDS], [CanastaCard newWithRank:SIX suit:CLUBS], [CanastaCard newWithRank:KING suit:HEARTS]]];
            
            [[hand.cards[0] should] equal:[CanastaCard newWithRank:TWO suit:SPADES]];
            [[hand.cards[1] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
            [[hand.cards[2] should] equal:[CanastaCard newWithRank:SIX suit:CLUBS]];
            [[hand.cards[3] should] equal:[CanastaCard newWithRank:EIGHT suit:DIAMONDS]];
            [[hand.cards[4] should] equal:[CanastaCard newWithRank:KING suit:HEARTS]];
            [[hand.cards[5] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
            [[hand.cards[6] should] equal:[CanastaCard newJoker:RED]];
        });
        
        it(@"can play cards", ^{
            CanastaCard *card = [hand playCard:2];
            
            [[card should] equal:[CanastaCard newJoker:RED]];
            
            [[[hand size] should] equal:@2];
            
            [hand takeCards:@[[CanastaCard newJoker:BLACK], [CanastaCard newWithRank:SEVEN suit:DIAMONDS]]];
            
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:1];
            [indexes addIndex:2];
            NSArray *cards = [hand playCards:indexes];
            [[cards[0] should] equal:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
            [[cards[1] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
            
            [[[hand size] should] equal:@2];
        });
    });
});

SPEC_END