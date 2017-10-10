//
//  CustomContactTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 08/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectedContactTableViewCellDelegate;
@interface CustomContactTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UILabel *contactDetails;

@property (nonatomic, assign) id<SelectedContactTableViewCellDelegate>delegateSelectionCell;
@end

@protocol SelectedContactTableViewCellDelegate <NSObject>

- (void)selectedContactTableViewCellItem:(CustomContactTableCell *)cell buttonClickWithIndex:(NSInteger)index;

@end
