//
//  MapCategoryTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 21/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "MapCategoryTableCell.h"

@implementation MapCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectionButtonAction:(id)sender {
    BOOL selected;
    if(self.selectionButton.isSelected){
        self.selectionButton.selected=NO;
        selected=NO;
    }else{
        self.selectionButton.selected=YES;
         selected=YES;
    }
    if (self.delegateSelectionCell && [self.delegateSelectionCell respondsToSelector:@selector(selectedCategoryHomeTableCellItem:buttonClickWithIndex:withstatus:)]) {
        [self.delegateSelectionCell selectedCategoryHomeTableCellItem:self buttonClickWithIndex:self.tag withstatus:selected];
    }
}



@end
