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

@interface CanastaGame : NSObject

- (NSUInteger)teamNumberForPlayer:(NSUInteger)playerNumber;
- (void)meldRank:(RANK)rank cardIndexes:(NSIndexSet *)indexes;
- (void)discard:(NSUInteger)cardIndex;
- (CanastaTeam *)team:(NSUInteger)number;
- (CanastaHand *)hand:(NSUInteger)number;
- (void)draw;

@end

@interface CanastaGame (Properties)
@property (nonatomic, readonly) NSUInteger turn;
@end