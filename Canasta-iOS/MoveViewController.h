//
//  MoveViewController.h
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/7/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveViewControllerDelegate.h"

@interface MoveViewController : UIViewController

@property (nonatomic, strong) id <MoveViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *meldSelect;

- (IBAction)discard;
- (IBAction)meld;

@end
