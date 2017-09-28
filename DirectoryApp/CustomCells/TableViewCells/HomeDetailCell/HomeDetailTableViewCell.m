//
//  HomeDetailTableViewCell.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/17/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SavedCoupons.h"
#import "HomeDetailTableViewCell.h"
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import "NSString+NSstring_Category.h"
#import "Utilities.h"

@interface HomeDetailTableViewCell ()
@property (weak, nonatomic) CALayer *layers;
@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIView *contentViews;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *decriptionLabel;
@property (nonatomic)BOOL isCalledLayout;
@property (weak, nonatomic) IBOutlet UILabel *availableDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;

@property (weak, nonatomic) IBOutlet UIView *specialView;
@property (weak, nonatomic) IBOutlet UIView *specialBoarder1;
@property (weak, nonatomic) IBOutlet UIView *specialBoarder2;
@property (weak, nonatomic) IBOutlet UIView *specialBoarder3;
@property (weak, nonatomic) IBOutlet UIView *specialBoarder4;

@end

@implementation HomeDetailTableViewCell

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
-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.isCalledLayout){
        self.isCalledLayout=YES;
    }
}
- (IBAction)shareButtonAction:(UIButton *)sender {
    if(self.homeDetailCellDelegate && [self.homeDetailCellDelegate respondsToSelector:@selector(shareButtonActionDelegate:)]){
        [self.homeDetailCellDelegate shareButtonActionDelegate:self.logoImage.image];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setOfferListDict:(NSMutableDictionary *)offerListDict{
    
    //54.214.172.192:8080
    
    //testing purpose
   //  NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[offerListDict valueForKey:@"id"],[[offerListDict valueForKey:@"files"]firstObject]];
    
    //main server
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[offerListDict valueForKey:@"id"],[[offerListDict valueForKey:@"files"]firstObject]];
    if(![[offerListDict valueForKey:@"expiry_date"] isEqual: [NSNull null]]){
        NSString *openingTime=[offerListDict valueForKey:@"expiry_date"];
        openingTime=[openingTime convertDateWithInitialFormat:@"" ToDateWithFormat:@""];
        self.dateLabel.text=[NSString stringWithFormat:@"%@",openingTime];
    }else{
        self.dateLabel.text=@"On going";
    }
    if(![[offerListDict valueForKey:@"available_date"] isEqual: [NSNull null]]){
        NSString *openingTime=[offerListDict valueForKey:@"available_date"];
        openingTime=[openingTime convertDateWithInitialFormat:@"" ToDateWithFormat:@""];
        self.availableDateLabel.text=[NSString stringWithFormat:@"%@",openingTime];
    }
    self.decriptionLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[offerListDict valueForKey:@"description"]]];;
    self.nameLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[offerListDict valueForKey:@"name"]]];
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    if([[offerListDict valueForKey:@"savedStatus"]isEqual:[NSNumber numberWithInt:0]]){
        self.saveImageView.image=[UIImage imageNamed:@"homeBalckTicket"];
    }else{
        self.saveImageView.image=[UIImage imageNamed:@"homeGreenTicket"];
        
//        offerListDict = [[NSMutableDictionary alloc]init];
//        offerListDict = nil;
//        UITableViewCell.
        
        
//        [objectsAtSection removeObjectAtIndex:indexPath.row]; 
//  self.decriptionLabel.hidden = YES;
//        self.availableDateLabel.hidden =YES;
//        self.nameLabel.hidden =YES;
//        self.logoImage.hidden =YES;
        
        
       
    }
}

-(void)setMySavedCouponsDetails:(id)mySavedCouponsDetails{
    SavedCoupons *myCoupon = (SavedCoupons *)mySavedCouponsDetails;
    self.homeNextImage.hidden = YES;
    self.homeNextButton.hidden = YES;
    self.saveImageView.hidden = YES;
    self.decriptionLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",myCoupon.couponDescription]];
    self.nameLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",myCoupon.couponName]];
    NSString *expDate;
    if(![myCoupon.expiryDate isEqual: [NSNull null]]){
        expDate =  [myCoupon.expiryDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
        self.dateLabel.text = expDate;
    }
    if([self.dateLabel.text length]==0){
        self.dateLabel.text=@"On going";
    }
    NSString *avlDate;
    if(![myCoupon.availableDate isEqual: [NSNull null]]){
        avlDate =  [myCoupon.expiryDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
        self.availableDateLabel.text = avlDate;
    }
    
    //testing purpose
    // NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[mySavedCouponsDetails valueForKey:@"id"],[mySavedCouponsDetails valueForKey:@"firstImageFileName"]];
    
    //main server
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[mySavedCouponsDetails valueForKey:@"id"],[mySavedCouponsDetails valueForKey:@"firstImageFileName"]];
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    if([[mySavedCouponsDetails valueForKey:@"is_special_coupon"]isEqual:[NSNumber numberWithInt:1]]){
        self.specialView.hidden=NO;
        self.specialBoarder1.hidden=NO;
        self.specialBoarder2.hidden=NO;
        self.specialBoarder3.hidden=NO;
        self.specialBoarder4.hidden=NO;
        
    }
}

- (IBAction)imageTapAction:(id)sender {
    if(self.homeDetailCellDelegate && [self.homeDetailCellDelegate respondsToSelector:@selector(homeDetailImageTapActionDelegateWithCellTag:andImage:withImageView:)]){
        [self.homeDetailCellDelegate homeDetailImageTapActionDelegateWithCellTag:self.tag andImage:self.logoImage.image withImageView:self.logoImage];
    }
}
@end
