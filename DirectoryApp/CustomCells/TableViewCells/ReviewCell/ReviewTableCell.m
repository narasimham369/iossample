//
//  ReviewTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 17/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#import "Constants.h"
#import "Utilities.h"
#import "UrlGenerator.h"
#import "ReviewTableCell.h"
#import <CLToolKit/UIKitExt.h>
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import "NSDate+NSDate_Category.h"

@implementation ReviewTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.imageIcon.layer.cornerRadius = self.imageIcon.height/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setReviewListDict:(NSMutableDictionary *)reviewListDict{
    NSLog(@"Review:%@",reviewListDict);
    self.nameLabel.text=[NSString stringWithFormat:@"%@",[reviewListDict valueForKey:@"user_name"]];
    self.descriptionLabel.text=[NSString stringWithFormat:@"%@",[reviewListDict valueForKey:@"comment"]];
    
    long long recommendTime;
    recommendTime = [[reviewListDict valueForKey:@"created_on"] longLongValue];
    NSDate *recTime = [[Utilities standardUtilities]dateStringFromDateInmilliseconds:recommendTime];
    [self timeDifference:recTime ToDate:[NSDate date]];
    
    NSString *profileId=[NSString stringWithFormat:@"%@",[reviewListDict valueForKey:@"user_id"]];
    NSString *urlParameter = [NSString stringWithFormat:@"%@.jpg",profileId];
    NSURL *userLogoImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORCOMMONUSERUSER withURLParameter:urlParameter];
    [self.imageIcon sd_setImageWithURL:userLogoImageUrl placeholderImage:[UIImage imageNamed:ProfileImagePlaceholder] options:SDWebImageRefreshCached completed:nil];
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

@end
