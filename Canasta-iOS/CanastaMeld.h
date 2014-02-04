//
//  CanastaMeld.h
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaCard.h"

@interface CanastaMeld : NSObject

+ (instancetype)newWithCards:(NSArray *)cards;

- (instancetype)initWithCards:(NSArray *)cards;

- (NSNumber *)size;
- (void)addCard:(CanastaCard *)card;
- (void)addCards:(NSArray *)cards;

- (BOOL)isNatural;
- (BOOL)isMixed;
- (BOOL)isCanasta;

- (RANK)rank;

@end

@interface CanastaMeld (Properties)
@property (nonatomic, strong, readonly) NSArray *cards;
@end
