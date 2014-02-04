//
//  CardDeck.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/23/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaDeck.h"

@interface CanastaDeck()
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CanastaDeck


- (id)init {
    self = [super init];
    if (self) {
        _cards = [NSMutableArray new];
        for (NSUInteger i = 0; i < 2; i++) {
            for (RANK rank = TWO; rank < JOKER; rank++) {
                for (SUIT suit = SPADES; suit < REDJOKER; suit++) {
                    [self.cards addObject:[CanastaCard newWithRank:rank suit:suit]];
                }
            }
            [self.cards addObject:[CanastaCard newJoker:BLACK]];
            [self.cards addObject:[CanastaCard newJoker:RED]];
        }
    }
    return self;
}

- (NSNumber *)size {
    return @([self.cards count]);
}

- (CanastaCard *)draw {
    CanastaCard *card = [self.cards lastObject];
    [self.cards removeLastObject];
    return card;
}

- (NSArray *)draw:(NSUInteger)count {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.cards count] - 1 - count, count)];
    NSArray *cards = [self.cards objectsAtIndexes:indexes];
    [self.cards removeObjectsAtIndexes:indexes];
    
    return cards;
}

- (void)shuffle {
    NSUInteger count = [self.cards count];
    
    for (NSUInteger i = 0; i < count; i++) {
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [self.cards exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
