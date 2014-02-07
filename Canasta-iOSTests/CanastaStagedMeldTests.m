//
//  CanastaStagedMeldTests.m
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/6/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaStagedMeld.h"

SPEC_BEGIN(CansataStagedMeldTests)

describe(@"Canasta Staged Meld", ^{
    it(@"allows removing the top card", ^{
        CanastaStagedMeld *stagedMeld = [CanastaStagedMeld newWithCards:@[[CanastaCard newWithRank:ACE suit:SPADES]]];
        
        [stagedMeld addCard:[CanastaCard newWithRank:ACE suit:DIAMONDS]];
        [stagedMeld addCards:@[[CanastaCard newWithRank:ACE suit:HEARTS]]];
        
        CanastaCard *card = [stagedMeld removeTopCard];
        
        [[card should] equal:[CanastaCard newWithRank:ACE suit:HEARTS]];
    });
});

SPEC_END
