//
//  CouponDetailViewController.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Offers.h"
#import "SendToVC.h"
#import "BusinessUser.h"
#import "SurpriseBox.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CouponDetailViewController.h"
#import "NSString+NSstring_Category.h"
#import "SwipeImageCollectionViewCell.h"
#import "LoginViewController.h"

#import "Utilities.h"
#import "UrlGenerator.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "FacebookLoginVC.h"
#import <CLToolKit/UIKitExt.h>
#import "RequestBodyGenerator.h"
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import <CLToolKit/CLAlertHandler.h>
#import <CommonCrypto/CommonDigest.h>
#import <CLToolKit/NSString+Extension.h>
#import <CLToolKit/CLCoreDataAdditions.h>
#import "Constants.h"
#import "NSString+NSstring_Category.h"
#import "User.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "UseNoewDetailsVC.h"

@interface CouponDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CouponCollectionViewDelegate,UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UICollectionView *swipeImageCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *shadowCardView;
@property (nonatomic,assign) int previuosIndex;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gradientTapGesture;
@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
@property (weak, nonatomic) CALayer *layers;
@property (weak, nonatomic) IBOutlet UIView *shareOnlyView;
@property (weak, nonatomic) IBOutlet UIView *saveCarryView;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saveIcon;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *dealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDecription;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (nonatomic) BOOL isCalledSave;
@property (weak, nonatomic) IBOutlet UILabel *shareCouponSendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareCouponSendImage;
@property (weak, nonatomic) IBOutlet UIButton *shareCouponButton;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (retain) UIDocumentInteractionController * documentInteractionController;
@property (weak, nonatomic) IBOutlet UIView *saveOnlyView;
@property (weak, nonatomic) IBOutlet UILabel *surpriceSaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *surpriceSaveImageView;
@property (weak, nonatomic) IBOutlet UIButton *surpriceSaveButton;
@property (weak, nonatomic) IBOutlet UILabel *availableDate;

@end

@implementation CouponDetailViewController

#pragma mark - View LifeCycle

