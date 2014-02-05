//
//  ViewController.m
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/4/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "ViewController.h"
#import "CardCell.h"
#import "CanastaGame.h"
#import "CanastaDumbRobot.h"

@interface ViewController ()
@property (nonatomic, strong) CanastaGame *game;
@property (nonatomic, strong) NSArray *robots;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.handView.dataSource = self;
    self.handView.delegate = self;
    _game = [CanastaGame new];
    self.deckView.image = [UIImage imageNamed:@"backs_blue"];
    [self.freezingCardView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [self reloadDiscardPile];
    _robots = @[[CanastaDumbRobot new], [CanastaDumbRobot new], [CanastaDumbRobot new]];
    for (CanastaDumbRobot *robot in _robots) {
        robot.game = _game;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self.game hand:1] size] integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[self imageNameForCard:[self.game hand:1].cards[indexPath.item]]];
    
    return cell;
}

- (NSString *)imageNameForCard:(CanastaCard *)card {
    NSArray *ranks = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"k", @"q", @"a", @"j"];
    NSArray *suits = @[@"s", @"c", @"h", @"d", @"r", @"b"];
    if (card.rank == JOKER) {
        return [NSString stringWithFormat:@"%@%@", ranks[card.rank], suits[card.suit]];
    }
    return [NSString stringWithFormat:@"%@%@", suits[card.suit], ranks[card.rank]];
}

- (void)robotTurns {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runRobotTurn:) userInfo:self.robots[0] repeats:NO];
}

- (void)runRobotTurn:(NSTimer *)timer {
    CanastaDumbRobot *robot = (CanastaDumbRobot *)[timer userInfo];
    [robot takeTurn];
    [self reloadDiscardPile];
    if (self.game.turn != 1) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runRobotTurn:) userInfo:self.robots[self.game.turn - 2] repeats:NO];
    }
}

- (void)reloadDiscardPile {
    if ([self.game.discardPile isFrozen]) {
        self.freezingCardView.image = [UIImage imageNamed:[self imageNameForCard:[self.game.discardPile freezingCard]]];
    }
    self.discardPileView.image = [UIImage imageNamed:[self imageNameForCard:[self.game.discardPile topCard]]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.game.turn == 1) {
//        [self.game discard:indexPath.item];
        [self reloadDiscardPile];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        [self robotTurns];
    }
}

@end
