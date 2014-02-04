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
    
    beforeAll(^{
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
        
        [[[hand cards][0] should] equal:[CanastaCard newWithRank:THREE suit:CLUBS]];
    });
    
    it(@"can play cards", ^{
        CanastaCard *card = [hand playCard:1];
        
        [[card should] equal:[CanastaCard newJoker:RED]];
        
        [[[hand size] should] equal:@2];
        
        [hand takeCards:@[[CanastaCard newJoker:BLACK], [CanastaCard newWithRank:SEVEN suit:DIAMONDS]]];
        
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:1];
        [indexes addIndex:3];
        NSArray *cards = [hand playCards:indexes];
        [[cards[0] should] equal:[CanastaCard newWithRank:ACE suit:SPADES]];
        [[cards[1] should] equal:[CanastaCard newWithRank:SEVEN suit:DIAMONDS]];
        
        [[[hand size] should] equal:@2];
    });
});

SPEC_END