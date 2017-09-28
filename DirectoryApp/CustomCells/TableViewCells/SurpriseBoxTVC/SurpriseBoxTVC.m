//
//  SurpriseBoxTVC.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SurpriseBox.h"
#import "UIImageView+WebCache.h"
#import "SurpriseBoxTVC.h"
#import "NSString+NSstring_Category.h"
#import "Utilities.h"
#import "NSDate+NSDate_Category.h"
#import "UrlGenerator.h"
#import "NetworkHandler.h"
#import "RequestBodyGenerator.h"

@interface SurpriseBoxTVC()
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *AvailHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *availDate;
@property (weak, nonatomic) IBOutlet UILabel *expHeadLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@end
@implementation SurpriseBoxTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialisation];
    // Initialization code
}

-(void)initialisation{
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    }

-(void)setSurpriseBoxDetails:(id)surpriseBoxDetails{
    NSAttributedString *descriptionText;
    SurpriseBox *surprise = (SurpriseBox*)surpriseBoxDetails;
    UIColor *nameColor = [UIColor colorWithRed:0.24 green:0.22 blue:0.29 alpha:1.0];
    UIColor *descriptionColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    UIFont *nameFont = [UIFont fontWithName:@"Dosis-Bold" size:14.0];
    UIFont *descriptionFont = [UIFont fontWithName:@"Dosis-Medium" size:14.0 ];
    NSDictionary *normalAttributes = @{NSFontAttributeName:nameFont, NSForegroundColorAttributeName:nameColor};
    NSDictionary *descriptionAttributes = @{NSFontAttributeName:descriptionFont, NSForegroundColorAttributeName:descriptionColor};
    NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:surprise.business_name attributes:normalAttributes];
    NSString *imageUrl ;
    NSString *bussId=[NSString stringWithFormat:@"%@.jpg",[surpriseBoxDetails valueForKey:@"business_id"]];
    
    //testing purpose
   // imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",bussId];
    
    //main server
  imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",bussId];
    
    
    if ([[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:1]]) {
        descriptionText = [[NSAttributedString alloc] initWithString:@" has sent a special coupon for you." attributes:descriptionAttributes];
       //testing purpose
      //  imageUrl = [NSString stringWithFormat:@"%@%d/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",surprise.couponid,surprise.imageName];
        
        //main server
       imageUrl = [NSString stringWithFormat:@"%@%d/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",surprise.couponid,surprise.imageName];
        
    }else if ([[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:2]]) {
         nameText = [[NSAttributedString alloc] initWithString:surprise.shared_user attributes:normalAttributes];
        descriptionText = [[NSAttributedString alloc] initWithString:@" has shared with you a coupon!" attributes:descriptionAttributes];
        NSString *profileId=[NSString stringWithFormat:@"%@.jpg?%@",[surpriseBoxDetails valueForKey:@"shared_user_id"],[surpriseBoxDetails valueForKey:@"shared_user_image_cache"]];
        
       //test purpose
       // imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
        
        //main server
     imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];

    }else if ([[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:3]]) {
        nameText = [[NSAttributedString alloc] initWithString:surprise.recommendedUser attributes:normalAttributes];
        descriptionText = [[NSAttributedString alloc] initWithString:@" has recommended you a great business!" attributes:descriptionAttributes];
        
        NSString *profileId=[NSString stringWithFormat:@"%@.jpg?%@",[surpriseBoxDetails valueForKey:@"user_id"],[surpriseBoxDetails valueForKey:@"user_image_cache"]];
        
        //testing purpose
       // imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
        //main server
       imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
    }else if ([[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:4]]) {
          descriptionText = [[NSAttributedString alloc] initWithString:@" Thank you for recommending us! We appreciate your support!" attributes:descriptionAttributes];
    }else if ([[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:5]]) {
       descriptionText = [[NSAttributedString alloc] initWithString:@" Thank you for adding us to your favorite spot! We’ll do our best to keep you satisfy!" attributes:descriptionAttributes];
    }
       NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:nameText];
    [finalAttributedString appendAttributedString:descriptionText];
    self.descriptionLabel.attributedText = finalAttributedString;
    [self.couponImageLogo sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    
    if(!([[surpriseBoxDetails valueForKey:@"expiry_date"] isEqual: [NSNull null]] ||[surpriseBoxDetails valueForKey:@"expiry_date"]==nil||[[surpriseBoxDetails valueForKey:@"expiry_date"]isEqualToString:@"(null)"])){
        NSString *openingTime=[surpriseBoxDetails valueForKey:@"expiry_date"];
        openingTime=[openingTime convertDateWithInitialFormat:@"" ToDateWithFormat:@""];
        self.dateLabel.text=[NSString stringWithFormat:@"%@",openingTime];
    }else{
        self.dateLabel.text=@"On going";
    }
    if(![[surpriseBoxDetails valueForKey:@"available_date"] isEqual: [NSNull null]]){
        NSString *openingTime=[surpriseBoxDetails valueForKey:@"available_date"];
        openingTime=[openingTime convertDateWithInitialFormat:@"" ToDateWithFormat:@""];
        self.availDate.text=[NSString stringWithFormat:@"%@",openingTime];
    }
    if ([[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:4]]||[[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:5]] ||[[surpriseBoxDetails valueForKey:@"notificationType"] isEqual:[NSNumber numberWithInt:3]]) {
        //self.dateLabel.hidden=YES;
        self.availDate.hidden=YES;
        self.expHeadLabel.hidden=YES;
        self.AvailHeadingLabel.hidden=YES;
        long long recommendTime;
        recommendTime = [[surpriseBoxDetails valueForKey:@"notificationTime"] longLongValue];
        NSDate *recTime = [[Utilities standardUtilities]dateStringFromDateInmilliseconds:recommendTime];
        [self timeDifference:recTime ToDate:[NSDate date]];
    }else{
        self.dateLabel.hidden=NO;
        self.availDate.hidden=NO;
        self.expHeadLabel.hidden=NO;
        self.AvailHeadingLabel.hidden=NO;
    }
    NSLog(@"%@",[surpriseBoxDetails valueForKey:@"notificationStatus"]);
    if ([surpriseBoxDetails valueForKey:@"notificationStatus"]){
        self.backGroundView.backgroundColor=[[UIColor lightGrayColor]colorWithAlphaComponent:.1];
    }else{
        self.backGroundView.backgroundColor=[UIColor whiteColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)imageTapAction:(id)sender {
    if(self.surpriseBoxImageDelegate && [self.surpriseBoxImageDelegate respondsToSelector:@selector(surpriseBoxImageTapActionDelegateWithCellTag:andImage:withImageView:)]){
        [self.surpriseBoxImageDelegate surpriseBoxImageTapActionDelegateWithCellTag:self.tag andImage:self.profileImageView.image withImageView:self.profileImageView];
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
        self.dateLabel.text = [fromDate convertDateToDateWithFormat:@""];
    }
    else if (dayDifference>0){
        if(dayDifference == 1){
            self.dateLabel.text = @"YESTERDAY";
        }
        else{
            self.dateLabel.text = [fromDate convertDateToDateWithFormat:@""];
        }
    }
    else{
        self.dateLabel.text = [fromDate convertDateToDateWithFormat:@"hh:mm a"].uppercaseString;
    }
}

@end
