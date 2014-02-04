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
    [_cards addObject:card];
}

- (void)takeCards:(NSArray *)cards {
    [_cards addObjectsFromArray:cards];
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
