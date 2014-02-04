//
//  CanastaDiscardPile.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaDiscardPile.h"

@interface CanastaDiscardPile()
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CanastaDiscardPile

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

- (void)discard:(CanastaCard *)card {
    [self.cards addObject:card];
}

- (CanastaCard *)topCard {
    return [self.cards lastObject];
}

- (BOOL)isFrozen {
    for (CanastaCard *card in self.cards) {
        if ([card isWild] || [card isRedThree]) return YES;
    }
    return NO;
}

- (CanastaCard *)freezingCard {
    CanastaCard *freezer = nil;
    for (CanastaCard *card in self.cards) {
        if ([card isWild] || [card isRedThree]) freezer = card;
    }
    return freezer;
}

- (BOOL)isLocked {
    CanastaCard *topCard = self.topCard;
    if ([topCard isBlackThree] || [topCard isWild] || [topCard isRedThree]) return YES;
    return NO;
}

- (NSArray *)take {
    NSArray *cards = [self.cards copy];
    [self.cards removeAllObjects];
    return cards;
}

@end