- (void)initView {
    [super initView];
    [self Custumisation];
    [self CollectionViewInitial];
    if(self.isFromSavedCoupon){
        [self PopulateUiFromSavedCoupon];
    }else if (self.isFromBusinessOwner){
        [self populateFromBussinessOwner];
    }else if(self.isFromSurpriseBox){
        [self populateSurpriseBoxDetails];
    }else{
        [self PopulateUi];
    }
    if([self.dateLabel.text length]==0){
        self.dateLabel.text=@"On going";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated{
    self.layers = self.shadowCardView.layer;
    self.layers.shadowOffset = CGSizeMake(.5,.5);
    self.layers.shadowColor = [[UIColor blackColor] CGColor];
    self.layers.shadowRadius = 2.0f;
    self.layers.shadowOpacity = 0.40f;
    self.layers.shadowPath = [[UIBezierPath bezierPathWithRect:self.layers.bounds] CGPath];
}

-(void)viewDidLayoutSubviews{
    
}

#pragma mark - View Custumisation

-(void)Custumisation{
    [self showButtonOnLeftWithImageName:@""];
    self.title=@"Coupons";
    self.gradientTapGesture.delegate = self;
    self.gradientView.hidden = YES;
    NSLog(@"%@",self.myOffersArray);
    self.swipeImageCollectionView.delegate=self;
    self.swipeImageCollectionView.dataSource=self;
    self.pageControl.numberOfPages=self.couponImagesArray.count;
    self.cardView.layer.cornerRadius=5;
}

#pragma mark - Populating Ui from Bussiness detail

-(void)populateFromBussinessOwner{
    self.saveOnlyView.hidden=YES;
    self.shareOnlyView.hidden=YES;
    self.saveCarryView.hidden=YES;
    Offers *offer = (Offers *)self.offerDetails;
    self.dealDecription.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",offer.offerDescription]]];
    self.dealNameLabel.text=[NSString stringWithFormat:@"%@",offer.offerName];
    NSString *expDate =  [offer.expiryDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.dateLabel.text = expDate;
    NSString *avlDate =  [offer.availableDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.availableDate.text = avlDate;
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSString *urlParameter = [NSString stringWithFormat:@"%lld.jpg",busUser.business_id];
    NSURL *businessLogoImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORBUSINESSUSER withURLParameter:urlParameter];
    [self.locationImageView sd_setImageWithURL:businessLogoImageUrl placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    self.phoneNumber.text = busUser.phone;
    NSString *address=busUser.address;
    NSString *street=busUser.street;
    NSString *city=busUser.city;
    if ([address isEqual:[NSNull null]] ) {
        address=@"";
    }
    if ([street isEqual:[NSNull null]] ) {
        street=@"";
    }
    if ([city isEqual:[NSNull null]] ) {
        city=@"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@",address,street,city];
    self.couponImagesArray = [[NSMutableArray alloc] init];
    [self.couponImagesArray addObject:offer.firstImageFileName];
    self.pageControl.hidden = YES;
    if([self.dateLabel.text length]==0 ||[self.dateLabel.text isEqualToString:@"(null)"]){
        self.dateLabel.text=@"On going";
    }
}

-(void)PopulateUi{
    self.saveOnlyView.hidden=YES;
    self.shareOnlyView.hidden=YES;
    self.saveCarryView.hidden=NO;
    self.dealDecription.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"description"]]];
    self.dealNameLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"name"]]];
    self.phoneNumber.text=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"business_phone"]];
    NSString *address=[self.bussinessDetails valueForKey:@"business_address"];
    NSString *street=[self.bussinessDetails valueForKey:@"street"];
    NSString *city=[self.bussinessDetails valueForKey:@"city"];
    if ([address isEqual:[NSNull null]] ) {
        address=@"";
    }
    if ([street isEqual:[NSNull null]] ) {
        street=@"";
    }
    if ([city isEqual:[NSNull null]] ) {
        city=@"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@",address,street,city];
    
    NSString *openingTime;
    if(![[self.myOffersArray valueForKey:@"expiry_date"] isEqual:[NSNull null]]){
        openingTime = [self.myOffersArray valueForKey:@"expiry_date"];
        openingTime=[openingTime convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
        self.dateLabel.text=[NSString stringWithFormat:@"%@",openingTime];
    }else{
        self.dateLabel.text=@"";
    }
    
    NSString *availDate;
    if(![[self.myOffersArray valueForKey:@"available_date"] isEqual:[NSNull null]]){
        availDate = [self.myOffersArray valueForKey:@"available_date"];
        availDate=[availDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
        self.availableDate.text=[NSString stringWithFormat:@"%@",availDate];
    }
    NSString *profileId=[NSString stringWithFormat:@"%@.jpg",[self.bussinessDetails valueForKey:@"business_id"]];
    
    //testing purpose
    NSString *imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
    
  // Main server
 // NSString *imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
    [self.locationImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    if([[self.myOffersArray valueForKey:@"savedStatus"]isEqual:[NSNumber numberWithInt:0]]){
        self.saveIcon.image=[UIImage imageNamed:@"homeBalckTicket"];
        self.saveLabel.text=@"SAVE";
        self.saveLabel.textColor=[UIColor colorWithRed:90.0f / 255.0f green:229.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
    }else{
        self.saveIcon.image=[UIImage imageNamed:@"homeGreenTicket"];
        self.saveLabel.text=@"SAVED";
        self.saveButton.userInteractionEnabled=NO;
        self.saveLabel.textColor=[UIColor colorWithRed:0.06 green:0.64 blue:0.24 alpha:1.0];
    }
    if([self.dateLabel.text length]==0 ||[self.dateLabel.text isEqualToString:@"(null)"]){
        self.dateLabel.text=@"On going";
    }
}

#pragma mark - Populating Ui from Saved Coupon

-(void)PopulateUiFromSavedCoupon{
    self.saveOnlyView.hidden=YES;
    self.shareOnlyView.hidden=NO;
    self.saveCarryView.hidden=YES;
    self.phoneNumber.text = [NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"business_phone"]];
    self.dealDecription.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"couponDescription"]]];
    self.dealNameLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"couponName"]]];
    NSString *address=[self.myOffersArray valueForKey:@"business_address"];
    NSString *street=[self.myOffersArray valueForKey:@"street"];
    NSString *city=[self.myOffersArray valueForKey:@"city"];
    if ([address isEqual:[NSNull null]] ) {
        address=@"";
    }
    if ([street isEqual:[NSNull null]] ) {
        street=@"";
    }
    if ([city isEqual:[NSNull null]] ) {
        city=@"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@",address,street,city];
    NSString *expDate=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"expiryDate"]];
    expDate=[expDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.dateLabel.text=[NSString stringWithFormat:@"%@",expDate];
    NSString *availDate=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"availableDate"]];
    availDate=[availDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.availableDate.text=[NSString stringWithFormat:@"%@",availDate];
    
    NSString *urlParameter = [NSString stringWithFormat:@"%@.jpg",[self.myOffersArray valueForKey:@"businessID"]];
    NSURL *businessLogoImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORBUSINESSUSER withURLParameter:urlParameter];
    [self.locationImageView sd_setImageWithURL:businessLogoImageUrl placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    if([[self.myOffersArray valueForKey:@"is_special_coupon"]isEqual:[NSNumber numberWithBool:1]]){
        self.saveCarryView.hidden=YES;
        self.shareOnlyView.hidden=YES;
        self.saveOnlyView.hidden=YES;
    }else{
    }
    if([self.dateLabel.text length]==0 ||[self.dateLabel.text isEqualToString:@"(null)"]){
        self.dateLabel.text=@"On going";
    }
}

