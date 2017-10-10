//
//  SayThanksVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 02/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "NewOfferVC.h"
#import "SayThanksVC.h"
#import "BusinessUser.h"
#import "Racommendations.h"
#import <MessageUI/MessageUI.h>
#import "BusinessUser.h"


#import <CLToolKit/UIKitExt.h>
#import "SayThanksTableCell.h"
#import "SayThankYouCustomView.h"
#import "BussinessFavorite.h"


@interface SayThanksVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchBarDelegate,ThankYouViewDelegate,SayThanksTableViewCelleDelegate,MFMailComposeViewControllerDelegate,NewOfferVCDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) CALayer *layerS;
@property (nonatomic, strong) NSArray *dummyArray;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong) NSArray *recomendersArray;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *noRecomendLabel;
@property (weak, nonatomic) IBOutlet UITableView *sayThanksTableView;

@property (nonatomic, strong) NSMutableArray *selctedItemsArray;
@property (nonatomic) BOOL isSelectedAll;

@end

@implementation SayThanksVC

- (void)initView {
    [super initView];
    [self initialisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialisation{
    [self showButtonOnRightWithImageName:@"nilCheck"];
    self.gradientView.hidden = YES;
    [[Utilities standardUtilities]addGradientLayerTo:self.sendButton];
    UITextField *field = [self.searchBar valueForKey:@"_searchField"];
    field.font = [UIFont fontWithName:@"Dosis-Regular" size:17.0];
    self.sendButton.layer.cornerRadius = 5;
    self.layerS = self.searchView.layer;
    self.searchView.layer.cornerRadius =2;
    self.layerS.shadowOffset = CGSizeMake(.5,.5);
    self.layerS.shadowColor = [[UIColor blackColor] CGColor];
    self.layerS.shadowRadius = 2.0f;
    self.layerS.shadowOpacity = 0.40f;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self showButtonOnLeftWithImageName:@"closeIcon"];
    if(self.isFromSpecialCoupon){
        [self.sendButton setTitle:@"Next" forState:UIControlStateNormal];
    }
    self.selctedItemsArray = [[NSMutableArray alloc] init];
    
    
    if(self.isBusinessFavourites){
        self.title = @"Those who Favorites";
        [self populatingFavorites];
    }else{
        self.title = @"Those who Recommends";
        [self populatingRecommendations];
    }
}

-(void)populatingRecommendations{
    self.recomendersArray = [Racommendations getAllRecommendations];
    self.dummyArray = self.recomendersArray;
    [self.sayThanksTableView reloadData];
}
-(void)populatingFavorites{
    self.recomendersArray = [BussinessFavorite getAllFavoritesUsers];
    self.dummyArray = self.recomendersArray;
    [self.sayThanksTableView reloadData];
}

-(void)rightButtonAction:(UIButton *)rightButton{
    if(!self.isSelectedAll){
        [self showButtonOnRightWithImageName:@"whiteTickIcon"];
        [self MarkAllUsers];
        self.isSelectedAll=YES;
    }else{
        [self showButtonOnRightWithImageName:@"nilCheck"];
        self.isSelectedAll=NO;
        [self.selctedItemsArray removeAllObjects];
        [self.sayThanksTableView reloadData];
    }
}

-(void)MarkAllUsers{
    [self.selctedItemsArray removeAllObjects];
    if(self.isBusinessFavourites){
        if(self.isFromSpecialCoupon){
            [self.selctedItemsArray addObjectsFromArray:[BussinessFavorite getAllActiveUsers]];
        }else{
            [self.selctedItemsArray addObjectsFromArray:[BussinessFavorite getAllFavoritesUsers]];
        }
    }else{
        if(self.isFromSpecialCoupon){
            [self.selctedItemsArray addObjectsFromArray:[Racommendations getAllActiveUsers]];
        }else{
            [self.selctedItemsArray addObjectsFromArray:[Racommendations getAllRecommendations]];
        }
    }
    [self.sayThanksTableView reloadData];
}

#pragma mark - Button Actionss

-(void)backButtonAction:(UIButton *)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonAction:(id)sender {
    if(self.isFromSpecialCoupon){
        if(self.selctedItemsArray.count>0)
            [self addingNewOfferVC];
        else
            [[Utilities standardUtilities] showMessageAlertControllerInController:self withAlertMessage:@"Please select users"];
    }
    else{
        if(self.selctedItemsArray.count>0){
            if(self.isBusinessFavourites){
                [self callingFaviriteSayThanksApi];
            }else{
                [self callingSayThanksApi];
            }
//            NSString *message;
//            if(self.isBusinessFavourites){
//                message=[NSString stringWithFormat:@"Thank you for adding us to your favorite spot! We’ll do our best to keep you satisfy!"];
//            }else{
//                message=[NSString stringWithFormat:@"Thank you for recommending us! We appreciate your support!"];
//            }
//            [self addingMailComposerWithMessageBody:message]; // [self addingSayThankYouCustomView];
        }else{
            [[Utilities standardUtilities] showMessageAlertControllerInController:self withAlertMessage:@"Please select users"];
        }
    }
}

-(void)addingSayThankYouCustomView{
    SayThankYouCustomView *customThankYou = [[[NSBundle mainBundle] loadNibNamed:@"SayThankYouCustomView" owner:self options:nil] objectAtIndex:0];
    customThankYou.frame = CGRectMake(0, 0,self.view.width, self.view.height);
    customThankYou.thankUViewDelegate = self;
    [self.view addSubview:customThankYou];
}

-(void)addingNewOfferVC{
    NewOfferVC *special = [[NewOfferVC alloc] initWithNibName:@"NewOfferVC" bundle:nil];
    special.isFromSpecialCouponOffer = YES;
    special.offerVCDelegate = self;
    [self.navigationController pushViewController:special animated:YES];
}

#pragma mark - Search bar Button Action

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.gradientView.hidden = YES;
    [self searchFavouritesList];
    [self.sayThanksTableView reloadData];
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
        [self searchFavouritesList];
    }
    else{
        self.recomendersArray = self.dummyArray;
    }
    [self.sayThanksTableView reloadData];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.gradientView.hidden = NO;
    return YES;
}


