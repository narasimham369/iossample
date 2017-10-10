//
//  SavedCouponViewController.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "User.h"
#import "Utilities.h"
#import "SendToVC.h"
#import "UrlGenerator.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "SavedCoupons.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "SavedCouponViewController.h"
#import "HomeDetailTableViewCell.h"
#import "CouponDetailViewController.h"


@interface SavedCouponViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchBarDelegate,HomeDetailTableViewCellDelegate,UISearchBarDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) CALayer *layers;
@property (nonatomic, strong) NSArray *myCouponsArray;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *dummyCouponArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *couponsSearchBar;
@property (weak, nonatomic) IBOutlet UILabel *noSavedCouponslabel;
@property (weak, nonatomic) IBOutlet UITableView *savedCouponTableView;

@end

@implementation SavedCouponViewController

#pragma mark - View LifeCycle

- (void)initView {
    [super initView];
    [self Custumisation];
    [self addingRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidLayoutSubviews{
    self.layers.shadowPath = [[UIBezierPath bezierPathWithRect:self.layers.bounds] CGPath];
}

#pragma mark - View Custumisation

-(void)Custumisation{
    [self showButtonOnLeftWithImageName:@""];
    self.title=@"Coupons";
    UITextField *field = [self.couponsSearchBar valueForKey:@"_searchField"];
    field.font = [UIFont fontWithName:@"Dosis-Regular" size:17.0];
    self.noSavedCouponslabel.hidden = YES;
    self.myCouponsArray =[SavedCoupons getSavedCoupons];
    self.dummyCouponArray = self.myCouponsArray;
    [self.savedCouponTableView reloadData];
    [self getSavedCouponsApi];
    self.gradientView.hidden = YES;
    self.layers = self.searchView.layer;
    self.layers.shadowOffset = CGSizeMake(.5,.5);
    self.layers.shadowColor = [[UIColor blackColor] CGColor];
    self.layers.shadowRadius = 2.0f;
    self.layers.shadowOpacity = 0.40f;
    self.searchView.layer.cornerRadius =2;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.savedCouponTableView.delegate=self;
    self.savedCouponTableView.dataSource=self;
    [self.savedCouponTableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.savedCouponTableView.allowsMultipleSelectionDuringEditing = NO;
    
}

#pragma mark - Adding refresh control

-(void)addingRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.savedCouponTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Refresh Control Action

-(void)refreshTable{
    [self getSavedCouponsApi];
}

#pragma mark - View Actions

- (IBAction)tapAction:(id)sender {
    self.gradientView.hidden = YES;
    [self.view endEditing:YES];
    
}

-(void)backButtonAction:(UIButton *)backButton{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search bar Button Action

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.gradientView.hidden = YES;
    [self searchCouponsList];
    [self.savedCouponTableView reloadData];
    [self.view endEditing:YES];}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""] || [searchText isEqualToString:@"Search"]){
        self.gradientView.hidden = NO;
    }
    else{
        self.gradientView.hidden = YES;
    }
    if([searchText length] != 0) {
        [self searchCouponsList];
    }
    else{
        self.myCouponsArray = self.dummyCouponArray;
    }
    [self.savedCouponTableView reloadData];
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

-(void)searchCouponsList{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.couponName contains[cd] %@",self.couponsSearchBar.text];
    NSArray *searchResults = [self.dummyCouponArray filteredArrayUsingPredicate:predicate];
    self.myCouponsArray = searchResults;
}

#pragma mark - UITableView  Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.myCouponsArray.count == 0)
        self.noSavedCouponslabel.hidden = NO;
    else
        self.noSavedCouponslabel.hidden = YES;
    return self.myCouponsArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeDetailTableViewCell *cell = (HomeDetailTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeDetailTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.mySavedCouponsDetails = [ self.myCouponsArray objectAtIndex:indexPath.section];
    cell.tag = indexPath.section;
    cell.saveIcon.hidden=YES;
    cell.homeDetailCellDelegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id temp=[self.myCouponsArray objectAtIndex:indexPath.section];
    CouponDetailViewController *vc = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:nil];
    vc.isFromSavedCoupon=YES;
    vc.myOffersArray=temp;
    vc.couponImagesArray = [[NSMutableArray alloc]init];
    [vc.couponImagesArray addObject:[temp valueForKey:@"firstImageFileName"]];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id temp=[self.myCouponsArray objectAtIndex:indexPath.section];
    [self RemoveCouponConfirmWithData:temp tableView:tableView WithSection:indexPath.section];
}

-(void)RemoveCouponConfirmWithData:(id)temp tableView:(UITableView*)table WithSection:(NSUInteger)Section{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:AppName
                                message: @"Do you want to delete this coupon from your saved list?"
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

#pragma mark - Home Table View Cell Delegate

-(void)shareButtonActionDelegate:(UIImage *)image{
    SendToVC *sendToVC = [[SendToVC alloc] initWithNibName:@"SendToVC" bundle:nil];
    [self.navigationController pushViewController:sendToVC animated:YES];
}

#pragma mark - Full screen image Library call

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


#pragma mark - Get Favourite Spots Api call

-(void)getSavedCouponsApi {
    if(self.myCouponsArray.count == 0){
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    User *user = [User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"%d",user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETSAVEDCOUPONS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [SavedCoupons deleteAllEntries];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(![[responseObject valueForKey:@"data"] isEqual:[NSNull null]]){
        [SavedCoupons savedCouponsDetails:[responseObject valueForKey:@"data"]];
        }
        self.myCouponsArray =[SavedCoupons getSavedCoupons];
        NSLog(@"%@",self.myCouponsArray);
        self.dummyCouponArray = self.myCouponsArray;
        [self.savedCouponTableView reloadData];
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
    NSString *urlParameter = [NSString stringWithFormat:@"user_id=%d&coupon_id=%@",user.user_id,[temp valueForKey:@"id"]];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEREMOVEUSERSAVEDCOUPON withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [table beginUpdates];
            [SavedCoupons deleteOfferWithOfferId:[temp valueForKey:@"id"]];
            self.myCouponsArray =[SavedCoupons getSavedCoupons];
            self.dummyCouponArray=self.myCouponsArray;
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
