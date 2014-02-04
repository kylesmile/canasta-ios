//
//  CardDeck.h
//  CanastaModel
//
//  Created by Kyle Smith on 1/23/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaCard.h"

@interface CanastaDeck : NSObject

- (NSNumber *)size;
- (CanastaCard *)draw;
- (NSArray *)draw:(NSUInteger)count;
- (void)shuffle;

@end
