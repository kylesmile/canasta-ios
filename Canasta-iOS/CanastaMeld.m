//
//  CanastaMeld.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaMeld.h"

@interface CanastaMeld()
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation CanastaMeld

+ (instancetype)newWithCards:(NSArray *)cards {
    return [[self alloc] initWithCards:cards];
}

- (instancetype)initWithCards:(NSArray *)cards {
    self = [super init];
    if (self) {
        _cards = [cards mutableCopy];
    }
    return self;
}

- (NSNumber *)size {
    return @([self.cards count]);
}

- (void)addCard:(CanastaCard *)card {
    [self.cards addObject:card];
}

- (void)addCards:(NSArray *)cards {
    [self.cards addObjectsFromArray:cards];
}

- (BOOL)isNatural {
    return ![self isMixed];
}

- (BOOL)isMixed {
    for (CanastaCard *card in self.cards) {
        if ([card isWild]) return YES;
    }
    return NO;
}

- (BOOL)isCanasta {
    return [self.cards count] >= 7;
}

- (RANK)rank {
    for (CanastaCard *card in self.cards) {
        if (![card isWild]) return card.rank;
    }
    return JOKER;
}

@end
