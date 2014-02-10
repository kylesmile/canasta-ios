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

+ (instancetype)newWithMeld:(CanastaMeld *)meld {
    return [[self alloc] initWithMeld:meld];
}

- (CanastaCard *)removeTopCard {
    CanastaCard *card = [self.cards lastObject];
    [self.cards removeLastObject];
    return card;
}

- (instancetype)initWithMeld:(CanastaMeld *)meld {
    self = [super init];
    if (self) {
        _meld = meld;
    }
    return self;
}

- (RANK)rank {
    if (self.meld) {
        return [self.meld rank];
    } else {
        return [super rank];
    }
}

@end
