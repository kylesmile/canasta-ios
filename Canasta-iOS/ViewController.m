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
#import "CanastaDeck.h"
#import "CanastaDumbRobot.h"
#import "MoveViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CanastaGame *game;
@property (nonatomic, strong) NSArray *robots;
@property (nonatomic, strong) UIPopoverController *cardPopoverController;
@property (nonatomic, strong) NSIndexPath *selectedCard;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _game = [CanastaGame new];    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(newTurn) name:@"new turn" object:nil];
    [notificationCenter addObserver:self selector:@selector(discardPileChanged) name:@"discard pile changed" object:nil];
    [notificationCenter addObserver:self selector:@selector(handChanged) name:@"hands changed" object:nil];
    [notificationCenter addObserver:self selector:@selector(newRedThree) name:@"new red three" object:nil];
    [notificationCenter addObserver:self selector:@selector(stagedMeldsChanged) name:@"staged melds changed" object:nil];
    
	self.handView.dataSource = self;
    self.handView.delegate = self;
    
    self.meldsView.dataSource = self;
    self.meldsView.delegate = self;
    
    self.redThreesView.backgroundColor = [UIColor clearColor];
    self.meldsView.backgroundColor = [UIColor clearColor];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.handView) {
        return [[[self.game hand:1] size] integerValue];
    } else {
        if (self.game.turn == 1) {
            return [self.game meldSlotCount] - 1;
        } else {
            return [[self.game team:1].melds count];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.handView) {
        CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
        
        cell.imageView.image = [self imageForCard:[self.game hand:1].cards[indexPath.item]];
    
    return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Meld" forIndexPath:indexPath];
        
        UIImageView *cardImage;
    
        NSInteger i = 0;
        NSInteger item = indexPath.item;
        
        if (item + 1 <= [[self.game team:1].melds count]) {
            for (CanastaCard *card in [[self.game team:1].melds[item] cards]) {
                cardImage = [[UIImageView alloc] initWithImage:[self imageForCard:card]];
                [cardImage setTransform:CGAffineTransformMakeTranslation(0.0, i*25.0)];
                [cell addSubview:cardImage];
                i++;
            }
        }
        
        
        if (self.game.turn == 1 && item + 1 <= [self.game meldSlotCount] - 1) {
            for (CanastaCard *card in [self.game stagedMeld:item].cards) {
                cardImage = [[UIImageView alloc] initWithImage:[self imageForCard:card]];
                [cardImage setTransform:CGAffineTransformMakeTranslation(0.0, i*25.0)];
                cardImage.layer.opacity = 0.8;
                [cell addSubview:cardImage];
                i++;
            }
        }
    
        return cell;
    }
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
    [self.meldsView reloadData];
}

- (void)newRedThree {
    for (UIView *view in self.redThreesView.subviews) {
        [view removeFromSuperview];
    }
    
    CanastaTeam *team = [self.game team:1];
    UIImageView *threeImage;
    
    for (NSInteger i = 0; i < [[team redThreeCount] integerValue]; i++) {
        threeImage = [[UIImageView alloc] initWithImage:[self imageForCard:team.redThrees[i]]];
        [threeImage setTransform:CGAffineTransformMakeTranslation(0.0, i*25.0)];
        [self.redThreesView addSubview:threeImage];
    }
}

- (void)handChanged {
    [self.handView reloadData];
}

- (void)stagedMeldsChanged {
    [self.meldsView reloadData];
    [self.handView reloadData];
}

- (void)drawCard {
    [self.game draw];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.game.turn == 1) {
        if (collectionView == self.handView) {
                MoveViewController *moveVC = [self.storyboard instantiateViewControllerWithIdentifier:@"move"];
                moveVC.delegate = self;
                self.selectedCard = indexPath;
                
                self.cardPopoverController = [[UIPopoverController alloc] initWithContentViewController:moveVC];
                self.cardPopoverController.popoverContentSize = CGSizeMake(320.0, 200.0);
                
                CGRect cardFrame = [collectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
                CGRect collectionViewFrame = collectionView.frame;
                CGRect cardRect = CGRectMake(collectionViewFrame.origin.x + cardFrame.origin.x, collectionViewFrame.origin.y + cardFrame.origin.y, cardFrame.size.width, cardFrame.size.height);
                
                [self.cardPopoverController presentPopoverFromRect:cardRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        } else {
            [self.game unstageTopCardInMeld:indexPath.item];
        }
    }
}

- (NSUInteger)numberOfMeldSlots {
    return [self.game meldSlotCount];
}

- (void)discard {
    [self.cardPopoverController dismissPopoverAnimated:YES];
    [self.game stageDiscard:self.selectedCard.item];
    if ([self.game turnValid]) {
        [self.game finishTurn];
        [self drawDiscardPile];
//        [self.handView deleteItemsAtIndexPaths:@[self.selectedCard]];
        [self.handView reloadData];

        [self robotTurns];
    } else {
        [self.game unstageDiscard];
    }
}

- (void)meld:(NSUInteger)number {
    [self.cardPopoverController dismissPopoverAnimated:YES];
    if ([self.game canStageMeld:number cardIndex:self.selectedCard.item]) {
        [self.game stageMeld:number cardIndex:self.selectedCard.item];
//        [self.handView deleteItemsAtIndexPaths:@[self.selectedCard]];
        [self.handView reloadData];
    }
}

@end
