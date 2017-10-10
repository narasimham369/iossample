//
//  SettingsTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 15/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SettingsTableViewCellDelegate;
@interface SettingsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *settingsName;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *openingTime;
@property (weak, nonatomic) IBOutlet UILabel *closingTime;
@property (weak, nonatomic) IBOutlet UILabel *openingLabel;
@property (weak, nonatomic) IBOutlet UILabel *closingLabel;
@property (weak, nonatomic) IBOutlet UIButton *downArrowButton;
@property (weak, nonatomic) IBOutlet UITextField *toAddSubCategoryPicker;
@property (weak, nonatomic) IBOutlet UILabel *categorySubItem;
@property (weak, nonatomic) IBOutlet UITextField *toAddPickerView;
@property (weak, nonatomic) IBOutlet UILabel *sectionHeader;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UITextField *closingTimeText;
@property (weak, nonatomic) IBOutlet UITextField *openingTimeText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellVerticalConstraint;

@property (nonatomic, assign) id<SettingsTableViewCellDelegate>delegateCell;
@end

@protocol SettingsTableViewCellDelegate <NSObject>

- (void)settingsTableViewCellItem:(SettingsTableCell *)cell openingButtonClick:(id)index;
- (void)settingsTableViewCellItem:(SettingsTableCell *)cell closingButtonClick:(id)index;

@end
