//
//  CanastaGame.h
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaCard.h"
#import "CanastaTeam.h"
#import "CanastaHand.h"
#import "CanastaDiscardPile.h"
#import "CanastaStagedMeld.h"

@interface CanastaGame : NSObject

- (NSUInteger)teamNumberForPlayer:(NSUInteger)playerNumber;
- (CanastaTeam *)team:(NSUInteger)number;
- (CanastaHand *)hand:(NSUInteger)number;
- (NSUInteger)meldSlotCount;
- (CanastaStagedMeld *)stagedMeld:(NSUInteger)number;
- (NSUInteger)stagedScore;

- (BOOL)canDraw;
- (BOOL)canStageMeld:(NSUInteger)meld cardIndex:(NSUInteger)index;
- (BOOL)turnValid;

- (void)draw;
- (void)unstageDiscard;
- (void)stageDiscard:(NSUInteger)index;
- (void)stageMeld:(NSUInteger)meld cardIndex:(NSUInteger)index;
- (void)unstageTopCardInMeld:(NSUInteger)meld;
- (void)finishTurn;
@end

@interface CanastaGame (Properties)
@property (nonatomic, readonly) NSUInteger turn;
@property (nonatomic, readonly) CanastaDiscardPile *discardPile;

@property (nonatomic, strong, readonly) CanastaCard *stagedDiscard;
@end