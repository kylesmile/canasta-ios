//
//  CanastaGame.h
//  CanastaModel
//
//  Created by Kyle Smith on 2/3/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaGameDelegate.h"
#import "CanastaCard.h"
#import "CanastaTeam.h"
#import "CanastaHand.h"
#import "CanastaDiscardPile.h"

@interface CanastaGame : NSObject

@property (nonatomic, weak) id <CanastaGameDelegate> delegate;

- (NSUInteger)teamNumberForPlayer:(NSUInteger)playerNumber;
//- (void)meldRank:(RANK)rank cardIndexes:(NSIndexSet *)indexes;
//- (void)discard:(NSUInteger)cardIndex;
- (CanastaTeam *)team:(NSUInteger)number;
- (CanastaHand *)hand:(NSUInteger)number;

- (BOOL)canDraw;
- (BOOL)turnValid;
- (BOOL)canStageMeld:(NSUInteger)meld cardIndex:(NSUInteger)index;
- (NSUInteger)meldSlotCount;

- (void)draw;
- (void)unstageDiscard;
- (void)stageDiscard:(NSUInteger)index;
- (void)stageMeld:(NSUInteger)meld cardIndex:(NSUInteger)index;
- (void)finishTurn;

- (void)gimmeANotification;
@end

@interface CanastaGame (Properties)
@property (nonatomic, readonly) NSUInteger turn;
@property (nonatomic, readonly) CanastaDiscardPile *discardPile;

@property (nonatomic, strong, readonly) CanastaCard *stagedDiscard;
@end