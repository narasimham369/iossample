//
//  CustomContactTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 08/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "CustomContactTableCell.h"

@implementation CustomContactTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectButtonAction:(id)sender {
    if (self.delegateSelectionCell && [self.delegateSelectionCell respondsToSelector:@selector(selectedContactTableViewCellItem:buttonClickWithIndex:)]) {
        [self.delegateSelectionCell selectedContactTableViewCellItem:self buttonClickWithIndex:self.tag];
    }}

@end
