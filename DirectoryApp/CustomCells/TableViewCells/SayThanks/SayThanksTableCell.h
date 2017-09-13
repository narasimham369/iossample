//
//  SayThanksTableCell.h
//  DirectoryApp
//
//  Created by Vishnu KM on 02/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SayThanksTableViewCelleDelegate;
@interface SayThanksTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UIButton *allReadySendButton;

@property (nonatomic, assign) BOOL isFromSpecialCoupon;
@property (nonatomic, strong) id recommendDetails;
@property (nonatomic, assign) id <SayThanksTableViewCelleDelegate>sayThanksCellDelegate;
@end
@protocol SayThanksTableViewCelleDelegate <NSObject>

-(void)selctedItemWithIndex:(NSInteger)selectedIndex withButton:(UIButton *)button;

@end
