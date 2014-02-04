//
//  CanastaTeam.h
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CanastaCard.h"
#import "CanastaMeld.h"

@interface CanastaTeam : NSObject

- (NSNumber *)meldCount;
- (void)meldRank:(RANK)rank cards:(NSArray *)cards;
- (BOOL)hasMeldWithRank:(RANK)rank;
- (CanastaMeld *)meldForRank:(RANK)rank;
- (NSNumber *)redThreeCount;
- (void)addRedThree:(CanastaCard *)card;

- (NSNumber *)roundScore;

@end

@interface CanastaTeam (Properties)
@property (nonatomic, strong, readonly) NSArray *melds;
@end
