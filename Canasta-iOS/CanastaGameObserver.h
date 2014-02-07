//
//  CanastaGameObserver.h
//  Canasta-iOS
//
//  Created by Kyle Smith on 2/5/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CanastaGameObserver <NSObject>

- (void)newTurn;
- (void)handChanged;
- (void)discardPileChanged;
- (void)newRedThree;
- (void)stagedMeldsChanged;

@end
