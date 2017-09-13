//
//  SurpriseBoxTVC.h
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SurpriseBoxImageDelegate;
@interface SurpriseBoxTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *couponImageLogo;
@property (nonatomic, strong) id surpriseBoxDetails;
@property (nonatomic,strong) id <SurpriseBoxImageDelegate> surpriseBoxImageDelegate;

@end

@protocol SurpriseBoxImageDelegate <NSObject>

-(void)surpriseBoxImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView;

@end
