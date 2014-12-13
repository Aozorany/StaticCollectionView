//
//  ViewController.m
//  StaticCollectionView
//
//  Created by Aoisorani on 12/11/14.
//  Copyright (c) 2014 Douliu. All rights reserved.
//


#import "ViewController.h"
#import "AOZStaticCollectionView.h"


@interface ViewController ()
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *contentsArray =
    @[
      //Section 1
      @{
          kAOZStaticCollectionViewSlotWidthKey: @1, kAOZStaticCollectionViewSlotHeightKey: @1,
          kAOZStaticCollectionViewSlotColumnsKey: @2, kAOZStaticCollectionViewSlotRowsKey: @2,
          kAOZStaticCollectionViewSlotContentsArrayKey: @[
                  @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 2)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor greenColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(1, 0, 1, 1)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor purpleColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(1, 1, 1, 1)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor brownColor]
                      }
                  ]
          },
      //Section 2
      @{
          kAOZStaticCollectionViewSlotWidthKey: @1, kAOZStaticCollectionViewSlotHeightKey: @1,
          kAOZStaticCollectionViewSlotColumnsKey: @4, kAOZStaticCollectionViewSlotRowsKey: @4,
          kAOZStaticCollectionViewSlotContentsArrayKey: @[
                  @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(0, 0, 2, 2)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor redColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(2, 0, 1, 3)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor blueColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(3, 0, 1, 3)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor cyanColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(0, 3, 2, 1)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor yellowColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(2, 3, 2, 1)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor purpleColor]
                      }, @{
                      kAOZStaticCollectionViewContentRectKey: [NSValue valueWithCGRect:CGRectMake(0, 2, 2, 1)],
                      kAOZStaticCollectionViewContentBackgroundColorKey: [UIColor orangeColor]
                      }
                  ]
          }
      ];
    
    AOZStaticCollectionView *collectionView = [[AOZStaticCollectionView alloc] init];
    collectionView.contentsArray = contentsArray;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:collectionView];
    [collectionView release];
    
    @autoreleasepool {
        NSDictionary *viewsDictionary_collectionView = NSDictionaryOfVariableBindings(collectionView);
        NSArray *constraints_collectionView = [NSLayoutConstraint constraintsWithVisualFormat:@"|[collectionView]|" options:0 metrics:nil views:viewsDictionary_collectionView];
        [self.view addConstraints:constraints_collectionView];
        constraints_collectionView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:viewsDictionary_collectionView];
        [self.view addConstraints:constraints_collectionView];
    }
}

@end
