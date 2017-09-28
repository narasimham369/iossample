//
//  ProductDetailViewController.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/16/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SendToVC.h"
#import "ProductDetailViewController.h"
#import "HomeDetailTableViewCell.h"
#import "CouponDetailViewController.h"
#import "ReviewsVC.h"
#import "MapInfoWindow.h"
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
#import "User.h"
#import "NSString+NSstring_Category.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import <MapKit/MapKit.h>



@interface ProductDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeDetailTableViewCellDelegate,CouponDelegate,MKMapViewDelegate>
@property (nonatomic, strong) id previewingContext;
@property (weak, nonatomic) IBOutlet UIImageView *IogoImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTop;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBotton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMapViewiewHeightConstrain;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (nonatomic, strong) NSMutableArray *myOffersArray;
@property (weak, nonatomic) IBOutlet UILabel *recomendCount;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bussinessTimeLabel;
@property (nonatomic) CLLocationDegrees  myLatitude;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (nonatomic) CLLocationDegrees  myLongitude;
@property (nonatomic) BOOL isFavoriteApiCalled;
@property (nonatomic) BOOL isFromImageRefresh;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet MKMapView *apppleMapView;

@end

@implementation ProductDetailViewController

#pragma mark - View LifeCycle

- (void)initView {
    [super initView];
    [self Custumisation];
    self.myOffersArray=[[NSMutableArray alloc]init];
    [self ListOffers];
    [self SaveUserClick];
    [self addingRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated{
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        self.TableActivityIndicator.hidden=YES;
        [self getBusinessDetailsApi];
    }
}

#pragma mark - Adding refresh control

-(void)addingRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.detailTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}
#pragma mark - Refresh Control Action

-(void)refreshTable{
    [self ListOffers];
}
#pragma mark - View Custumisation

-(void)Custumisation{
    self.scrollViewTop.delegate=self;
    self.scrollViewBotton.delegate=self;
    self.detailTableView.delegate=self;
    self.detailTableView.dataSource=self;
    [self.detailTableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.detailTableView.allowsMultipleSelectionDuringEditing = NO;
    [self showButtonOnLeftWithImageName:@""];
    self.openButton.layer.cornerRadius=4;
    if(self.isFromFavouriteSpots){
        [self converting];
    }else{
        [self PopulateUi];
        [self IntializingMap];
    }
}
-(void)converting{
    NSMutableDictionary *details = [[NSMutableDictionary alloc]init];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"review_count"] forKey:@"review_count"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"recommentation_count"] forKey:@"recommentation_count"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"businessID"] forKey:@"business_id"];
    [details setValue:[self.bussinessDummyDetails valueForKey:@"openingTime"] forKey:@"opening_time"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"closingTime"] forKey:@"closing_time"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"businessName"] forKey:@"business_name"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"businessPhone"] forKey:@"business_phone"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"latitude"] forKey:@"latitude"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"longitude"] forKey:@"longitude"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"businessAddress"] forKey:@"business_address"];
    [details setValue:[self.bussinessDummyDetails  valueForKey:@"favouriteCount"] forKey:@"favorite_spot_count"];
    self.bussinessDetails = details;
    [self PopulateUi];
    [self IntializingMap];
    self.likeImageView.image=[UIImage imageNamed:@"likeGreen"];
    self.favoriteButton.userInteractionEnabled=NO;
}

#pragma mark - Map Initialization

