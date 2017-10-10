//
//  HomeDetailTableViewCell.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/17/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeDetailTableViewCellDelegate;
@interface HomeDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) id mySavedCouponsDetails;
@property (nonatomic, assign) id <HomeDetailTableViewCellDelegate>homeDetailCellDelegate;
@property (strong, nonatomic) NSMutableDictionary *offerListDict;
@property (weak, nonatomic) IBOutlet UIImageView *saveIcon;
@property (weak, nonatomic) IBOutlet UIImageView *saveImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeNextButton;
@property (weak, nonatomic) IBOutlet UIImageView *homeNextImage;
@end
@protocol HomeDetailTableViewCellDelegate <NSObject>
-(void)homeDetailImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView;
-(void)shareButtonActionDelegate:(UIImage *)image;
@end