#pragma mark - Populating Ui from surprise box

-(void)populateSurpriseBoxDetails{
    self.saveOnlyView.hidden=NO;
    self.shareOnlyView.hidden=YES;
    self.saveCarryView.hidden=YES;
    self.dealDecription.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"descriptionDetails"]]];
    self.dealNameLabel.text = [[Utilities standardUtilities]encodeDataFromString:[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"name"]]];
    NSString *address=[self.myOffersArray valueForKey:@"business_address"];
    NSString *street=[self.myOffersArray valueForKey:@"street"];
    NSString *city=[self.myOffersArray valueForKey:@"city"];
    if ([address isEqual:[NSNull null]] ) {
        address=@"";
    }
    if ([street isEqual:[NSNull null]] ) {
        street=@"";
    }
    if ([city isEqual:[NSNull null]] ) {
        city=@"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@",address,street,city];
    NSString *expDate=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"expiry_date"]];
    expDate=[expDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.dateLabel.text=[NSString stringWithFormat:@"%@",expDate];
    NSString *availDate=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"available_date"]];
    availDate=[availDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
    self.availableDate.text=[NSString stringWithFormat:@"%@",availDate];
    self.phoneNumber.text=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"business_phone"]];
    
    NSString *urlParameter = [NSString stringWithFormat:@"%@.jpg",[self.myOffersArray valueForKey:@"business_id"]];
    NSURL *businessLogoImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORBUSINESSUSER withURLParameter:urlParameter];
    [self.locationImageView sd_setImageWithURL:businessLogoImageUrl placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    self.shareCouponButton.userInteractionEnabled=NO;
    self.shareCouponSendImage.alpha=.5;
    self.shareCouponSendLabel.alpha=.5;
    if([[self.myOffersArray valueForKey:@"savedStatus"]isEqual:[NSNumber numberWithInt:0]]){
        self.surpriceSaveImageView.image=[UIImage imageNamed:@"homeBalckTicket"];
        self.surpriceSaveLabel.text=@"SAVE";
        self.surpriceSaveLabel.textColor=[UIColor colorWithRed:90.0f / 255.0f green:229.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
        self.surpriceSaveButton.userInteractionEnabled=YES;
    }else{
        self.surpriceSaveImageView.image=[UIImage imageNamed:@"homeGreenTicket"];
        self.surpriceSaveLabel.text=@"SAVED";
        self.surpriceSaveButton.userInteractionEnabled=NO;
        self.surpriceSaveLabel.textColor=[UIColor colorWithRed:0.06 green:0.64 blue:0.24 alpha:1.0];
    }
    
    if([self.dateLabel.text length]==0 ||[self.dateLabel.text isEqualToString:@"(null)"]){
        self.dateLabel.text=@"On going";
    }
}


//#pragma mark - Populating Ui from Bussiness owner
//
//-(void)PopulateUiFromBusinessOwner{
//    self.dealDecription.text=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"offerDescription"]];
//    self.dealNameLabel.text=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"offerName"]];
//    NSString *expDate=[NSString stringWithFormat:@"%@",[self.myOffersArray valueForKey:@"expiryDate"]];
//    expDate=[expDate convertDateWithInitialFormat:@"" ToDateWithFormat:@"MM/dd/yyyy"];
//    self.dateLabel.text=[NSString stringWithFormat:@"%@",expDate];
//    if([self.dateLabel.text length]==0){
//        self.dateLabel.text=@"On going";
//    }
//}

#pragma mark - View Action
- (IBAction)gradientTapAction:(id)sender {
    self.gradientView.hidden = YES;
}

-(void)backButtonAction:(UIButton *)backButton{
    if(self.isFromBusinessOwner){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.isCalledSave) {
            if(self.couponDelegate && [self.couponDelegate respondsToSelector:@selector(CouponBackPressed::)]){
                [self.couponDelegate CouponBackPressed:self.bussinessDetails :self.indexPath];
            }
        }
    }
}
- (IBAction)PhoneNumberTapAction:(id)sender {
    NSString *temp=[NSString stringWithFormat:@"Do you want to call %@ now?" ,self.phoneNumber.text];
    [self PhoneCall:temp];
}
- (IBAction)NavigateToAddress:(id)sender {
    [self AddressNavigation:@"Do you want navigation to this address?"];
}
- (IBAction)surpriceSaveAction:(id)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        [self SaveCoupon];
    }
    else{
        [self addLogInVC];
    }
}

