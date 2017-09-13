//
//  BaseCollectionView.m
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//
#import "BaseCollectionView.h"

@interface BaseCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation BaseCollectionView

#pragma mark - View Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self customization];
}

#pragma mark - Setters

- (void)setDataArray:(NSMutableArray *)dataArray {
    self.collectionDataArray = dataArray;
    [self reloadData];
}

#pragma mark - View Customization

- (void)customization {
    [self registerCell];
    [self setCollectionViewLayout:[self collectionViewLayout]];
    self.delegate = self;
    self.dataSource = self;
    //self.contentInset =UIEdgeInsetsMake(30, 30, 10, 30);
    //self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)registerCell {
    [self registerNib: [UINib nibWithNibName:@"UICollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];

}

#pragma mark - UICollectionView Flow Layout

- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(self.frame.size.width/2, self.frame.size.width/2);
    layout.minimumInteritemSpacing = 10;
    return layout;
}

- (Class)collectionViewCellClass {
    return [UICollectionViewCell class];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath ];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if(iPhone)
//        return CGSizeMake(self.frame.size.width/2, self.frame.size.width/2);
//    else if(iPad)
//        return CGSizeMake(self.frame.size.width/3, self.frame.size.width/3);
    return CGSizeMake(self.frame.size.width/2-50, self.frame.size.width/2-50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    return YES;
    
}
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
//    
//}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}




@end
