//
//  BusinessOwnerVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 21/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Offers.h"
#import "ReviewsVC.h"
#import "NewOfferVC.h"
#import "BusinessUser.h"
#import "UserSettingsVC.h"
#import "BusinessOwnerVC.h"
#import "CouponDetailViewController.h"
#import "NewOfferTableCell.h"
#import "BusinessFavouritesVC.h"
#import "MapViewController.h"

@interface BusinessOwnerVC ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>
@property (nonatomic, strong) NSMutableArray *myOffersArray;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;
@property (weak, nonatomic) IBOutlet UIView *logoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UILabel *recommendCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *revieCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOffersLabel;

@end

@implementation BusinessOwnerVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self getOffersListsApi];
    [self populateBusinessDetails];
    [self addObserverForShowBusinessImage];
}

-(void)addObserverForShowBusinessImage{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionAfterBusineesImageUpload) name:DirectoryShowBusImage object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [self populateBusinessDetails];
    [self getOffersListsApi];
}
-(void)updateImage{
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSString *businessID=[NSString stringWithFormat:@"%lld.jpg?%@",busUser.business_id,busUser.business_image_cache];
    NSURL *finalProfImgUrlStg = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORBUSINESSUSER withURLParameter:businessID];
    [self.self.logoImageView sd_setImageWithURL:finalProfImgUrlStg placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"] options:SDWebImageRefreshCached completed:nil];
}

-(void)initialisation{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     [[Utilities standardUtilities]addGradientLayerTo:self.offerButton];
    self.offerButton.layer.cornerRadius = 5;
    self.logoContainerView.layer.borderWidth = 1;
    self.logoContainerView.layer.borderColor = [[UIColor colorWithRed:0.36 green:0.35 blue:0.42 alpha:0.2]CGColor];
    [self hidenavigationBar];
}

#pragma mark - Button Actions

- (IBAction)MapViewAction:(id)sender {
    MapViewController *myViewController = [[MapViewController alloc] initWithNibName:nil bundle:nil];
    myViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    myViewController.isFromBussinessUser=YES;
    [self presentViewController:myViewController animated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender {
    
    BusinessFavouritesVC *myViewController = [[BusinessFavouritesVC alloc] initWithNibName:nil bundle:nil];
    myViewController.isBusinessFavourites = NO;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:myViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
                         }];
    });
}
- (IBAction)commentButtonAction:(id)sender {
    ReviewsVC *myViewController = [[ReviewsVC alloc] initWithNibName:nil bundle:nil];
    myViewController.isFromBusUser = YES;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:myViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController
                           animated:YES
                         completion:nil];
    });
    
}

- (IBAction)LikeButtonAction:(id)sender {
    
    BusinessFavouritesVC *myViewController = [[BusinessFavouritesVC alloc] initWithNibName:nil bundle:nil];
    myViewController.isBusinessFavourites = YES;
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:myViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
                         }];
    });
}

#pragma mark - UITable View DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.myOffersArray.count == 0)
        self.noOffersLabel.hidden = NO;
    else
        self.noOffersLabel.hidden = YES;
    return self.myOffersArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewOfferTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewOfferTableCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.tag = indexPath.section;
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]],
                          [MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor lightGrayColor]]];
    cell.rightSwipeSettings.transition = MGSwipeStateSwippingLeftToRight;
    cell.offerDetails = [self.myOffersArray objectAtIndex:indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id temp=[self.myOffersArray objectAtIndex:indexPath.section];
    CouponDetailViewController *couponDetail = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:nil];
    couponDetail.isFromBusinessOwner =YES;
    couponDetail.offerDetails = temp;
    UINavigationController *couponDetailNavCntlr = [[UINavigationController alloc] initWithRootViewController:couponDetail];
    [self presentViewController:couponDetailNavCntlr animated:YES completion:nil];

    
    
}


#pragma mark - MGSwipe Delegates

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    Offers *offer = (Offers *)[self.myOffersArray objectAtIndex:cell.tag];
    if(index==0){
        [self deleteOfferWithOfferId:offer.offerID withSelectedIndex:cell.tag];
    }
    else if (index == 1){
        [self addingNewOfferPageWhetherFromEdit:YES andOfferDetails:offer];
    }
    return YES;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction{
    
    return YES;
}

-(void)deleteOfferWithOfferId:(int)offerId withSelectedIndex:(NSInteger)cellIndex{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:AppName
                                message: @"Do you want to delete this offer?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   [self deleteOfferApiWithOfferId:offerId withCellIndex:cellIndex];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addingEditOfferPageWith{
    
}


#pragma mark - Button Actions

