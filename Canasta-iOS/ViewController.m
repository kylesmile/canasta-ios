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
    
    _game = [CanastaGame new];
    _game.delegate = self;
    
	self.handView.dataSource = self;
    self.handView.delegate = self;;
    
    self.deckView.image = [UIImage imageNamed:@"backs_blue"];
    UITapGestureRecognizer *deckTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawCard)];
    [self.deckView addGestureRecognizer:deckTap];
    
    [self.freezingCardView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [self drawDiscardPile];
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
    
    cell.imageView.image = [self imageForCard:[self.game hand:1].cards[indexPath.item]];
    
    return cell;
}

- (UIImage *)imageForCard:(CanastaCard *)card {
    if (card) {
        NSArray *ranks = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"j", @"k", @"q", @"a", @"j"];
        NSArray *suits = @[@"s", @"c", @"h", @"d", @"r", @"b"];
        if (card.rank == JOKER) {
            return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", ranks[card.rank], suits[card.suit]]];
        }
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", suits[card.suit], ranks[card.rank]]];
    } else {
        return nil;
    }
}

- (void)robotTurns {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runRobotTurn:) userInfo:self.robots[0] repeats:NO];
}

- (void)runRobotTurn:(NSTimer *)timer {
    CanastaDumbRobot *robot = (CanastaDumbRobot *)[timer userInfo];
    [robot takeTurn];
    [self drawDiscardPile];
    if (self.game.turn != 1) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runRobotTurn:) userInfo:self.robots[self.game.turn - 2] repeats:NO];
    }
}

- (void)drawDiscardPile {
    CanastaCard *freezingCard = [self.game.discardPile freezingCard];
    CanastaCard *topCard = [self.game.discardPile topCard];
    
    if (![freezingCard isEqual:topCard]) {
        self.discardPileView.image = [self imageForCard:topCard];
        self.discardPileView.layer.zPosition = 1.0;
    } else {
        self.discardPileView.layer.zPosition = -1.0;
    }
    
    self.freezingCardView.image = [self imageForCard:freezingCard];
}

- (void)discardPileChanged {
    [self drawDiscardPile];
}

- (void)newTurn {
    
}

- (void)handChanged {
    [self.handView reloadData];
}

- (void)drawCard {
    [self.game draw];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.game.turn == 1) {
        [self.game stageDiscard:indexPath.item];
        if ([self.game turnValid]) {
            [self.game finishTurn];
            [self drawDiscardPile];
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            
            [self robotTurns];
        } else {
            [self.game unstageDiscard];
        }
    }
}

@end