- (IBAction)SaveAction:(id)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        [self SaveCoupon];
    }
    else{
        // [self.navigationController popViewControllerAnimated:NO];
        [self addLogInVC];
    }
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        SendToVC *sendToVC = [[SendToVC alloc] initWithNibName:@"SendToVC" bundle:nil];
        
      //testing prpose
       NSString *string=[NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
        //main server
//        NSString *string=[NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
        sendToVC.itemImageUrl =[NSURL URLWithString:string];
        sendToVC.myOffersArray=self.myOffersArray;
        sendToVC.bussinessDetails=self.bussinessDetails;
        [self.navigationController pushViewController:sendToVC animated:YES];
        self.gradientView.hidden = NO;
        
    }
    else{
        
        [self addLogInVC];
    }
    
    
    
    
}
- (IBAction)logoImageTapAction:(id)sender {
    [self addingFullImageControllerWithImagae:self.locationImageView.image withImageView:self.locationImageView];
}
- (IBAction)ShareAction:(id)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        SendToVC *sendToVC = [[SendToVC alloc] initWithNibName:@"SendToVC" bundle:nil];
        sendToVC.bussinessDetails=self.bussinessDetails;
        sendToVC.myOffersArray=self.myOffersArray;
        NSString *string;
        if(self.isFromSurpriseBox){
            
            //54.214.172.192:8080
            //testing purpose
           string=[NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"couponid"],[self.couponImagesArray objectAtIndex:0]];
            
            //main server
           // string=[NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"couponid"],[self.couponImagesArray objectAtIndex:0]];
        }
        else{
            
          //testing purpose
            string=[NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
            
            //main server
//            string=[NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
        }
        sendToVC.itemImageUrl =[NSURL URLWithString:string];
        [self.navigationController pushViewController:sendToVC animated:YES];
        
        
        self.gradientView.hidden = NO;
        
    }
    else{
        
        [self addLogInVC];
    }
    
}

#pragma mark - Alert for Log In or Register

-(void)addingAlertControllerForLogInOrRegister{
    UIAlertController *logInAlertController = [UIAlertController alertControllerWithTitle:AppName message:@"You have to register/login to use this feature of the application" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *logInAction = [UIAlertAction actionWithTitle:@"Log In" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addLogInVC];
    }];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"Register" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addLogInVC];
    }];
    [logInAlertController addAction:logInAction];
    [logInAlertController addAction:registerAction];
    [self presentViewController:logInAlertController animated:YES completion:nil];
}

-(void)addLogInVC{
    LoginViewController *logInVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:logInVC animated:YES completion:nil];
    });
}


#pragma mark - Full screen image showing library call

-(void)CouponImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView{
    [self addingFullImageControllerWithImagae:image withImageView:imageView];
}

