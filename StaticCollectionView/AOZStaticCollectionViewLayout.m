//
//  AOZStaticCollectionViewLayout.m
//  StaticCollectionView
//
//  Created by Aoisorani on 12/11/14.
//  Copyright (c) 2014 Douliu. All rights reserved.
//


#import "AOZStaticCollectionViewLayout.h"
#import "AOZStaticCollectionViewUtils.h"


#define _DEFAULT_SPACING 0


#pragma mark -
@interface AOZStaticCollectionViewLayout () {
    NSMutableArray *_sectionRectsArray;
    NSMutableDictionary *_contentRectsDictionary;
    NSMutableArray *_layoutAttributesArray;
    CGRect _lastAttributedRect;
}
@end


#pragma mark -
@implementation AOZStaticCollectionViewLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        _contentRectsDictionary = [[NSMutableDictionary alloc] init];
        _layoutAttributesArray = [[NSMutableArray alloc] init];
        _sectionRectsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_contentsArray release];
    [_contentRectsDictionary release];
    [_layoutAttributesArray release];
    [_sectionRectsArray release];
    [super dealloc];
}

- (void)setContentsArray:(NSArray *)contentsArray {
    if ([contentsArray isEqualToArray:_contentsArray] || (contentsArray == nil && _contentsArray == nil)) {
        return;
    }
    
    [_contentsArray release];
    _contentsArray = [contentsArray retain];
    
    [_contentRectsDictionary removeAllObjects];
    CGSize collectionViewSize = [UIScreen mainScreen].applicationFrame.size;
    NSInteger sectionIndex = 0;
    for (NSDictionary *sectionDictionary in _contentsArray) {
        //for every section
        CGFloat slotWidth = [sectionDictionary[kAOZStaticCollectionViewSlotWidthKey] floatValue];
        CGFloat slotHeight = [sectionDictionary[kAOZStaticCollectionViewSlotHeightKey] floatValue];
        NSInteger slotRows = [sectionDictionary[kAOZStaticCollectionViewSlotRowsKey] integerValue];
        NSInteger slotColumns = [sectionDictionary[kAOZStaticCollectionViewSlotColumnsKey] integerValue];
        slotWidth = slotWidth <= 0? 1: slotWidth;   slotHeight = slotHeight <= 0? 1: slotHeight;
        slotRows = slotRows <= 0? 1: slotRows;  slotColumns = slotColumns <= 0? 1: slotColumns;
        
        CGFloat realSlotWidth = (collectionViewSize.width - _DEFAULT_SPACING * (slotColumns + 1)) / slotColumns;
        CGFloat realSlotHeight = realSlotWidth * slotHeight / slotWidth;
        
        NSArray *slotContentsArray = sectionDictionary[kAOZStaticCollectionViewSlotContentsArrayKey];
        NSInteger rowIndex = 0;
        for (NSDictionary *contentDictionary in slotContentsArray) {
            //for every content block
            CGRect contentSlotRect = [contentDictionary[kAOZStaticCollectionViewContentRectKey] CGRectValue];
            CGRect contentRect = CGRectMake(CGRectGetMinX(contentSlotRect) * realSlotWidth + _DEFAULT_SPACING * (CGRectGetMinX(contentSlotRect) + 1),
                                            CGRectGetMinY(contentSlotRect) * realSlotHeight + _DEFAULT_SPACING * (CGRectGetMinY(contentSlotRect) + 1),
                                            CGRectGetWidth(contentSlotRect) * realSlotWidth + _DEFAULT_SPACING * (CGRectGetWidth(contentSlotRect) - 1),
                                            CGRectGetHeight(contentSlotRect) * realSlotHeight + _DEFAULT_SPACING * (CGRectGetHeight(contentSlotRect) - 1));
            _contentRectsDictionary[[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]] = [NSValue valueWithCGRect:contentRect];
            rowIndex++;
        }
        sectionIndex++;
    }
}

- (CGSize)collectionViewContentSize {
    if (_contentsArray.count == 0) {
        return CGSizeZero;
    }
    CGSize collectionViewSize = [UIScreen mainScreen].applicationFrame.size;
    CGPoint sectionOrigPoint = CGPointZero;
    NSInteger sectionIndex = 0;
    for (NSDictionary *sectionDictionary in _contentsArray) {
        //for each section, get it's size and rect
        CGFloat slotWidth = [sectionDictionary[kAOZStaticCollectionViewSlotWidthKey] floatValue];
        CGFloat slotHeight = [sectionDictionary[kAOZStaticCollectionViewSlotHeightKey] floatValue];
        NSInteger slotRows = [sectionDictionary[kAOZStaticCollectionViewSlotRowsKey] integerValue];
        NSInteger slotColumns = [sectionDictionary[kAOZStaticCollectionViewSlotColumnsKey] integerValue];
        slotWidth = slotWidth <= 0? 1: slotWidth;   slotHeight = slotHeight <= 0? 1: slotHeight;
        slotRows = slotRows <= 0? 1: slotRows;  slotColumns = slotColumns <= 0? 1: slotColumns;
        
        CGFloat realSlotWidth = (collectionViewSize.width - _DEFAULT_SPACING * (slotColumns + 1)) / slotColumns;
        CGFloat realSlotHeight = realSlotWidth * slotHeight / slotWidth;
        
        CGFloat realSectionWidth = collectionViewSize.width;
        CGFloat realSectionHeight = realSlotHeight * slotRows + _DEFAULT_SPACING * slotRows;
        
        [_sectionRectsArray addObject:[NSValue valueWithCGRect:CGRectMake(sectionOrigPoint.x, sectionOrigPoint.y, realSectionWidth, realSectionHeight)]];
        
        sectionOrigPoint.y += realSectionHeight;
        sectionIndex++;
    }
    return CGSizeMake(collectionViewSize.width, sectionOrigPoint.y + _DEFAULT_SPACING);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (CGRectEqualToRect(_lastAttributedRect, rect)) {
        return _layoutAttributesArray;
    }
    NSArray *allKeys = _contentRectsDictionary.allKeys;
    for (NSIndexPath *indexPath in allKeys) {
        CGRect contentRect = [_contentRectsDictionary[indexPath] CGRectValue];
        if (!CGRectIsNull(CGRectIntersection(rect, contentRect))) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (attributes) {
                [_layoutAttributesArray addObject:attributes];
            }
        }
    }
    return _layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect contentRect = [_contentRectsDictionary[indexPath] CGRectValue];
    CGRect sectionRectOffset = [_sectionRectsArray[indexPath.section] CGRectValue];
    contentRect.origin.y += sectionRectOffset.origin.y;
    attributes.frame = contentRect;
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

@end