- (void)IntializingMap{
    [self.apppleMapView removeAnnotations:self.apppleMapView.annotations];
    self.apppleMapView.delegate = self;
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.0;
    latitude=[[self.bussinessDetails valueForKey:@"latitude"]doubleValue];
    longitude=[[self.bussinessDetails valueForKey:@"longitude"]doubleValue];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    annotation.title=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"business_id"]];
    [self.apppleMapView addAnnotation:annotation];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 700, 0);
    [self.apppleMapView setRegion:[self.apppleMapView regionThatFits:region] animated:YES];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView *test=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"reuse"];
    MKPointAnnotation * anotation = test.annotation;
    if(![anotation.title isEqualToString:@"My Location"]){
        MapInfoWindow *MarkerView =  [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow" owner:self options:nil] objectAtIndex:0];
        test.image=[UIImage imageNamed:@"mapTouch"];
        MarkerView .frame=CGRectMake(test.frame.origin.x, test.frame.origin.y, test.frame.size.width-24, test.frame.size.height-10);
        NSString *imageUrl;
        if(self.isFromImageRefresh){
            imageUrl = anotation.title;
            self.isFromImageRefresh=NO;
        }else{
            
        //54.214.172.192:8080
            //testing purpose
            //imageUrl = [NSString stringWithFormat:@"%@""%@.jpg",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",anotation.title];
            
        //main server
      imageUrl = [NSString stringWithFormat:@"%@""%@.jpg",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",anotation.title];
        }
        MarkerView.ImageUrl=imageUrl;
        [test addSubview:MarkerView];
        MarkerView.layer.shadowColor=[[UIColor lightGrayColor]colorWithAlphaComponent:.8].CGColor;
        MarkerView.layer.shadowOffset= CGSizeMake(0, 1);
        MarkerView.layer.shadowOpacity=1;
        MarkerView.layer.shadowRadius= 1.0;
        MarkerView.layer.cornerRadius= 5.0;
        MarkerView.clipsToBounds= NO;
        MarkerView.userInteractionEnabled=YES;
        MarkerView.userInteractionEnabled=NO;
        test.image=[UIImage imageNamed:@"mapTouch"];
        [test setUserInteractionEnabled:YES];
        [test setCanShowCallout:NO];
    }else{
        return nil;
    }
    return test;
    
}

-(void)homeDetailImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView{
    [self addingFullImageControllerWithImagae:image withImageView:imageView];
}

-(void)addingFullImageControllerWithImagae:(UIImage *)fullImage withImageView:(UIImageView *)imageView{
//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    imageInfo.image = imageView.image;
//    imageInfo.referenceRect = imageView.frame;
//    imageInfo.referenceView = imageView.superview;
//    imageInfo.referenceContentMode = imageView.contentMode;
//    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
//    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(void)PopulateUi{
    self.title=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"business_name"]];
    self.recomendCount.text=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"recommentation_count"]];
    self.reviewCount.text=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"review_count"]];
    self.favoriteCount.text=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"favorite_spot_count"]];
    self.phoneNumberLabel.text=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"business_phone"]];
    NSString *city=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"city"]];
    NSString *state_name=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"state_name"]];
    NSString *business_address=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"business_address"]];
    if([city isEqualToString:@"(null)"]){
        city=@"";
    }
    if([state_name isEqualToString:@"(null)"]){
        state_name=@"";
    }
    self.addressLabel.text=[NSString stringWithFormat:@"%@, %@, %@",business_address,city,state_name];
    NSString *openingTime=[self.bussinessDetails valueForKey:@"opening_time"];
    openingTime=[openingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"hh:mm a"];
    NSString *closingTime=[self.bussinessDetails valueForKey:@"closing_time"];
    closingTime=[closingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"hh:mm a"];
    self.bussinessTimeLabel.text=[NSString stringWithFormat:@"%@ - %@",openingTime,closingTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *startTime=[self.bussinessDetails valueForKey:@"opening_time"];
    NSString *time1=[self.bussinessDetails valueForKey:@"closing_time"];
    NSString *time2 = [formatter stringFromDate:currentDate];
    
    NSDate *timeOfOpening= [formatter dateFromString:startTime];
    NSDate *timeOfClosing= [formatter dateFromString:time1];
    NSDate *CurrentTime = [formatter dateFromString:time2];
    
    NSComparisonResult result = [timeOfClosing compare:CurrentTime];
    NSComparisonResult result1 = [timeOfOpening compare:CurrentTime];
    
    if(result == NSOrderedDescending && result1== NSOrderedAscending)
    {
        self.openButton.backgroundColor=[UIColor colorWithRed:90.0f / 255.0f green:229.0f / 255.0f blue:168.0f / 255.0f alpha:1.0f];
        [self.openButton setTitle:@"OPEN" forState:UIControlStateNormal];

    }else{
        self.openButton.backgroundColor=[UIColor colorWithRed:1.0f green:36.0f / 255.0f blue:36.0f / 255.0f alpha:1.0f];
        [self.openButton setTitle:@"CLOSED" forState:UIControlStateNormal];
    }
  
    if([self.bussinessDetails valueForKey:@"favoritedStatus"]){
        if([[self.bussinessDetails valueForKey:@"favoritedStatus"]isEqual:[NSNumber numberWithInt:0]]){
            self.likeImageView.image=[UIImage imageNamed:@"likeSmall"];
            self.favoriteButton.userInteractionEnabled=YES;
        }else{
            self.likeImageView.image=[UIImage imageNamed:@"likeGreen"];
            self.favoriteButton.userInteractionEnabled=NO;
        }
    }
}

#pragma mark - View Actions

