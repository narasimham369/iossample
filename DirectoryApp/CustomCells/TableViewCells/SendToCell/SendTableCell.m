//
//  SendTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 15/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//


#import "SendTableCell.h"
#import <CLToolKit/UIKitExt.h>

@implementation SendTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self customisation];
    // Initialization code
}
-(void)customisation{
    self.firstLetterNameLabel.layer.cornerRadius = self.firstLetterNameLabel.height/2;
    self.firstLetterNameLabel.layer.borderWidth = 1.0;
    self.firstLetterNameLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor ];
    self.firstLetterNameLabel.hidden = YES;
    self.profileIcon.layer.cornerRadius = self.profileIcon.height/2;
    self.profileIcon.layer.borderWidth = 1.0;
    self.profileIcon.layer.borderColor = [[UIColor lightGrayColor]CGColor ];
    self.sendButton.layer.borderWidth = 2.0;
    self.sendButton.layer.borderColor = [[UIColor colorWithRed:36.0f / 255.0f green:189.0f / 255.0f blue:229.0f / 255.0f alpha:1.0f] CGColor];
    self.sendButton.layer.cornerRadius = 5;
}

-(void)setContactDetails:(id)contactDetails{
    NSString* string = [contactDetails valueForKey:@"fullName"];
    NSArray *components;
    NSString* newNameStr=@"";
    if(!([string isEqualToString:@""]||[string isEqualToString:@" "])){
        NSString *nameStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        components = [nameStr componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(components.count > 1){
            if([[components objectAtIndex:0]  length]>=1){
                NSString *temp=[[components objectAtIndex:0] substringToIndex:1];
                newNameStr=[newNameStr stringByAppendingString:temp];
            }
            else{
                newNameStr=[newNameStr stringByAppendingString:[components objectAtIndex:0]];
            }
            if([[components objectAtIndex:1]  length]>=1){
                newNameStr=[newNameStr stringByAppendingString:[[components objectAtIndex:1] substringToIndex:1]];
            }
            else{
                newNameStr=[newNameStr stringByAppendingString:[components objectAtIndex:1]];
            }
        }
        else{
            if([[components objectAtIndex:0]  length]>=1){
                newNameStr = [NSString stringWithFormat:@"%@", [[components objectAtIndex:0] substringToIndex:1]];
            }
            else{
                newNameStr = [NSString stringWithFormat:@"%@", [components objectAtIndex:0] ];
            }
        }
    }
    UIImage *image = [contactDetails valueForKey:@"userImage"];
    if (image != nil) {
        self.firstLetterNameLabel.hidden = YES;
        self.profileIcon.image = image;
    }
    else{
        self.profileIcon.image = [UIImage imageNamed:@"contactCellDummy"];
        self.firstLetterNameLabel.hidden = NO;
        self.firstLetterNameLabel.text = newNameStr;
    }
    self.nameLabel.text = [contactDetails valueForKey:@"fullName"];
    NSArray *forArrayCount = [contactDetails valueForKey:@"PhoneNumbers"];
    NSArray *formailCount = [contactDetails valueForKey:@"EmailAddresses"];
    if (formailCount.count != 0) {
        self.phoneNumberLabel.text = [[contactDetails valueForKey:@"EmailAddresses"]
                                      objectAtIndex:0];
    }
    else if(forArrayCount.count != 0){
        self.phoneNumberLabel.text = [[contactDetails valueForKey:@"PhoneNumbers"]
                                      objectAtIndex:0];
    }
    
}

- (IBAction)sendButtonAction:(id)sender {
    if (self.delegateCell && [self.delegateCell respondsToSelector:@selector(sendContactsTableViewCellItem:buttonClickWithIndex:)]) {
        [self.delegateCell sendContactsTableViewCellItem:self buttonClickWithIndex:self.tag];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
