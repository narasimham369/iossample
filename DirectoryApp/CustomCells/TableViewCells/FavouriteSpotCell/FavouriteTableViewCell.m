//
//  FavouriteTableViewCell.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "FavouriteTableViewCell.h"

#import "CLToolKit/CLDateHandler.h"
#import "MyFavouriteSpots.h"
#import "UIImageView+WebCache.h"

@interface FavouriteTableViewCell ()
@property (weak, nonatomic) CALayer *layers;
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIView *contentViews;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *shopStatus;
@property (weak, nonatomic) IBOutlet UILabel *offerCount;
@property (weak, nonatomic) IBOutlet UILabel *businessAddress;
@property (weak, nonatomic) IBOutlet UIImageView *businessLogo;

@end
@implementation FavouriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor		= [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset		= CGSizeMake(0, 1);
    self.layer.shadowOpacity	= .8;
    self.layer.shadowRadius		= 2.0;
    self.layer.cornerRadius		= 5.0;
    self.clipsToBounds			= NO;
    self.innerView.layer.cornerRadius=5;
    self.innerView.layer.masksToBounds=YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)setMyFavouiteSpotDetails:(id)myFavouiteSpotDetails{
   MyFavouriteSpots *favourites = (MyFavouriteSpots *)myFavouiteSpotDetails;
    self.businessAddress.text = favourites.businessAddress;
    self.businessName.text = favourites.businessName;
    self.offerCount.text = [NSString stringWithFormat:@"%d Offers",favourites.offerCount];
    NSString *profileId=[NSString stringWithFormat:@"%@.jpg",[myFavouiteSpotDetails valueForKey:@"businessID"]];
    
    //54.214.172.192:8080
    //testing purpose
     NSString *imageUrl = [NSString stringWithFormat:@"http://54.214.172.192:8080/BizDirectoryApp/uploads/BusinessLogos/%@",profileId];
    
    //main server
   // NSString *imageUrl = [NSString stringWithFormat:@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/%@",profileId];
    [self.businessLogo sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *startTime=[NSString stringWithFormat:@"%@",[myFavouiteSpotDetails valueForKey:@"openingTime"]];
    NSString *time1=[NSString stringWithFormat:@"%@",[myFavouiteSpotDetails valueForKey:@"closingTime"]];
    NSString *time2 = [formatter stringFromDate:currentDate];
    NSDate *timeOfOpening= [formatter dateFromString:startTime];
    NSDate *timeOfClosing= [formatter dateFromString:time1];
    NSDate *CurrentTime = [formatter dateFromString:time2];
    
    NSComparisonResult result = [timeOfClosing compare:CurrentTime];
    NSComparisonResult result1 = [timeOfOpening compare:CurrentTime];
    
    if(result == NSOrderedDescending && result1== NSOrderedAscending)
    {
        self.shopStatus.backgroundColor=[UIColor colorWithRed:90.0f / 255.0f green:229.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
        self.shopStatus.text=@"OPEN";
    }else{
        self.shopStatus.backgroundColor=[UIColor colorWithRed:1.0f green:36.0f / 255.0f blue:36.0f / 255.0f alpha:1.0f];
        self.shopStatus.text=@"CLOSED";
    }
}
- (IBAction)imageTapAction:(id)sender {
    if(self.favouriteSpotImageDelegate && [self.favouriteSpotImageDelegate respondsToSelector:@selector(favouriteSpotImageTapActionDelegateWithCellTag:andImage:withImageView:)]){
        [self.favouriteSpotImageDelegate favouriteSpotImageTapActionDelegateWithCellTag:self.tag andImage:self.businessLogo.image withImageView:self.businessLogo];
    }
}

@end
