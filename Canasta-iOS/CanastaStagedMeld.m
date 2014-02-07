//
//  CanastaStagedMeld.m
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/6/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaStagedMeld.h"

@interface CanastaMeld ()
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation CanastaStagedMeld

- (CanastaCard *)removeTopCard {
    CanastaCard *card = [self.cards lastObject];
    [self.cards removeLastObject];
    return card;
}

@end
