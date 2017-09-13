//
//  FavouriteSpotsVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "User.h"
#import "JTSImageInfo.h"
#import "Utilities.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "UrlGenerator.h"
#import "MyFavouriteSpots.h"
#import "FavouriteSpotsVC.h"
#import "ProductDetailViewController.h"
#import "CouponDetailViewController.h"
#import "JTSImageViewController.h"
#import "FavouriteTableViewCell.h"

@interface FavouriteSpotsVC ()<UIGestureRecognizerDelegate,UISearchBarDelegate,UIScrollViewDelegate,FavouriteSpotImageDelegate>
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) CALayer *layerS;
@property (nonatomic, strong) NSArray *mySpotsArray;
@property (weak, nonatomic) IBOutlet UIView *spotSearchView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (nonatomic, strong) NSArray *dummySpotsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *noSpotslabel;
@property (weak, nonatomic) IBOutlet UISearchBar *spotSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *favouriteSpotTableView;

@end

@implementation FavouriteSpotsVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self addingRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Intialization

-(void)initialisation{
    self.title = @"Favorite Spots";
    [self showButtonOnLeftWithImageName:@""];
    UITextField *field = [self.spotSearchBar valueForKey:@"_searchField"];
    field.font = [UIFont fontWithName:@"Dosis-Regular" size:17.0];
    self.mySpotsArray =[MyFavouriteSpots getMyFavouriteSpots];
    self.dummySpotsArray = self.mySpotsArray;
    [self.favouriteSpotTableView reloadData];
     [self getMyFavouriteSpotsApi];
    self.gradientView.hidden = YES;
    self.layerS = self.spotSearchView.layer;
    self.spotSearchView.layer.cornerRadius =2;
    self.layerS.shadowOffset = CGSizeMake(.5,.5);
    self.layerS.shadowColor = [[UIColor blackColor] CGColor];
    self.layerS.shadowRadius = 2.0f;
    self.layerS.shadowOpacity = 0.40f;
    self.spotSearchBar.layer.borderWidth = 1;
    self.spotSearchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
//    [self check3DTouch];

}

-(void)viewDidLayoutSubviews{
    self.layerS.shadowPath = [[UIBezierPath bezierPathWithRect:self.layerS.bounds] CGPath];
}
//- (void)check3DTouch {
//    
//    // register for 3D Touch (if available)
//    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//        
//        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
//        NSLog(@"3D Touch is available! Hurra!");
//        
//        // no need for our alternative anymore
//        self.longPress.enabled = NO;
//        
//    } else {
//        
//        NSLog(@"3D Touch is not available on this device. Sniff!");
//        
//        // handle a 3D Touch alternative (long gesture recognizer)
//        self.longPress.enabled = YES;
//        
//    }
//}

//#pragma mark - Previewing delegate
//
//- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
//{
////    UIViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
////    
////    detailVC.preferredContentSize = CGSizeMake(0.0, 320.0);
//    ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
//    vc.isFromFavouriteSpots=YES;
////    vc.bussinessDummyDetails=temp;
////    [self.navigationController pushViewController:vc animated:YES];
//    
//   // previewingContext.sourceRect = self.btnDetail.frame;
//    
//    return vc;
//}

//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
//{
//    [self showViewController:viewControllerToCommit sender:self];
//    [self dismissViewControllerAnimated:viewControllerToCommit completion:nil];
//}

#pragma mark - Adding refresh control

-(void)addingRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.favouriteSpotTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshTable{
    [self getMyFavouriteSpotsApi];
}

#pragma mark - View Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapAction:(id)sender {
    self.gradientView.hidden = YES;
    [self.view endEditing:YES];
}

#pragma mark - Full screen image library call

-(void)favouriteSpotImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView{
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

#pragma mark - UITable View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.mySpotsArray.count == 0)
        self.noSpotslabel.hidden = NO;
    else
        self.noSpotslabel.hidden = YES;
    return self.mySpotsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavouriteTableViewCell *cell = (FavouriteTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavouriteTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.myFavouiteSpotDetails = [ self.mySpotsArray objectAtIndex:indexPath.section];
    cell.tag = indexPath.section;
    cell.favouriteSpotImageDelegate = self;
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id temp=[self.mySpotsArray objectAtIndex:indexPath.section];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    vc.isFromFavouriteSpots=YES;
    vc.bussinessDummyDetails=temp;
//    vc.couponImagesArray = [[NSMutableArray alloc]init];
//    [vc.couponImagesArray addObject:[temp valueForKey:@"firstImageFileName"]];
    [self.navigationController pushViewController:vc animated:YES];
 
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id temp=[self.mySpotsArray objectAtIndex:indexPath.section];
    [self RemoveOfferConfirmWithData:temp tableView:tableView WithSection:indexPath.section];
}

-(void)RemoveOfferConfirmWithData:(id)temp tableView:(UITableView*)table WithSection:(NSUInteger)Section{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:AppName
                                message: @"Do you want to delete this spot?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   
                                                   [self RemoveOfferApi:temp tableView:table WithSection:Section];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Search bar Button Action

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.gradientView.hidden = YES;
    [self searchFavouriteSpotsList];
    [self.favouriteSpotTableView reloadData];
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""] || [searchText isEqualToString:@"Search"]){
        self.gradientView.hidden = NO;
    }
    else{
        self.gradientView.hidden = YES;
    }
    if([searchText length] != 0) {
        [self searchFavouriteSpotsList];
    }
    else{
        self.mySpotsArray = self.dummySpotsArray;
    }
    [self.favouriteSpotTableView reloadData];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.gradientView.hidden = NO;
    return YES;
}

#pragma mark - searchlist

-(void)searchFavouriteSpotsList{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.businessName contains[cd] %@",self.spotSearchBar.text];
    NSArray *searchResults = [self.dummySpotsArray filteredArrayUsingPredicate:predicate];
    self.mySpotsArray = searchResults;
}


#pragma mark - Get Favourite Spots Api call

-(void)getMyFavouriteSpotsApi {
    User *user = [ User getUser];
    if(self.mySpotsArray.count == 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSString *urlParameter = [NSString stringWithFormat:@"%d",user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETMYFAVOURITESPOTS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MyFavouriteSpots deleteAllEntries];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(![[responseObject valueForKey:@"data"] isEqual:[NSNull null]]){
            [MyFavouriteSpots saveMyFavouriteSpotsDetails:[responseObject valueForKey:@"data"]];
        }
        self.mySpotsArray =[MyFavouriteSpots getMyFavouriteSpots];
        self.dummySpotsArray=self.mySpotsArray;
        [self.favouriteSpotTableView reloadData];
         [self.refreshControl endRefreshing];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.refreshControl endRefreshing];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Calling Delete Offer Api

-(void)RemoveOfferApi:(id)temp tableView:(UITableView*)table WithSection:(NSUInteger)Section{
     User *user = [ User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"user_id=%d&business_id=%@",user.user_id,[temp valueForKey:@"businessID"]];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEREMOVEUSERFAVORITES withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [table beginUpdates];
            [MyFavouriteSpots RemoveOfferWithBussinessId:[temp valueForKey:@"businessID"]];
            self.mySpotsArray =[MyFavouriteSpots getMyFavouriteSpots];
            self.dummySpotsArray=self.mySpotsArray;
            [table deleteSections:[NSIndexSet indexSetWithIndex:Section]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
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


@end