-(void)addingFullImageControllerWithImagae:(UIImage *)fullImage withImageView:(UIImageView *)imageView{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark - Top Selection Collection View

- (void)CollectionViewInitial {
    [self registerCell];
    [self.swipeImageCollectionView setCollectionViewLayout:[self collectionViewLayout]];
    self.swipeImageCollectionView.delegate = self;
    self.swipeImageCollectionView.dataSource = self;
    self.swipeImageCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)registerCell {
    [self.swipeImageCollectionView registerNib: [UINib nibWithNibName:@"SwipeImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - UICollectionView Flow Layout

- (UICollectionViewFlowLayout *)collectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    return layout;
}

- (Class)collectionViewCellClass {
    return [UICollectionViewCell class];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.couponImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SwipeImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath ];
    cell.tag = indexPath.row;
    cell.couponCollectionViewDelegate=self;
    if(self.isFromBusinessOwner){
        Offers *offer = (Offers *)self.offerDetails;
        
        
        //testing pirpose
        cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[NSNumber numberWithLong:offer.offerID],[self.couponImagesArray objectAtIndex:0]];
        
        //main server
//        cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[NSNumber numberWithLong:offer.offerID],[self.couponImagesArray objectAtIndex:0]];
    }
    else if(self.isFromSurpriseBox){
        
          //testing pirpose
        cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"couponid"],[self.couponImagesArray objectAtIndex:0]];
        
         //main server
//        cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"couponid"],[self.couponImagesArray objectAtIndex:0]];
    }
    else{
         //testing pirpose
        cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
         //main server
//        cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 200);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    return YES;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0 ,0);
    
    return insets;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.swipeImageCollectionView.frame.size.width;
    float fractionalPage = self.swipeImageCollectionView.contentOffset.x / pageWidth;
    NSInteger Oripage = lround(fractionalPage);
    self.pageControl.currentPage = Oripage;
    self.previuosIndex = (int)Oripage;
}

#pragma mark - Save Coupon Api call

-(void)SaveCoupon{
    self.saveButton.userInteractionEnabled=NO;
    User *user=[User getUser];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlParameter;
    if(self.isFromSurpriseBox){
        urlParameter = [NSString stringWithFormat:@"user_id=%d&coupon_id=%@",user.user_id,[self.myOffersArray valueForKey:@"couponid"]];
    }
    else{
        urlParameter = [NSString stringWithFormat:@"user_id=%d&coupon_id=%@",user.user_id,[self.myOffersArray valueForKey:@"id"]];
    }
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:GLUEIMAGEURLFORSAVECOUPON withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        self.saveIcon.image=[UIImage imageNamed:@"homeGreenTicket"];
        self.saveLabel.text=@"Saved";
        self.saveButton.userInteractionEnabled=NO;
        self.saveLabel.textColor=[UIColor colorWithRed:0.06 green:0.64 blue:0.24 alpha:1.0];
        self.surpriceSaveLabel.text=@"SAVED";
        self.surpriceSaveImageView.image=[UIImage imageNamed:@"homeGreenTicket"];
        self.saveButton.userInteractionEnabled=NO;
        self.surpriceSaveLabel.textColor=[UIColor colorWithRed:0.06 green:0.64 blue:0.24 alpha:1.0];
        [self ShowAlert:[responseObject valueForKey:@"messageText"]];
        self.isCalledSave=YES;
        if(self.isFromSurpriseBox){
            [SurpriseBox updateSavedStatusWithCouponID:[self.myOffersArray valueForKey:@"couponid"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        self.saveButton.userInteractionEnabled=YES;
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:firstAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Showing Alert Controller

-(void)PhoneCall:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *phnoneNumber=[NSString stringWithFormat:@"tel://%@",self.phoneNumber.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phnoneNumber]];
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
    }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}

-(void)AddressNavigation:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Navigate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        //            NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=&daddr=%@,%@",[self.bussinessDetails valueForKey:@"latitude"], [self.bussinessDetails valueForKey:@"longitude"]];
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
        //        } else {
        //            [self ShowAlert:@"Please install google maps from appstore to avail this feature, Thankyou!"];
        NSString* url = [NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=&daddr=%@,%@",[self.bussinessDetails valueForKey:@"latitude"],[self.bussinessDetails valueForKey:@"longitude"]];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        //        }
        
    }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)useNow_btn:(id)sender {
    
    UseNoewDetailsVC *vc = [[UseNoewDetailsVC alloc] initWithNibName:@"UseNoewDetailsVC" bundle:nil];
    vc.myOffersArray=_myOffersArray;
    vc.bussinessDetails=self.bussinessDetails;
    vc.couponImagesArray=_couponImagesArray;
    //vc.couponDelegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
