//
//  MoveViewController.m
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/7/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "MoveViewController.h"

@interface MoveViewController ()

@end

@implementation MoveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSUInteger slotCount = [self.delegate numberOfMeldSlots];
    [self.meldSelect removeAllSegments];
    
    for (NSInteger i = 0; i < slotCount; i++) {
        [self.meldSelect insertSegmentWithTitle:[NSString stringWithFormat:@"Meld %i", (int) i + 1] atIndex:i animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)discard {
    [self.delegate discard];
    
}

- (IBAction)meld {
    [self.delegate meld:self.meldSelect.selectedSegmentIndex];
}

@end
