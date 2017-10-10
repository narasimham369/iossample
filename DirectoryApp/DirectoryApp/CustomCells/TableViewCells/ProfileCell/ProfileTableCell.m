//
//  ProfileTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "ProfileTableCell.h"

@implementation ProfileTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.surpriceCountLabel.layer.cornerRadius=15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
