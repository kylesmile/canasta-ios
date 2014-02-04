//
//  CanastaHand.h
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaCard.h"

@interface CanastaHand : NSObject

- (NSNumber *)size;
- (void)takeCard:(CanastaCard *)card;
- (void)takeCards:(NSArray *)cards;
- (CanastaCard *)playCard:(NSUInteger)index;
- (NSArray *)playCards:(NSIndexSet *)indexes;

@end

@interface CanastaHand (Properties)
@property (nonatomic, strong, readonly) NSArray *cards;
@end