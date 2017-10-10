//
//  SurpriseBoxVc.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "NewOfferVC.h"
#import "Utilities.h"
#import "SendToVC.h"
#import "UrlGenerator.h"
#import "SurpriseBox.h"
#import "NetworkHandler.h"
#import "MBProgressHUD.h"
#import "SurpriseBoxTVC.h"
#import "SurpriseBoxVc.h"
#import "JTSImageInfo.h"
#import "CouponDetailViewController.h"
#import "JTSImageViewController.h"
#import "User.h"
#import "ProductDetailViewController.h"

@interface SurpriseBoxVc ()<UITableViewDelegate,UITableViewDataSource,SurpriseBoxImageDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nothingLabel;
@property (nonatomic, strong) NSArray *mySurpriseBoxArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *surpriseTableView;

@end

@implementation SurpriseBoxVc

-(void)initView{
    [super initView];
    [self initialisation];
    [self addingRefreshControl];
}

#pragma mark - View Intialization

-(void)initialisation{
    self.title = @"Surprise Box";
    self.mySurpriseBoxArray =[SurpriseBox getSurpriseBoxData];
    [self.surpriseTableView reloadData];
    [self getMyRecommendationsApi];
    [self showButtonOnLeftWithImageName:@""];
}
-(void)viewDidAppear:(BOOL)animated{
    [self getMyRecommendationsApi];
}

#pragma mark - Adding refresh control

-(void)addingRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.surpriseTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Refresh Control Action

-(void)refreshTable{
    [self getMyRecommendationsApi];
}

#pragma mark - Full screen image library call

-(void)surpriseBoxImageTapActionDelegateWithCellTag:(NSInteger)cellTag andImage:(UIImage *)image withImageView:(UIImageView *)imageView{
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


#pragma mark - Viiew Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITable View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.mySurpriseBoxArray.count == 0)
        self.nothingLabel.hidden = NO;
    else
        self.nothingLabel.hidden = YES;
    return self.mySurpriseBoxArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SurpriseBoxTVC * cell = [tableView dequeueReusableCellWithIdentifier:@"surpriseCell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SurpriseBoxTVC" owner:self options:nil] lastObject];
    }
    cell.surpriseBoxDetails = [ self.mySurpriseBoxArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.surpriseBoxImageDelegate = self;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id temp=[self.mySurpriseBoxArray objectAtIndex:indexPath.row];
    [self ReadSurpriceApi:temp];
    int type=[[temp valueForKey:@"notificationType"] intValue];
    if(!(type==3||type==4||type==5)){
        CouponDetailViewController *vc = [[CouponDetailViewController alloc] initWithNibName:@"CouponDetailViewController" bundle:nil];
        vc.isFromSurpriseBox=YES;
        vc.myOffersArray=temp;
        vc.couponImagesArray = [[NSMutableArray alloc]init];
        if([temp valueForKey:@"imageName"]!=nil){
        [vc.couponImagesArray addObject:[temp valueForKey:@"imageName"]];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(type==3){
        NSString *bussID=[NSString stringWithFormat:@"%@",[temp valueForKey:@"business_id"]];
        [self getBusinessDetailsApi:bussID];
    }
    
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id temp=[self.mySurpriseBoxArray objectAtIndex:indexPath.row];
    [self RemoveSurpriceData:temp tableView:tableView WithRow:indexPath.row];
}
-(void)RemoveSurpriceData:(id)temp tableView:(UITableView*)table WithRow:(NSUInteger)Row{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:AppName
                                message: @"Do you want to delete this notification?"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"Yes" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   
                                                   [self RemoveSurpriceApi:temp tableView:table WithRow:Row];
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Calling Delete surprice Api

-(void)RemoveSurpriceApi:(id)temp tableView:(UITableView*)table WithRow:(NSUInteger)Row{
    int notificationId=[[temp valueForKey:@"id"] intValue];
    int notificationType=[[temp valueForKey:@"notificationType"] intValue];
    NSString *urlParameter = [NSString stringWithFormat:@"id=%d&notification_type=%d",notificationId,notificationType];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEDELETESURPRICE withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [table beginUpdates];
            [SurpriseBox RemoveSurpriceWithId:[NSNumber numberWithInt:notificationId] :[NSNumber numberWithInt:notificationType]];
            self.mySurpriseBoxArray =[SurpriseBox getSurpriseBoxData];
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:Row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
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

#pragma mark - Calling Delete surprice Api

-(void)ReadSurpriceApi:(id)temp{
    int notificationId=[[temp valueForKey:@"id"] intValue];
    int notificationType=[[temp valueForKey:@"notificationType"] intValue];
    NSString *urlParameter = [NSString stringWithFormat:@"id=%d&notification_type=%d",notificationId,notificationType];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEREADSURPRICE withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [self.surpriseTableView reloadData];
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



#pragma mark - Get Favourite Spots Api call

-(void)getMyRecommendationsApi {
    User *user=[User getUser];
    if(self.mySurpriseBoxArray.count == 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSString *urlParameter = [NSString stringWithFormat:@"%d",user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETMYRECOMMENDATIONS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [SurpriseBox deleteAllEntries];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(![[responseObject valueForKey:@"data"] isEqual:[NSNull null]]){
            [SurpriseBox saveSurpriseBoxDetails:[responseObject valueForKey:@"data"]];
        }
        self.mySurpriseBoxArray =[SurpriseBox getSurpriseBoxData];
        [self.surpriseTableView reloadData];
        [self.refreshControl endRefreshing];
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.refreshControl endRefreshing];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}
#pragma mark - Get Business Details Api

-(void)getBusinessDetailsApi:(NSString*)bussId {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user=[User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%@&&user_id=%d",bussId,user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETFAVORITEDETAILS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            ProductDetailViewController *vc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
            vc.bussinessDetails=[responseObject valueForKey:@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

@end
