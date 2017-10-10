//
//  BaseCollectionView.h
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseCollectionViewDelegate ;

@interface BaseCollectionView : UICollectionView

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *collectionDataArray;
@property (nonatomic,strong)id<BaseCollectionViewDelegate>collectionViewDelegate;

- (void)customization;
- (UICollectionViewFlowLayout *)collectionViewLayout;

@end

@protocol BaseCollectionViewDelegate <NSObject>

@optional
- (void)baseCollectionView:(BaseCollectionView *)collectionView clickedItem:(id)item;
- (void)baseCollectionView:(BaseCollectionView *)collectionView clickedItem:(id)item withIndex:(NSIndexPath *)indexPath;

@end