- (IBAction)settingsButtonAction:(UIButton *)sender {
    UserSettingsVC *settingsVC = [[UserSettingsVC alloc] initWithNibName:@"UserSettingsVC" bundle:nil];
    UINavigationController *settingsNavCntrlr = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:settingsNavCntrlr animated:YES completion:nil];
    });

}


- (IBAction)newOfferButtonAction:(UIButton *)sender {
    [self addingNewOfferPageWhetherFromEdit:NO andOfferDetails:nil];
}

-(void)addingNewOfferPageWhetherFromEdit:(BOOL)isFromEdit andOfferDetails:(id)offerDetails{
    NewOfferVC *newOfferVC = [[NewOfferVC alloc] initWithNibName:@"NewOfferVC" bundle:nil];
    newOfferVC.isFromEdit = isFromEdit;
    newOfferVC.offerDetails = offerDetails;
    UINavigationController *newOfferNavCntrlr = [[UINavigationController alloc] initWithRootViewController:newOfferVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:newOfferNavCntrlr animated:YES completion:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Get Business Details Api

-(void)getBusinessDetailsApi {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%lld",busUser.business_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETBUSINESSDETAILS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [BusinessUser saveUserDetails:[responseObject valueForKey:@"data"]];
            [self populateBusinessDetails];
            [self updateImage];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Get Favourite Spots Api call

-(void)getOffersListsApi {
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%lld",busUser.business_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETOFFERLIST withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [Offers saveOffersListDetails:[responseObject valueForKey:@"data"]];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [self getBusinessDetailsApi];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self populateOfferTableView];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self getBusinessDetailsApi];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Calling Delete Offer Api

-(void)deleteOfferApiWithOfferId:(int)offerId withCellIndex:(NSInteger)cellIndex{
    NSString *urlParameter = [NSString stringWithFormat:@"offer_id=%d",offerId];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEDELETEOFFER withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [self deleteOfferFromLocalDbWithOfferID:offerId withCellIndex:cellIndex];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Delete Offer Image Api

//-(void)deleteOfferImageApiWithOfferId:(int)offerId withCellIndex:(NSInteger)cellIndex{
//    NSString *urlParameter = [NSString stringWithFormat:@"offer_id=%d",offerId];
//    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEDELETEOFFER withURLParameter:urlParameter];
//    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
//    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
//        
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//       
//    }];
//}

-(void)deleteOfferFromLocalDbWithOfferID:(int)offerID withCellIndex:(NSInteger)cellIndex{
    [Offers deleteOfferWithOfferId:[NSNumber numberWithInt:offerID]];
    [self.offerTableView beginUpdates];
    self.myOffersArray =[Offers getOffersList];
    [self.offerTableView deleteSections:[NSIndexSet indexSetWithIndex:cellIndex] withRowAnimation:UITableViewRowAnimationLeft];
    [self.offerTableView endUpdates];
}



#pragma mark - Populating Datas

-(void)populateOfferTableView{
    
    self.myOffersArray =[Offers getOffersList];
    
//    [self.offerTableView beginUpdates];
//    id object = [self.myOffersArray lastObject];
//    [self.myOffersArray removeLastObject];
//    [self.myOffersArray insertObject:object atIndex:0];
//    [self.offerTableView moveRowAtIndexPath:[NSIndexPath indexPathWithIndex:self.myOffersArray.count]
//                      toIndexPath:[NSIndexPath indexPathWithIndex:0]];
//    [self.offerTableView endUpdates];
    
    [self.offerTableView reloadData];
}

-(void)populateBusinessDetails{
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    self.businessNameLabel.text = busUser.businessName;
    self.phoneNoLabel.text = busUser.phone;
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
    NSString *openingTime  = [busUser.openingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"hh:mm a"];
    NSString *closingTime = [busUser.closingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"hh:mm a"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",openingTime,closingTime].lowercaseString;
    self.recommendCountLabel.text = [NSString stringWithFormat:@"%lld",busUser.recommendCount];
    self.revieCountLabel.text = [NSString stringWithFormat:@"%lld",busUser.reviewCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%lld",busUser.favoriteCount];
    if(!self.isFromRegister){
        [self loadingLogoImage];
    }
    
}

-(void)actionAfterBusineesImageUpload{
    [self loadingLogoImage];
}

-(void)loadingLogoImage{
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSString *businessID=[NSString stringWithFormat:@"%lld.jpg",busUser.business_id];
    NSURL *finalProfImgUrlStg = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORBUSINESSUSER withURLParameter:businessID];
    [self.self.logoImageView sd_setImageWithURL:finalProfImgUrlStg placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"] options:SDWebImageRefreshCached completed:nil];
    self.isFromRegister = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self populateOfferTableView];
}



@end