-(void)backButtonAction:(UIButton *)backButton{
    if(self.isFromFavouriteSpots){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)CouponBackPressed:(id)updatedValue :(NSInteger)index{
    NSMutableDictionary *commentadd = [[self.myOffersArray objectAtIndex:index] mutableCopy];
    [commentadd setValue:[NSNumber numberWithInteger:1] forKey:@"savedStatus"];
    [self.myOffersArray replaceObjectAtIndex:index withObject:commentadd];
    [self.detailTableView reloadData];
}

- (IBAction)ReviewsButtonAction:(id)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        ReviewsVC *vc = [[ReviewsVC alloc] initWithNibName:@"ReviewsVC" bundle:nil];
        vc.bussinessDetails=self.bussinessDetails;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self addLogInVC];
    }
    
}
- (IBAction)PhoneNumberAction:(id)sender {
    NSString *temp=[NSString stringWithFormat:@"Do you want to call %@ now?" ,self.phoneNumberLabel.text];
    [self PhoneCall:temp];
}

- (IBAction)AddressAction:(id)sender {
    [self AddressNavigation:@"Do you want navigation to this address?"];

}

- (IBAction)AddFavoriteButton:(id)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        [self AddToFavorite];
    }
    else{
        [self addLogInVC];
    }
    
}

- (IBAction)ReccomentsButtonAction:(id)sender {
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        SendToVC *sendToVC = [[SendToVC alloc] initWithNibName:@"SendToVC" bundle:nil];
        sendToVC.isFromProductDetail = YES;
        sendToVC.bussinessDetails=self.bussinessDetails;
        NSString *profileId=[NSString stringWithFormat:@"%@.jpg",[self.bussinessDetails valueForKey:@"business_id"]];
        
        //54.214.172.192:8080
        //testing purpose
       // NSString *temp= [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
       // main server
   NSString *temp= [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
        sendToVC.itemImageUrl=[NSURL URLWithString:temp];
        sendToVC.bussinessId=[NSString stringWithFormat:@"%@",[self.bussinessDetails valueForKey:@"business_id"]];
        
         [self.navigationController pushViewController:sendToVC animated:YES];
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


#pragma mark - UISCrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView==self.detailTableView){
    }else{
        CGFloat offset=scrollView.contentOffset.y;
        CGFloat percentage=offset/self.topMapViewiewHeightConstrain.constant;
        CGFloat value=self.topMapViewiewHeightConstrain.constant*percentage;
        if (percentage < 0.00) {
            [self.scrollViewBotton setContentOffset:CGPointMake(0, 0)];
        } else if (value > 130) {
        } else {
            float yoffset = self.scrollViewBotton.contentOffset.y*0.3;
            [self.scrollViewTop setContentOffset:CGPointMake(scrollView.contentOffset.x,yoffset) animated:NO];
        }
    }}

#pragma mark - UITableView  Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    ([self.myOffersArray count]==0)?(self.emptyDataLabel.hidden=NO):(self.emptyDataLabel.hidden=YES);
    return self.myOffersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailTableViewCell *cell = (HomeDetailTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeDetailTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.tag = indexPath.section;
    cell.homeDetailCellDelegate = self;
    NSDictionary *dict =[self.myOffersArray objectAtIndex:indexPath.section];
    NSString *savedStatutus = [dict valueForKey:@"savedStatus"];
    NSString* expiry_date =[dict valueForKey:@"expiry_date"];
       NSString* coupon_type =[dict valueForKey:@"coupon_type"];
    
    
   if([savedStatutus isEqual:[NSNumber numberWithInt:1]])
   {
        if([expiry_date isEqual:(NSString *)[NSNull null]] || [coupon_type isEqual:[NSNumber numberWithInt:2]])
        {
            
    cell.offerListDict=[self.myOffersArray objectAtIndex:indexPath.section];
            _isAdjustCellhight =NO;
            
        }
       
       else
       {
            cell.hidden = YES;
            _isAdjustCellhight =YES;
       }
   }
    else if([savedStatutus isEqual:[NSNumber numberWithInt:0]])
    {
      cell.offerListDict=[self.myOffersArray objectAtIndex:indexPath.section];
        _isAdjustCellhight =NO;
    }
    else
    {
      cell.hidden = YES;
        _isAdjustCellhight =YES;
    }
    
    
    
    return cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   // HomeDetailTableViewCell *cell ;
    if(_isAdjustCellhight== YES)
    {
        return 0;
    }
    else
    {
    return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id temp=[self.myOffersArray objectAtIndex:indexPath.section];
    CouponDetailViewController *vc = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:nil];
    vc.myOffersArray=temp;
    vc.bussinessDetails=self.bussinessDetails;
    vc.couponImagesArray=[temp valueForKey:@"files"];
    vc.indexPath=indexPath.section;
    vc.couponDelegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Home Table View Cell Delegates

-(void)shareButtonActionDelegate:(UIImage *)image{
    SendToVC *sendToVC = [[SendToVC alloc] initWithNibName:@"SendToVC" bundle:nil];
    [self.navigationController pushViewController:sendToVC animated:YES];
}

#pragma mark - Get OfferList Api call

-(void)ListOffers {
    if(!self.isFavoriteApiCalled){
        self.isFavoriteApiCalled=YES;
        User *user=[User getUser];
        if([self.myOffersArray count]==0){
            self.TableActivityIndicator.hidden=NO;
            [self.TableActivityIndicator startAnimating];
        }
        NSString *urlParameter = [NSString stringWithFormat:@"business_id=%@&status=%d&user_id=%d",[self.bussinessDetails valueForKey:@"business_id"],1,user.user_id];
        NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETOFFERLISTBYSTATUS withURLParameter:urlParameter];
        NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
        [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
            [self.myOffersArray removeAllObjects];
            self.TableActivityIndicator.hidden=YES;
            self.isFavoriteApiCalled=NO;
            [self.TableActivityIndicator stopAnimating];
            [self.myOffersArray addObjectsFromArray:[responseObject valueForKey:@"data"]];
            [self.detailTableView reloadData];
            [self.refreshControl endRefreshing];
        } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
            [self.TableActivityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
            self.TableActivityIndicator.hidden=YES;
            self.isFavoriteApiCalled=NO;
            [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
        }];
    }
}
#pragma mark - Get Business Details Api

