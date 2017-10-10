//
//  NewOfferTableCell.m
//  DirectoryApp
//
//  Created by Vishnu KM on 22/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Offers.h"
#import "UrlGenerator.h"
#import "MGSwipeButton.h"
#import "NewOfferTableCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+NSstring_Category.h"
#import "Utilities.h"
@interface NewOfferTableCell()
@property (weak, nonatomic) IBOutlet UILabel *availableDate;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;
@property (weak, nonatomic) IBOutlet UIView *contentBaseView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation NewOfferTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor		= [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset		= CGSizeMake(0, 1);
    self.layer.shadowOpacity	= .8;
    self.layer.shadowRadius		= 2.0;
    self.layer.cornerRadius		= 5.0;
    self.clipsToBounds			= NO;
    self.contentBaseView.layer.cornerRadius=5;
    self.contentBaseView.layer.masksToBounds=YES;
}

-(void)setOfferDetails:(id)offerDetails{
    Offers *offer = (Offers *)offerDetails;
    
    NSString *urlParameter = [NSString stringWithFormat:@"%d/%@",offer.offerID,offer.firstImageFileName];
    NSURL *offerImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFOROFFER withURLParameter:urlParameter];
    [self.offerImageView sd_setImageWithURL:offerImageUrl placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    NSString *expDate =  [offer.expiryDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    if(expDate.length == 0 ||[expDate isEqual:[NSNull null]]|| expDate==nil)
        expDate = @"On going";
    self.expDateLabel.text = expDate;
    NSString *availDate =  [offer.availableDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.availableDate.text = availDate;
    self.descriptionLabel.text = [[Utilities standardUtilities]encodeDataFromString:offer.offerDescription];
    self.nameLabel.text =[[Utilities standardUtilities]encodeDataFromString:offer.offerName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
