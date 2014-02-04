//
//  CanastaDiscardPile.h
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaCard.h"

@interface CanastaDiscardPile : NSObject

- (NSNumber *)size;
- (void)discard:(CanastaCard *)card;
- (CanastaCard *)topCard;
- (BOOL)isFrozen;
- (CanastaCard *)freezingCard;
- (BOOL)isLocked;
- (NSArray *)take;

@end
