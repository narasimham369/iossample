//
//  SendTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 15/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SendContactsTableViewCellDelegate;
@interface SendTableCell : UITableViewCell
@property (nonatomic, strong) NSArray *arrayRefineSubjectCode;
@property (weak, nonatomic) IBOutlet UIImageView *profileIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *firstLetterNameLabel;
@property (nonatomic, strong) id contactDetails;
@property (nonatomic, assign) id<SendContactsTableViewCellDelegate>delegateCell;
@end

@protocol SendContactsTableViewCellDelegate <NSObject>

- (void)sendContactsTableViewCellItem:(SendTableCell *)cell buttonClickWithIndex:(NSInteger)index;

@end
