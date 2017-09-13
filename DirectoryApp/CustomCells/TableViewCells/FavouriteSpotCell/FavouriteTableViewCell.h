//
//  FavouriteTableViewCell.h
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FavouriteSpotImageDelegate;
@interface FavouriteTableViewCell : UITableViewCell
@property (nonatomic, strong) id myFavouiteSpotDetails;
@property (nonatomic,strong) id <FavouriteSpotImageDelegate> favouriteSpotImageDelegate;

@end

@protocol FavouriteSpotImageDelegate <NSObject>

-(void)favouriteSpotImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView;

@end