-(void)DissmissView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - searchlist

-(void)searchFavouritesList{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[cd] %@",self.searchBar.text];
    NSArray *searchResults = [self.dummyArray filteredArrayUsingPredicate:predicate];
    self.recomendersArray = searchResults;
}

#pragma mark - Tap Action

- (IBAction)tapAction:(id)sender {
    self.gradientView.hidden = YES;
    [self.view endEditing:YES];
}

#pragma mark - UITable View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.recomendersArray.count == 0)
        self.noRecomendLabel.hidden = NO;
    else
        self.noRecomendLabel.hidden = YES;
    return self.recomendersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SayThanksTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SayThanksTableCell" owner:self options:nil] lastObject];
    }
    cell.isFromSpecialCoupon = self.isFromSpecialCoupon;
    id recommendDetails = [self.recomendersArray objectAtIndex:indexPath.row];
    cell.recommendDetails = recommendDetails;
    if([self.selctedItemsArray containsObject:recommendDetails])
        cell.selectButton.selected = YES;
    else
        cell.selectButton.selected = NO;
    cell.sayThanksCellDelegate = self;
    cell.tag = indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isFromSpecialCoupon){
    id temp=[self.recomendersArray objectAtIndex:indexPath.row];
    if([[temp valueForKey:@"specialCouponSentCount"]isEqual:[NSNumber numberWithInt:2]]){
        [self ShowAlert:@"You can send only max two coupons every two weeks"];
    }
    }
}

#pragma mark - Say Thank View Delegate

-(void)DissmissView:(SayThankYouCustomView *)sayThankView{
    [sayThankView removeFromSuperview];
}

-(void)sendButtonActionFromView:(SayThankYouCustomView *)sayThankView DelegateWithMessageContent:(NSString *)messageContent{
    if(messageContent.length == 0)
        [[Utilities standardUtilities] showMessageAlertControllerInController:self withAlertMessage:@"Please enter message"];
    else{
        [self.view endEditing:YES];
        [sayThankView removeFromSuperview];
        [self addingMailComposerWithMessageBody:messageContent];
    }
    
}

