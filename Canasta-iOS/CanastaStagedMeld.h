//
//  CanastaStagedMeld.h
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/6/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaMeld.h"

@interface CanastaStagedMeld : CanastaMeld

+ (instancetype)newWithMeld:(CanastaMeld *)meld;

- (CanastaCard *)removeTopCard;
- (instancetype)initWithMeld:(CanastaMeld *)meld;

@property (nonatomic, strong) CanastaMeld *meld;

@end
