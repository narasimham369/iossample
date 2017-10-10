//
//  SayThanksTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 02/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SayThanksTableCell.h"

#import "Utilities.h"
#import "Constants.h"
#import "UrlGenerator.h"
#import "Racommendations.h"
#import <CLToolKit/UIKitExt.h>
#import "UIImageView+WebCache.h"
#import "NSDate+NSDate_Category.h"
#import "BussinessFavorite.h"

@implementation SayThanksTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.imageIcon.layer.cornerRadius = self.imageIcon.height/2;
    // Initialization code
}
- (IBAction)selectButtonAction:(id)sender {
    if (self.selectButton.selected) {
        self.selectButton.selected = NO;
    } else {
        self.selectButton.selected = YES;
    }
    if(self.sayThanksCellDelegate && [self.sayThanksCellDelegate respondsToSelector:@selector(selctedItemWithIndex:withButton:)]){
        [self.sayThanksCellDelegate selctedItemWithIndex:self.tag withButton:self.selectButton];
    }
}

-(void)setRecommendDetails:(id)recommendDetails{
    if([recommendDetails isKindOfClass:[Racommendations class]]){
        Racommendations *recommendation = (Racommendations *)recommendDetails;
        self.nameLabel.text = recommendation.fullName;
        
        if(self.isFromSpecialCoupon){
            if(recommendation.specialCouponSentCount==2){
                self.selectButton.hidden = YES;
                self.allReadySendButton.hidden = NO;
                self.contentView.alpha=.4;
            }
            else{
                self.selectButton.hidden = NO;
                self.allReadySendButton.hidden = YES;
                self.contentView.alpha=1;
            }
            
        }
        else{
            if(recommendation.isthanksSend){
                self.selectButton.hidden = YES;
                self.allReadySendButton.hidden = NO;
                
            }
            else{
                self.selectButton.hidden = NO;
                self.allReadySendButton.hidden = YES;
                
            }
        }
        NSString *urlParameter = [NSString stringWithFormat:@"%@.jpg",[NSNumber numberWithLong:recommendation.user_id]];
        NSURL *userLogoImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORCOMMONUSERUSER withURLParameter:urlParameter];
        [self.imageIcon sd_setImageWithURL:userLogoImageUrl placeholderImage:[UIImage imageNamed:ProfileImagePlaceholder] options:SDWebImageRefreshCached completed:nil];
        
        long long recommendTime = recommendation.recemmendedTime;
        NSDate *recTime = [[Utilities standardUtilities]dateStringFromDateInmilliseconds:recommendTime];
        [self timeDifference:recTime ToDate:[NSDate date]];
    }else{
        BussinessFavorite *favorites = (BussinessFavorite *)recommendDetails;
        
        self.nameLabel.text = favorites.fullName;
        
        if(self.isFromSpecialCoupon){
            if(favorites.specialCouponSentCount==2){
                self.selectButton.hidden = YES;
                self.allReadySendButton.hidden = NO;
                self.contentView.alpha=.4;
            }
            else{
                self.selectButton.hidden = NO;
                self.allReadySendButton.hidden = YES;
                self.contentView.alpha=1;
            }
            
        }
        else{
            if(favorites.thanksSendStatus){
                self.selectButton.hidden = YES;
                self.allReadySendButton.hidden = NO;
            }
            else{
                self.selectButton.hidden = NO;
                self.allReadySendButton.hidden = YES;
            }
        }
        NSString *urlParameter = [NSString stringWithFormat:@"%@.jpg",[NSNumber numberWithLong:favorites.user_id]];
        NSURL *userLogoImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORCOMMONUSERUSER withURLParameter:urlParameter];
        [self.imageIcon sd_setImageWithURL:userLogoImageUrl placeholderImage:[UIImage imageNamed:ProfileImagePlaceholder] options:SDWebImageRefreshCached completed:nil];
        
        long long recommendTime = favorites.favoritedOn;
        NSDate *recTime = [[Utilities standardUtilities]dateStringFromDateInmilliseconds:recommendTime];
        [self timeDifference:recTime ToDate:[NSDate date]];
        
        
    }
}

- (void)timeDifference:(NSDate *)fromDate ToDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *differenceValue = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay
                                                    fromDate:fromDate toDate:toDate options:0];
    // NSInteger secondsDifference = [differenceValue second];
    // NSInteger minuteDifference = [differenceValue minute];
    //NSInteger hourDifference = [differenceValue hour];
    NSInteger dayDifference = [differenceValue day];
    NSInteger monthDifference = [differenceValue month];
    NSInteger yearDifference = [differenceValue year];
    if(yearDifference>0 || monthDifference>0){
        self.timeLabel.text = [fromDate convertDateToDateWithFormat:@""];
    }
    else if (dayDifference>0){
        if(dayDifference == 1){
            self.timeLabel.text = @"YESTERDAY";
        }
        else{
            self.timeLabel.text = [fromDate convertDateToDateWithFormat:@""];
        }
    }
    else{
        self.timeLabel.text = [fromDate convertDateToDateWithFormat:@"hh:mm a"].uppercaseString;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
