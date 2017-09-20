//
//  BusinessFavouritesTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#import "Constants.h"
#import "UrlGenerator.h"
#import "Racommendations.h"
#import "BussinessFavorite.h"
#import <CLToolKit/UIKitExt.h>
#import "UIImageView+WebCache.h"
#import "NSDate+NSDate_Category.h"
#import "BusinessFavouritesTableCell.h"


@implementation BusinessFavouritesTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageIcon.layer.cornerRadius = self.imageIcon.height/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRecommendDetails:(id)recommendDetails{
    NSNumber *userId;
    long long recommendTime;
    if([recommendDetails isKindOfClass:[Racommendations class]]){
        Racommendations *recommend = (Racommendations *)recommendDetails;
        self.nameLabel.text = recommend.fullName;
        NSLog(@"%@ch", self.nameLabel.text);
        userId = [NSNumber numberWithLong:recommend.user_id];
        NSLog(@"%@ush", userId);
        NSString* counttext = [NSString stringWithFormat:@"%i", recommend.specialCouponSentCount];
      self.CountLbl.text = counttext;
     //  NSLog(@"%dush", check);
        recommendTime = recommend.recemmendedTime;
        
    }
    else{
        BussinessFavorite *favorite = (BussinessFavorite *)recommendDetails;
        
        self.nameLabel.text = favorite.fullName;
        userId = [NSNumber numberWithLong:favorite.user_id];
        recommendTime = favorite.favoritedOn;

//        if([recommendDetails valueForKey:@"fullName"]){
//            if(![[recommendDetails valueForKey:@"fullName"] isEqual:[NSNull null]]){
//                self.nameLabel.text = [NSString stringWithFormat:@"%@",[recommendDetails valueForKey:@"fullName"]];
//            }
//        }
//        if([recommendDetails valueForKey:@"user_id"]){
//            if(![[recommendDetails valueForKey:@"user_id"] isEqual:[NSNull null]]){
//                userId = [recommendDetails valueForKey:@"user_id"];
//            }
//        }
//        if ([recommendDetails valueForKey:@"favoritedOn"]){
//            if(![[recommendDetails valueForKey:@"favoritedOn"] isEqual:[NSNull null]]){
//                recommendTime = [[recommendDetails valueForKey:@"favoritedOn"] longLongValue];
//            }
//        }
    }
    
    NSDate *recTime = [[Utilities standardUtilities]dateStringFromDateInmilliseconds:recommendTime];
    [self timeDifference:recTime ToDate:[NSDate date]];
    
    NSString *urlParameter = [NSString stringWithFormat:@"%@.jpg",userId];
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
