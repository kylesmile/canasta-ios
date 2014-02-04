//
//  CardDeckTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/23/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaDeck.h"

@interface CanastaDeck (Testing)
@property (nonatomic, strong) NSArray *cards;
@end

SPEC_BEGIN(CanastaDeckTests);

describe(@"Canasta Deck", ^{
    __block CanastaDeck *deck;
    
    beforeEach(^{
        deck = [CanastaDeck new];
    });
    
    it(@"should have 108 cards", ^{
        [[[deck size] should] equal:@108];
    });
    
    it(@"allows drawing cards", ^{
        CanastaCard *card = [deck draw];
        [[card shouldNot] beNil];
        [[card should] beKindOfClass:[CanastaCard class]];
        [[[deck size] should] equal:@107];
    });
    
    it(@"allows drawing several cards at once", ^{
        [[[deck size] should] equal:@108];
        
        NSArray *cards = [deck draw:10];
        
        [[@([cards count]) should] equal:@10];
        
        [[[deck size] should] equal:@98];
    });
    
    it(@"can be shuffled", ^{
        [[@([deck respondsToSelector:@selector(shuffle)]) should] beYes];
        
        CanastaDeck *shuffledDeck = [CanastaDeck new];
        [shuffledDeck shuffle];
        
        NSUInteger i;
        
        for (i = 0; i < 108; i++) {
            if (![deck.cards[i] isEqualToCard:shuffledDeck.cards[i]]) break;
        }
        
        [[@(i) shouldNot] equal:@(108)];
    });
});

SPEC_END