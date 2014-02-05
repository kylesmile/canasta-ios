//
//  CanastaCardTests.m
//  CanastaCardTests
//
//  Created by Kyle Smith on 1/23/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaCard.h"

SPEC_BEGIN(CanastaCardTests);

describe(@"Canasta Card", ^{
    it(@"has a rank and a suit", ^{
        CanastaCard *ace = [CanastaCard newWithRank:ACE suit:SPADES];
        [[@(ace.rank) should] equal:@(ACE)];
        [[@(ace.suit) should] equal:@(SPADES)];
    });
    
    it(@"has a color", ^{
        CanastaCard *heartCard = [CanastaCard newWithRank:ACE suit:HEARTS];
        CanastaCard *diamondCard = [CanastaCard newWithRank:ACE suit:DIAMONDS];
        CanastaCard *clubCard = [CanastaCard newWithRank:ACE suit:CLUBS];
        CanastaCard *spadeCard = [CanastaCard newWithRank:ACE suit:SPADES];
        [[@(heartCard.color) should] equal:@(RED)];
        [[@(diamondCard.color) should] equal:@(RED)];
        [[@(clubCard.color) should] equal:@(BLACK)];
        [[@(spadeCard.color) should] equal:@(BLACK)];
    });
    
    it(@"can be a joker", ^{
        CanastaCard *redJoker = [CanastaCard newJoker:RED];
        CanastaCard *blackJoker = [CanastaCard newJoker:BLACK];
        
        [[@(redJoker.color) should] equal:@(RED)];
        [[@(blackJoker.color) should] equal:@(BLACK)];
        
        [[@(redJoker.suit) should] equal:@(REDJOKER)];
        [[@(blackJoker.suit) should] equal:@(BLACKJOKER)];
        
        [[@(redJoker.rank) should] equal:@(JOKER)];
        [[@(blackJoker.rank) should] equal:@(JOKER)];
    });
    
    it(@"has a point value", ^{
        CanastaCard *joker = [CanastaCard newJoker:RED];
        CanastaCard *ace = [CanastaCard newWithRank:ACE suit:SPADES];
        CanastaCard *two = [CanastaCard newWithRank:TWO suit:CLUBS];
        CanastaCard *king = [CanastaCard newWithRank:KING suit:HEARTS];
        CanastaCard *eight = [CanastaCard newWithRank:EIGHT suit:SPADES];
        CanastaCard *seven = [CanastaCard newWithRank:SEVEN suit:DIAMONDS];
        CanastaCard *four = [CanastaCard newWithRank:FOUR suit:HEARTS];
        CanastaCard *redThree = [CanastaCard newWithRank:THREE suit:HEARTS];
        CanastaCard *blackThree = [CanastaCard newWithRank:THREE suit:CLUBS];
        
        [[[joker points] should] equal:@50];
        [[[ace points] should] equal:@20];
        [[[two points] should] equal:@20];
        [[[king points] should] equal:@10];
        [[[eight points] should] equal:@10];
        [[[seven points] should] equal:@5];
        [[[four points] should] equal:@5];
        [[[redThree points] should] equal:@0];
        [[[blackThree points] should] equal:@5];
    });
    
    it(@"can be wild or natural", ^{
        CanastaCard *joker = [CanastaCard newJoker:RED];
        CanastaCard *two = [CanastaCard newWithRank:TWO suit:CLUBS];
        CanastaCard *seven = [CanastaCard newWithRank:SEVEN suit:HEARTS];
        
        [[@([joker isNatural]) should] beNo];
        [[@([joker isWild]) should] beYes];
        [[@([two isNatural]) should] beNo];
        [[@([two isWild]) should] beYes];
        [[@([seven isNatural]) should] beYes];
        [[@([seven isWild]) should] beNo];
    });
    
    it(@"can be a red or black three", ^{
        CanastaCard *seven = [CanastaCard newWithRank:SEVEN suit:CLUBS];
        CanastaCard *redThree = [CanastaCard newWithRank:THREE suit:DIAMONDS];
        CanastaCard *blackThree = [CanastaCard newWithRank:THREE suit:SPADES];
        
        [[@([seven isRedThree]) should] beNo];
        [[@([seven isBlackThree]) should] beNo];
        [[@([redThree isRedThree]) should] beYes];
        [[@([redThree isBlackThree]) should] beNo];
        [[@([blackThree isRedThree]) should] beNo];
        [[@([blackThree isBlackThree]) should] beYes];
    });
    
    describe(@"equality", ^{
        __block CanastaCard *card1, *card2;
        
        beforeEach(^{
            card1 = [CanastaCard newWithRank:THREE suit:HEARTS];
            card2 = [CanastaCard newWithRank:THREE suit:HEARTS];
        });
        
        it(@"can be compared using isEqual:", ^{
            [[@([card1 isEqualToCard:card2]) should] beYes];
            [[card1 should] equal:card2];
            [[card1 shouldNot] equal:@"Thing"];
        });
        
        it(@"properly defines hash", ^{
            CanastaCard *differentCard = [CanastaCard newWithRank:SEVEN suit:DIAMONDS];
            
            [[@([card1 hash]) should] equal:@([card2 hash])];
            [[@([differentCard hash]) shouldNot] equal:@([card1 hash])];

        });
    });
    
    it(@"has a string representation", ^{
        CanastaCard *redJoker = [CanastaCard newJoker:RED];
        CanastaCard *blackJoker = [CanastaCard newJoker:BLACK];
        CanastaCard *aceOfSpades = [CanastaCard newWithRank:ACE suit:SPADES];
        CanastaCard *sevenOfClubs = [CanastaCard newWithRank:SEVEN suit:CLUBS];
        
        [[[redJoker description] should] equal:@"Red Joker"];
        [[[blackJoker description] should] equal:@"Black Joker"];
        [[[aceOfSpades description] should] equal:@"Ace of Spades"];
        [[[sevenOfClubs description] should] equal:@"7 of Clubs"];
    });
});

SPEC_END