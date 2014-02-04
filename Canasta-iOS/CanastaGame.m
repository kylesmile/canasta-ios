//
//  CanastaGame.m
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaGame.h"
#import "CanastaDeck.h"

@interface CanastaGame ()
@property (nonatomic, strong) NSArray *hands;
@property (nonatomic, strong) CanastaDeck *deck;
@property (nonatomic, strong, readwrite) CanastaDiscardPile *discardPile;
@property (nonatomic, strong) NSArray *teams;
@property (nonatomic, readwrite) NSUInteger turn;
@end

@implementation CanastaGame

- (NSArray *)hands {
    if (!_hands) {
        _hands = @[[CanastaHand new], [CanastaHand new], [CanastaHand new], [CanastaHand new]];
        for (CanastaHand *hand in _hands) {
            [hand takeCards:[self.deck draw:11]];
        }
    }
    return _hands;
}

- (NSArray *)teams {
    if(!_teams) {
        _teams = @[[CanastaTeam new], [CanastaTeam new]];
    }
    return _teams;
}

- (CanastaDeck *)deck {
    if(!_deck) {
        _deck = [CanastaDeck new];
        [_deck shuffle];
    }
    return _deck;
}

- (CanastaDiscardPile *)discardPile {
    if(!_discardPile) {
        _discardPile = [CanastaDiscardPile new];
        [_discardPile discard:[self.deck draw]];
    }
    return _discardPile;
}

- (NSUInteger)turn {
    if(!_turn) {
        _turn = 1;
    }
    return _turn;
}

- (NSUInteger)teamNumberForPlayer:(NSUInteger)playerNumber {
    if (playerNumber == 1 || playerNumber == 3) {
        return 1;
    } else {
        return 2;
    }
}

- (void)meldRank:(RANK)rank cardIndexes:(NSIndexSet *)indexes {
    [[self team:[self teamNumberForPlayer:self.turn]] meldRank:rank cards:[[self hand:self.turn] playCards:indexes]];
}

- (void)discard:(NSUInteger)cardIndex {
    CanastaCard *card = [[self hand:self.turn] playCard:cardIndex];
    [self.discardPile discard:card];
    [self nextTurn];
}

- (void)nextTurn {
    self.turn += 1;
    if (self.turn == 5) self.turn = 1;
}

- (CanastaTeam *)team:(NSUInteger)number {
    return self.teams[number - 1];
}

- (CanastaHand *)hand:(NSUInteger)number {
    return self.hands[number - 1];
}

- (void)draw {
    [[self hand:self.turn] takeCard:[self.deck draw]];
}

@end
