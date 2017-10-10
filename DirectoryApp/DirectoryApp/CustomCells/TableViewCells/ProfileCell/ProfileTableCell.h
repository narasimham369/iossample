//
//  ProfileTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *surpriceCountLabel;

@end
