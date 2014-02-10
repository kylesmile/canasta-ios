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
@property (nonatomic, strong) NSMutableArray *stagedMelds;
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

- (NSMutableArray *)stagedMelds {
    if (!_stagedMelds) {
        _stagedMelds = [NSMutableArray new];
    }
    if ([_stagedMelds count] < [[self currentTeam].melds count]) {
        for (NSInteger i = 0; i < [[self currentTeam].melds count]; i++) {
            [_stagedMelds addObject:[CanastaStagedMeld newWithMeld:[self currentTeam].melds[i]]];
        }
    }
    return _stagedMelds;
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

- (NSUInteger)meldSlotCount {
    return [self.stagedMelds count] + 1;
}

- (CanastaStagedMeld *)stagedMeld:(NSUInteger)number {
    return self.stagedMelds[number];
}

- (NSUInteger)stagedScore {
    NSUInteger score = 0;
    
    for (CanastaStagedMeld *meld in self.stagedMelds) {
        for (CanastaCard *card in meld.cards) {
            score += [[card points] integerValue];
        }
    }
    
    return score;
}

#pragma mark - Move Checking

- (BOOL)canDraw {
    if ([[self.deck size] isEqual:@0] || self.hasDrawn) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)turnValid {
    if (self.stagedDiscard == nil) return NO;
    if (!self.hasDrawn) return NO;
    
    for (CanastaStagedMeld *stagedMeld in self.stagedMelds) {
        if (!stagedMeld.meld && [[stagedMeld size] integerValue] < 3) return NO;
    }
    
    return YES;
}

- (BOOL)canStageMeld:(NSUInteger)meld cardIndex:(NSUInteger)index {
    CanastaCard *card = [self currentHand].cards[index];
    
    if (meld + 1 == [self meldSlotCount] && [card isWild]) return NO;
    if ([card isWild]) return YES;
    
    if ([card isBlackThree]) return NO;
    if (meld + 1 > [self meldSlotCount]) return NO;
    
    if (meld + 1 < [self meldSlotCount]) {
        if ([self.stagedMelds[meld] rank] != card.rank) return NO;
    }
    
    for (NSInteger i = 0; i < [self meldSlotCount] - 1; i++) {
        if (i != meld) {
            if ([self.stagedMelds[i] rank] == card.rank) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - Game Interface

- (void)draw {
    if ([self canDraw]) {
        [self drawForPlayer:self.turn];
        self.hasDrawn = YES;
        [self notify:@"hands changed"];
    }
}

- (void)unstageDiscard {
    [[self currentHand] takeCard:self.stagedDiscard];
    self.stagedDiscard = nil;
}

- (void)stageDiscard:(NSUInteger)index {
    CanastaCard *cardToStage = [[self currentHand] playCard:index];
    if (self.stagedDiscard) [[self currentHand] takeCard:self.stagedDiscard];
    self.stagedDiscard = cardToStage;
}

- (void)stageMeld:(NSUInteger)meld cardIndex:(NSUInteger)index {
    if ([self canStageMeld:meld cardIndex:index]) {
        if (meld + 1 == [self meldSlotCount]) {
            [self.stagedMelds addObject:[CanastaStagedMeld new]];
        }
        
        CanastaCard *meldCard = [[self currentHand] playCard:index];
        
        [self.stagedMelds[meld] addCard:meldCard];
        
        [self notify:@"staged melds changed"];
    }
}

- (void)unstageTopCardInMeld:(NSUInteger)meld {
    CanastaStagedMeld *stagedMeld = self.stagedMelds[meld];
    
    if ([[stagedMeld size] integerValue] > 0) {
        CanastaCard *card = [stagedMeld removeTopCard];
        [[self currentHand] takeCard:card];
        
        if ([[stagedMeld size] isEqual:@0] && meld + 1 > [[self currentTeam].melds count]) {
            [self.stagedMelds removeObjectAtIndex:meld];
        }
        
        [self notify:@"staged melds changed"];
    }
}

- (void)finishTurn {
    if ([self turnValid]) {
        [self.discardPile discard:self.stagedDiscard];
        
        CanastaTeam *team = [self currentTeam];
        
        for (CanastaStagedMeld *meld in self.stagedMelds) {
            [team meldRank:[meld rank] cards:meld.cards];
        }
        
        [self.stagedMelds removeAllObjects];
        
        self.stagedDiscard = nil;
        self.hasDrawn = NO;
        [self nextTurn];
        
        [self notify:@"discard pile changed"];
        [self notify:@"new turn"];
    }
}

#pragma mark - Helper Methods

- (void)nextTurn {
    self.turn += 1;
    if (self.turn == 5) self.turn = 1;
}

- (void)drawForPlayer:(NSUInteger)player {
    CanastaCard *card = [self.deck draw];
    while ([card isRedThree]) {
        [self notify:@"new red three"];
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

- (void)notify:(NSString *)name {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:name object:self];
}

- (CanastaHand *)currentHand {
    return [self hand:self.turn];
}

- (CanastaTeam *)currentTeam {
    return [self team:[self teamNumberForPlayer:self.turn]];
}

@end
