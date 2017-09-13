//
//  SwipeImageCollectionViewCell.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SwipeImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+NSstring_Category.h"

@implementation SwipeImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor clearColor].CGColor,
                       [(id)[UIColor blackColor] colorWithAlphaComponent:.5].CGColor,
                       nil];
    gradient.frame = CGRectMake(0, 0, self.frame.size.width+150, self.frame.size.height+150);
    [self.imageView.layer insertSublayer:gradient atIndex:0];

}
-(void)layoutSubviews{
     [super layoutSubviews];

}
-(void)setImageName:(NSString *)imageName{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];

}

- (IBAction)ImageTapAction:(id)sender {
    if(self.couponCollectionViewDelegate && [self.couponCollectionViewDelegate respondsToSelector:@selector(CouponImageTapActionDelegateWithCellTag:andImage:withImageView:)]){
        [self.couponCollectionViewDelegate CouponImageTapActionDelegateWithCellTag:self.tag andImage:self.imageView.image withImageView:self.imageView];
    }

}


@end
