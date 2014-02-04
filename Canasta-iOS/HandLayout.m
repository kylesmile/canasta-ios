//
//  HandLayout.m
//  CustomHandCollectionView
//
//  Created by Kyle Smith on 1/31/14.
//  Copyright (c) 2014 Kyle Smith. All rights reserved.
//

#import "HandLayout.h"

@implementation HandLayout

- (CGSize)collectionViewContentSize {
    return self.collectionView.frame.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger numberOfCards = [self numberOfCards];
    numberOfCards = [self numberOfCards];
    
    NSMutableArray *layouts = [NSMutableArray arrayWithCapacity:numberOfCards];
    
    for (NSInteger i = 0; i < numberOfCards; i++) {
        layouts[i] = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    return layouts;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layout = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    layout.size = CGSizeMake(71.0, 96.0);
    
    float middle = [self numberOfCards] / 2.0;
    
    layout.center = CGPointMake(50.0 + indexPath.item * 40.0, 70.0 + 0.01*powf(indexPath.item - middle, 2) * 40.0);
    layout.transform = CGAffineTransformMakeRotation(atanf(0.02*(indexPath.item - middle)));
    
    layout.zIndex = indexPath.item;

    return layout;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSInteger)numberOfCards {
    return [self.collectionView numberOfItemsInSection:0];
}

@end