-(void)addingMailComposerWithMessageBody:(NSString *)messageBody{
    //    NSArray *toRecipents;
    //    if(self.isBusinessFavourites){
    //        toRecipents =[self.selctedItemsArray valueForKey:@"userEmail"];
    //    }else{
    //        toRecipents =[self.selctedItemsArray valueForKey:@"userEmailId"];
    //    }
    //    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    //    mc.mailComposeDelegate = self;
    //    NSString *subjectString;
    //    if(self.isFromSpecialCoupon)
    //        subjectString = [NSString stringWithFormat:@"%@ %@",AppName,@"Services"];
    //    else
    //        subjectString = [NSString stringWithFormat:@"%@ %@",AppName,@"Services"];
    //    [mc setSubject:subjectString];
    //    [mc setMessageBody:messageBody isHTML:NO];
    //    [mc setToRecipients:toRecipents];
    //    [self presentViewController:mc animated:YES completion:NULL];
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSMutableArray *recpArray=[[NSMutableArray alloc]init];
        for (int i = 0; i<self.selctedItemsArray.count; i++) {
            id data = [self.selctedItemsArray objectAtIndex:i];
            NSString *number=[data valueForKey:@"userPhone"];
            [recpArray addObject:number];
        }

        controller.body = messageBody;
        controller.recipients = recpArray;//[NSArray arrayWithObjects:@"12345678", @"87654321", nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            
            break;
        case MessageComposeResultSent:
        {
            if(self.isBusinessFavourites){
                [self updatingLocalDbFavorites];
                [self callingFaviriteSayThanksApi];
                [self.selctedItemsArray removeAllObjects];
                [self populatingFavorites];
            }else{
                [self updatingLocalDb];
                [self callingSayThanksApi];
                [self.selctedItemsArray removeAllObjects];
                [self populatingRecommendations];
            }}
            
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:controller completion:^{
        if(result == MessageComposeResultSent){
            NSString *alertMessage = @"";
            if(self.isFromSpecialCoupon)
                alertMessage = @"Coupon sent successfully";
            else
                alertMessage = @"Thanks sent successfully";
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:alertMessage];
        }
        
    }];
}

#pragma mark - Mail Composer Delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {
            if(self.isBusinessFavourites){
                [self updatingLocalDbFavorites];
                [self callingFaviriteSayThanksApi];
                [self.selctedItemsArray removeAllObjects];
                [self populatingFavorites];
            }else{
                [self updatingLocalDb];
                [self callingSayThanksApi];
                [self.selctedItemsArray removeAllObjects];
                [self populatingRecommendations];
            }}
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:^{
        if(result == MFMailComposeResultSent){
            NSString *alertMessage = @"";
            if(self.isFromSpecialCoupon)
                alertMessage = @"Coupon sent successfully";
            else
                alertMessage = @"Thanks sent successfully";
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:alertMessage];
        }
    }];
}

#pragma mark -Say Thanks Cell Delegate

-(void)selctedItemWithIndex:(NSInteger)selectedIndex withButton:(UIButton *)button{
    id recommendDetails = [self.recomendersArray objectAtIndex:selectedIndex];
    if([self.selctedItemsArray containsObject:recommendDetails])
        [self.selctedItemsArray removeObject:recommendDetails];
    else
        [self.selctedItemsArray addObject:recommendDetails];
}

