//
//  AOZStaticCollectionView.m
//  StaticCollectionView
//
//  Created by Aoisorani on 12/11/14.
//  Copyright (c) 2014 Douliu. All rights reserved.
//

#import "AOZStaticCollectionView.h"

@implementation AOZStaticCollectionView

#pragma mark Lifecircle
- (instancetype)init {
    AOZStaticCollectionViewLayout *collectionViewLayout = [[AOZStaticCollectionViewLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    if (self) {
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"C_X"];
        self.dataSource = self;
    }
    [collectionViewLayout release];
    return self;
}

- (void)dealloc {
    [_contentsArray release];
    [super dealloc];
}

#pragma mark delegate: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _contentsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section >= 0 && section < _contentsArray.count) {
        NSDictionary *sectionDictionary = _contentsArray[section];
        NSArray *sectionContentsArray = sectionDictionary[kAOZStaticCollectionViewSlotContentsArrayKey];
        return sectionContentsArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"C_X" forIndexPath:indexPath];
    if (indexPath.section >= 0 && indexPath.section < _contentsArray.count) {
        NSDictionary *sectionDictionary = _contentsArray[indexPath.section];
        NSArray *sectionContentsArray = sectionDictionary[kAOZStaticCollectionViewSlotContentsArrayKey];
        if (indexPath.row >= 0 && indexPath.row < sectionContentsArray.count) {
            NSDictionary *contentDictionary = sectionContentsArray[indexPath.row];
            cell.backgroundColor = contentDictionary[kAOZStaticCollectionViewContentBackgroundColorKey];
        }
    }
    return cell;
}

#pragma mark customized: Public (setters)
- (void)setContentsArray:(NSArray *)contentsArray {
    if ([contentsArray isEqualToArray:_contentsArray]) {
        return;
    }
    [_contentsArray release];
    _contentsArray = [contentsArray retain];
    ((AOZStaticCollectionViewLayout *)self.collectionViewLayout).contentsArray = _contentsArray;
}

@end
