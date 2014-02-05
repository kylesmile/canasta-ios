//
//  CanastaHand.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaHand.h"

@interface CanastaHand ()
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation CanastaHand

- (id)init {
    self = [super init];
    if (self) {
        _cards = [NSMutableArray new];
    }
    return self;
}

- (NSNumber *)size {
    return @([self.cards count]);
}

- (void)takeCard:(CanastaCard *)card {
    [self.cards addObject:card];
    [self sortHand];
}

- (void)takeCards:(NSArray *)cards {
    [self.cards addObjectsFromArray:cards];
    [self sortHand];
}

- (void)sortHand {
    [self.cards sortUsingComparator:^NSComparisonResult(CanastaCard *card1, CanastaCard *card2){
        if (card1.rank > card2.rank) return NSOrderedDescending;
        if (card1.rank < card2.rank) return NSOrderedAscending;
        return NSOrderedSame;
    }];
}

- (CanastaCard *)playCard:(NSUInteger)index {
    CanastaCard *card = self.cards[index];
    [self.cards removeObjectAtIndex:index];
    return card;
}

- (NSArray *)playCards:(NSIndexSet *)indexes {
    NSArray *cards = [self.cards objectsAtIndexes:indexes];
    [self.cards removeObjectsAtIndexes:indexes];
    return cards;
}

@end
