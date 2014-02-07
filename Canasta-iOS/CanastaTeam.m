//
//  CanastaTeam.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "CanastaTeam.h"

@interface CanastaTeam ()
@property (nonatomic, strong, readwrite) NSMutableArray *melds;
@property (nonatomic, strong, readwrite) NSMutableArray *redThrees;
@end

@implementation CanastaTeam

- (id)init {
    self = [super init];
    if (self) {
        _melds = [NSMutableArray new];
        _redThrees = [NSMutableArray new];
    }
    return self;
}

- (NSNumber *)meldCount {
    return @([self.melds count]);
}

- (void)meldRank:(RANK)rank cards:(NSArray *)cards {
    CanastaMeld *meld = [self meldForRank:rank];
    
    if (meld) {
        [meld addCards:cards];
    } else {
        meld = [CanastaMeld newWithCards:cards];
        [self.melds addObject:meld];
    }
}

- (BOOL)hasMeldWithRank:(RANK)rank {
    return [self meldForRank:rank] != nil;
}

- (CanastaMeld *)meldForRank:(RANK)rank {
    for (CanastaMeld *meld in self.melds) {
        if ([meld rank] == rank) return meld;
    }
    return nil;
}

- (NSNumber *)redThreeCount {
    return @([self.redThrees count]);
}

- (void)addRedThree:(CanastaCard *)card {
    if ([card isRedThree]) [self.redThrees addObject:card];
}

- (NSNumber *)roundScore {
    NSNumber *score = @0;
    
    for (CanastaMeld *meld in self.melds) {
        for (CanastaCard *card in meld.cards) {
            score = @([score integerValue] + [card.points integerValue]);
        }
    }
    
    return score;
}

@end
