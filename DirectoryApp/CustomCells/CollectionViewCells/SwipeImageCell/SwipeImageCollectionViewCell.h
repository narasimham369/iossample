//
//  SwipeImageCollectionViewCell.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CouponCollectionViewDelegate;

@interface SwipeImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *imageName;
@property (nonatomic,strong) id <CouponCollectionViewDelegate> couponCollectionViewDelegate;

@end

@protocol CouponCollectionViewDelegate <NSObject>

-(void)CouponImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView;

@end

