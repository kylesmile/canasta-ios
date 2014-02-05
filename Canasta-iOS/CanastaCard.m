//
//  CanastaCard.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/23/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaCard.h"

@implementation CanastaCard

+ (instancetype)newWithRank:(RANK)rank suit:(SUIT)suit {
    return [[self alloc] initWithRank:rank suit:suit];
}

+ (instancetype)newJoker:(COLOR)color {
    return [[self alloc] initJoker:color];
}


- (instancetype)initWithRank:(RANK)rank suit:(SUIT)suit {
    self = [super init];
    if (self) {
        _rank = rank;
        _suit = suit;
    }
    return self;
}

- (instancetype)initJoker:(COLOR)color {
    self = [super init];
    if (self) {
        _rank = JOKER;
        _suit = color + 4;
    }
    return self;
}

- (COLOR)color {
    if (self.suit == CLUBS || self.suit == SPADES || self.suit == BLACKJOKER) {
        return BLACK;
    } else {
        return RED;
    }
}

- (NSNumber *)points {
    if (self.rank == JOKER) return @50;
    if (self.rank == ACE || self.rank == TWO) return @20;
    if (self.rank > SEVEN) return @10;
    if (self.rank > THREE) return @5;
    if (self.rank == THREE && self.color == BLACK) return @5;
    return @0;
}

- (BOOL)isEqualToCard:(CanastaCard *)other {
    return self.rank == other.rank && self.suit == other.suit;
}

- (BOOL)isEqual:(id)object {
    return (self == object) || ([self isKindOfClass:[object class]] && [self isEqualToCard:object]);
}

- (NSUInteger)hash {
    return [@(self.rank) hash] ^ [@(self.suit) hash];
}

- (BOOL)isNatural {
    return ![self isWild];
}

- (BOOL)isWild {
    return self.rank == JOKER || self.rank == TWO;
}

- (BOOL)isRedThree {
    return self.rank == THREE && self.color == RED;
}

- (BOOL)isBlackThree {
    return self.rank == THREE && self.color == BLACK;
}

- (NSString *)description {
    NSArray *rankNames = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"Jack", @"Queen", @"King", @"Ace", @"Joker"];
    NSArray *suitNames = @[@"Spades", @"Clubs", @"Hearts", @"Diamonds", @"Red", @"Black"];
    if (self.rank == JOKER) {
        return [NSString stringWithFormat:@"%@ %@", suitNames[self.suit], rankNames[self.rank]];
    } else {
        return [NSString stringWithFormat:@"%@ of %@", rankNames[self.rank], suitNames[self.suit]];
    }
}

@end