-(void)getBusinessDetailsApi {
    User *user=[User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%@&&user_id=%d",[self.bussinessDetails valueForKey:@"business_id"],user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETFAVORITEDETAILS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            self.bussinessDetails=[responseObject valueForKey:@"data"];
            [self PopulateUi];
            [self imageRefresh];
            
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
-(void)imageRefresh{
        [self.apppleMapView removeAnnotations:self.apppleMapView.annotations];
        self.apppleMapView.delegate = self;
        CLLocationDegrees latitude = 0.0;
        CLLocationDegrees longitude = 0.0;
        latitude=[[self.bussinessDetails valueForKey:@"latitude"]doubleValue];
        longitude=[[self.bussinessDetails valueForKey:@"longitude"]doubleValue];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coord];
    
   // 54.214.172.192:8080
    
    //test purpose
  //  NSString *imageUrl = [NSString stringWithFormat:@"%@""%@.jpg?%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",[self.bussinessDetails valueForKey:@"business_id"],[self.bussinessDetails valueForKey:@"business_image_cache"]];
    
    //main server
      NSString *imageUrl = [NSString stringWithFormat:@"%@""%@.jpg?%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",[self.bussinessDetails valueForKey:@"business_id"],[self.bussinessDetails valueForKey:@"business_image_cache"]];
        annotation.title=imageUrl;
        [self.apppleMapView addAnnotation:annotation];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 700, 0);
        [self.apppleMapView setRegion:[self.apppleMapView regionThatFits:region] animated:YES];
        self.isFromImageRefresh=YES;
}

#pragma mark - SaveUserClick Api

-(void)SaveUserClick {
    User *user=[User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"user_id=%d&&business_id=%@",user.user_id,[self.bussinessDetails valueForKey:@"business_id"]];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESAVEUSER withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
    }];
}
#pragma mark - Get OfferList Api call

-(void)AddToFavorite {
    User *user=[User getUser];
    [MBProgressHUD showHUDAddedTo:self.detailTableView  animated:YES];
    NSString *urlParameter = [NSString stringWithFormat:@"user_id=%d&business_id=%@",user.user_id,[self.bussinessDetails valueForKey:@"business_id"]];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:GLUEIMAGEURLFORADDFAVORITE withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        NSLog(@"%@",responseObject);
        self.likeImageView.image=[UIImage imageNamed:@"likeGreen"];
        self.favoriteButton.userInteractionEnabled=NO;
        long long count=[[self.bussinessDetails valueForKey:@"favorite_spot_count"] longLongValue];
        self.favoriteCount.text=[NSString stringWithFormat:@"%lld",count+1];
        [MBProgressHUD hideAllHUDsForView:self.detailTableView  animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.detailTableView  animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Get Favourite Spots Api call

-(void)recommendBusinessApi {
    User *user = [User getUser];
    NSNumber *userId = [NSNumber numberWithLong:user.user_id];
    NSString *dataString = [NSString stringWithFormat:@"recommended_by=%@&recommend_count=1&business_id=%@",userId,[self.bussinessDetails valueForKey:@"business_id"]];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPERECOMMENDBUSINESS withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:dataString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
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
        NSString *phnoneNumber=[NSString stringWithFormat:@"tel://%@",self.phoneNumberLabel.text];
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
            NSString* url = [NSString stringWithFormat: @"http://maps.apple.com/maps?saddr=&daddr=%@,%@",[self.bussinessDetails valueForKey:@"latitude"],[self.bussinessDetails valueForKey:@"longitude"]];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
    }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}


@end
