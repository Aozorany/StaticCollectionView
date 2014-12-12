//
//  AOZStaticCollectionView.h
//  StaticCollectionView
//
//  Created by Aoisorani on 12/11/14.
//  Copyright (c) 2014 Douliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOZStaticCollectionViewLayout.h"
#import "AOZStaticCollectionViewUtils.h"


@interface AOZStaticCollectionView : UICollectionView <UICollectionViewDataSource>
@property (nonatomic, retain, setter=setContentsArray:) NSArray *contentsArray;
@end
