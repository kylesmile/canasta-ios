//
//  CanastaTeamTests.m
//  CanastaModel
//
//  Created by Kyle Smith on 1/24/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "Kiwi.h"
#import "CanastaTeam.h"
#import "CanastaCard.h"

SPEC_BEGIN(CanastaTeamTests)

describe(@"Canasta Team", ^{
    __block CanastaTeam *team;
    
    beforeEach(^{
        team = [CanastaTeam new];
    });
    
    it(@"has melds", ^{
        [[[team meldCount] should] equal:@0];
        
        [[[team.melds should] have:0] items];
        
        [team meldRank:ACE cards:@[[CanastaCard newWithRank:ACE suit:SPADES], [CanastaCard newWithRank:ACE suit:DIAMONDS], [CanastaCard newWithRank:ACE suit:SPADES]]];
        
        [[[team meldCount] should] equal:@1];
        [[@([team hasMeldWithRank:ACE]) should] beYes];
        
        [team meldRank:ACE cards:@[[CanastaCard newJoker:BLACK]]];
        
        [[[team meldCount] should] equal:@1];
    });
    
    it(@"keeps track of its red threes", ^{
        [[[team redThreeCount] should] equal:@0];
        
        [team addRedThree:[CanastaCard newWithRank:THREE suit:DIAMONDS]];
        [[[team redThreeCount] should] equal:@1];
        
        [team addRedThree:[CanastaCard newWithRank:THREE suit:HEARTS]];
        [[[team redThreeCount] should] equal:@2];
        
        [team addRedThree:[CanastaCard newWithRank:SEVEN suit:CLUBS]];
        [[[team redThreeCount] should] equal:@2];
    });
    
    context(@"with melds in place", ^{
        beforeEach(^{
            [team meldRank:FIVE cards:@[[CanastaCard newWithRank:FIVE suit:SPADES], [CanastaCard newWithRank:FIVE suit:DIAMONDS], [CanastaCard newWithRank:FIVE suit:SPADES]]];
        });
        
        it(@"knows its score for the current round", ^{
            [[[team roundScore] should] equal:@15];
            
            [team meldRank:FIVE cards:@[[CanastaCard newJoker:BLACK]]];
            [[[team roundScore] should] equal:@65];
            
            [team meldRank:ACE cards:@[[CanastaCard newWithRank:ACE suit:SPADES], [CanastaCard newWithRank:ACE suit:DIAMONDS], [CanastaCard newWithRank:ACE suit:CLUBS]]];
            [[[team roundScore] should] equal:@125];
        });
    });
});

SPEC_END