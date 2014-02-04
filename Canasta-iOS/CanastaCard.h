//
//  CanastaCard.h
//  CanastaModel
//
//  Created by Kyle Smith on 1/23/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    TWO,
    THREE,
    FOUR,
    FIVE,
    SIX,
    SEVEN,
    EIGHT,
    NINE,
    TEN,
    JACK,
    QUEEN,
    KING,
    ACE,
    JOKER
};
typedef NSUInteger RANK;

enum {
    SPADES,
    CLUBS,
    HEARTS,
    DIAMONDS,
    REDJOKER,
    BLACKJOKER
};
typedef NSUInteger SUIT;

enum {
    RED,
    BLACK
};
typedef NSUInteger COLOR;


@interface CanastaCard : NSObject

@property (nonatomic, readonly) RANK rank;
@property (nonatomic, readonly) SUIT suit;

+ (instancetype)newWithRank:(RANK)rank suit:(SUIT)suit;
+ (instancetype)newJoker:(COLOR)color;

- (instancetype)initWithRank:(RANK)rank suit:(SUIT)suit;
- (instancetype)initJoker:(COLOR)color;

- (COLOR)color;
- (NSNumber *)points;
- (BOOL)isNatural;
- (BOOL)isWild;
- (BOOL)isRedThree;
- (BOOL)isBlackThree;
- (BOOL)isEqualToCard:(CanastaCard *)other;

@end
