//
//  MoveViewControllerDelegate.h
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/7/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MoveViewControllerDelegate <NSObject>

- (NSUInteger)numberOfMeldSlots;
- (void)discard;
- (void)meld:(NSUInteger)number;

@end
