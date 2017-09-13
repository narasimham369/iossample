//
//  BusinessFavouritesTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Utilities.h"
#import <UIKit/UIKit.h>


@interface BusinessFavouritesTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) id recommendDetails;

@end
