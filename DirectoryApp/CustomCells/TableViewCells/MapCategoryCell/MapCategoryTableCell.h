//
//  MapCategoryTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 21/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectedCategoryHomeTableCellDelegate;
@interface MapCategoryTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

@property (nonatomic, assign) id<SelectedCategoryHomeTableCellDelegate>delegateSelectionCell;
@end

@protocol SelectedCategoryHomeTableCellDelegate <NSObject>

- (void)selectedCategoryHomeTableCellItem:(MapCategoryTableCell *)cell buttonClickWithIndex:(NSInteger)index withstatus :(BOOL)status;

@end