-(void)updatingLocalDb{
    Racommendations *rec;
    for (int i = 0; i<self.selctedItemsArray.count; i++) {
        rec = [self.selctedItemsArray objectAtIndex:i];
        rec.isthanksSend = YES;
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
    
}

-(void)updatingLocalDbFavorites{
    BussinessFavorite *fav;
    for (int i = 0; i<self.selctedItemsArray.count; i++) {
        fav = [self.selctedItemsArray objectAtIndex:i];
        fav.thanksSendStatus = YES;
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}
#pragma mark - New Offer VC Delegate

-(void)sendButtonActionDelegateWithOfferID:(NSNumber *)offerId{
    if(self.isBusinessFavourites){
        [self callingSendSpecialCouponFavoritesApiWithOfferId:offerId];
    }else{
        [self callingSendSpecialCouponApiWithOfferId:offerId];
    }
}

#pragma mark - Calling Say Thanks Api

-(void)callingSayThanksApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BusinessUser *bussUser=[BusinessUser getBusinessUser];
    NSURL *sayThanksUrlString = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESAYTHANKS withURLParameter:nil];
    NSArray *useridsArray = [self.selctedItemsArray valueForKey:@"user_id"];
    NSString *sharingUserIds = [useridsArray componentsJoinedByString:@","];
    NSString *sharingUrlString = [NSString stringWithFormat:@"recommended_user_ids=%@&business_id=%lld",sharingUserIds,bussUser.business_id];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:sayThanksUrlString withBody:sharingUrlString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
        //            NSLog(@"Response Object:%@",responseObject);
        //        }
        //        else{
        //            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        //        }
        [self updatingLocalDb];
        [self.selctedItemsArray removeAllObjects];
        [self populatingRecommendations];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
        
    }];
}

-(void)callingFaviriteSayThanksApi{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *sayThanksUrlString = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESAYTHANKSFAVORITE withURLParameter:nil];
    NSArray *useridsArray = [self.selctedItemsArray valueForKey:@"favorited_id"];
    NSString *sharingUserIds = [useridsArray componentsJoinedByString:@","];
    NSString *sharingUrlString = [NSString stringWithFormat:@"favorited_ids=%@",sharingUserIds];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:sayThanksUrlString withBody:sharingUrlString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [self updatingLocalDbFavorites];
        [self.selctedItemsArray removeAllObjects];
        [self populatingFavorites];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Calling Send Special Coupon Api

-(void)callingSendSpecialCouponApiWithOfferId:(NSNumber *)offerID{
    NSURL *sendSpecialCouUrl = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESENDSPECIALCOUPON withURLParameter:nil];
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSArray *useridsArray = [self.selctedItemsArray valueForKey:@"user_id"];
    NSString *sharingUserIds = [useridsArray componentsJoinedByString:@","];
    NSString *sharingUrlString = [NSString stringWithFormat:@"coupon_id=%@&shared_by=%@&shared_to=%@",offerID,[NSNumber numberWithLong:busUser.bus_user_id],sharingUserIds];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:sendSpecialCouUrl withBody:sharingUrlString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [self updateLocalDBAfterSendingSpecialCoupon];
            [self.selctedItemsArray removeAllObjects];
            [self populatingRecommendations];
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //[[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
        
    }];
}

-(void)updateLocalDBAfterSendingSpecialCoupon{
    Racommendations *reccommend;
    for (int i = 0; i<self.selctedItemsArray.count; i++) {
        reccommend = [self.selctedItemsArray objectAtIndex:i];
        reccommend.specialCouponSentCount++;
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}

#pragma mark - Calling Send Special Coupon Api

-(void)callingSendSpecialCouponFavoritesApiWithOfferId:(NSNumber *)offerID{
    NSURL *sendSpecialCouUrl = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESENDFAVORITECOUPON withURLParameter:nil];
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSArray *useridsArray = [self.selctedItemsArray valueForKey:@"user_id"];
    NSString *sharingUserIds = [useridsArray componentsJoinedByString:@","];
    NSString *sharingUrlString = [NSString stringWithFormat:@"coupon_id=%@&shared_by=%@&shared_to=%@",offerID,[NSNumber numberWithLong:busUser.bus_user_id],sharingUserIds];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:sendSpecialCouUrl withBody:sharingUrlString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [self updateLocalDBAfterSendingFavoriteSpecialCoupon];
            [self.selctedItemsArray removeAllObjects];
            [self populatingFavorites];
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

-(void)updateLocalDBAfterSendingFavoriteSpecialCoupon{
    BussinessFavorite *fav;
    for (int i = 0; i<self.selctedItemsArray.count; i++) {
        fav = [self.selctedItemsArray objectAtIndex:i];
        fav.specialCouponSentCount++;
        [[CLCoreDataAdditions sharedInstance]saveEntity];
    }
}
#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
