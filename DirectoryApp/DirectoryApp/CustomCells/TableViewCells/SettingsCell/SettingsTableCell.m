//
//  SettingsTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 15/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SettingsTableCell.h"

@interface SettingsTableCell ()<UITextFieldDelegate>

@end
@implementation SettingsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.openingTimeText.delegate = self;
    self.closingTimeText.delegate = self;
    // Initialization code
}
-(void)layoutSubviews{
    if(self.tag==3){
         self.cellVerticalConstraint.constant = self.cellVerticalConstraint.constant - 10;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (IBAction)openingButtonAction:(id)sender {
    if (self.delegateCell && [self.delegateCell respondsToSelector:@selector(settingsTableViewCellItem:openingButtonClick:)]) {
        [self.delegateCell settingsTableViewCellItem:self openingButtonClick:nil];
}
}
- (IBAction)closingButtonAction:(id)sender {
    if (self.delegateCell && [self.delegateCell respondsToSelector:@selector(settingsTableViewCellItem:closingButtonClick:)]) {
        [self.delegateCell settingsTableViewCellItem:self closingButtonClick:nil];
}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
