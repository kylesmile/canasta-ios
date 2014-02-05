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

@property (nonatomic) BOOL hasDrawn;

@property (nonatomic, strong, readwrite) CanastaCard *stagedDiscard;
@end

@implementation CanastaGame

#pragma mark - Initialization

- (NSArray *)hands {
    if (!_hands) {
        _hands = @[[CanastaHand new], [CanastaHand new], [CanastaHand new], [CanastaHand new]];
        [self deal];
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

#pragma mark - Game Data

- (NSUInteger)teamNumberForPlayer:(NSUInteger)playerNumber {
    if (playerNumber == 1 || playerNumber == 3) {
        return 1;
    } else {
        return 2;
    }
}

- (CanastaTeam *)team:(NSUInteger)number {
    return self.teams[number - 1];
}

- (CanastaHand *)hand:(NSUInteger)number {
    return self.hands[number - 1];
}

#pragma mark - Helper Methods

- (void)nextTurn {
    self.turn += 1;
    if (self.turn == 5) self.turn = 1;
}

- (void)drawForPlayer:(NSUInteger)player {
    CanastaCard *card = [self.deck draw];
    while ([card isRedThree]) {
        [[self team:[self teamNumberForPlayer:player]] addRedThree:card];
        card = [self.deck draw];
    }
    [[self hand:player] takeCard:card];
}

- (void)deal {
    for (NSInteger i = 0; i < 11; i++) {
        for (NSInteger player = 1; player < 5; player++) {
            [self drawForPlayer:player];
        }
    }
}

#pragma mark - Move Checking

- (BOOL)canDraw {
    return !self.hasDrawn;
}

- (BOOL)turnValid {
    return self.stagedDiscard != nil;
}

#pragma mark - Game Interface

- (void)draw {
    if ([self canDraw]) {
        [self drawForPlayer:self.turn];
        self.hasDrawn = YES;
    }
}

- (void)unstageDiscard {
    [[self hand:self.turn] takeCard:self.stagedDiscard];
    self.stagedDiscard = nil;
}

- (void)stageDiscard:(NSUInteger)index {
    CanastaCard *cardToStage = [[self hand:self.turn] playCard:index];
    if (self.stagedDiscard) [[self hand:self.turn] takeCard:self.stagedDiscard];
    self.stagedDiscard = cardToStage;
}

- (void)finishTurn {
    if ([self turnValid]) {
        [self.discardPile discard:self.stagedDiscard];
        self.stagedDiscard = nil;
        [self nextTurn];
    }
}

//- (void)meldRank:(RANK)rank cardIndexes:(NSIndexSet *)indexes {
//    [[self team:[self teamNumberForPlayer:self.turn]] meldRank:rank cards:[[self hand:self.turn] playCards:indexes]];
//}
//
//- (void)discard:(NSUInteger)cardIndex {
//    CanastaCard *card = [[self hand:self.turn] playCard:cardIndex];
//    [self.discardPile discard:card];
//    [self nextTurn];
//}

@end
