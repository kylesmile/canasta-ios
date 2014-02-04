//
//  ViewController.h
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/4/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *handView;
@property (nonatomic, weak) IBOutlet UIImageView *deckView;
@property (nonatomic, weak) IBOutlet UIImageView *discardPileView;
@property (nonatomic, weak) IBOutlet UIImageView *freezingCardView;

@end
