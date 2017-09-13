//
//  ProfileVC.m
//  DirectoryApp
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.

#import "ProfileVC.h"
#import "ReviewsVC.h"
#import "SurpriseBoxVc.h"
#import "UserSettingsVC.h"
#import "BusinessOwnerVC.h"
#import "FavouriteSpotsVC.h"
#import "ProfileTableCell.h"
#import "BusinessFavouritesVC.h"
#import "SavedCouponViewController.h"
#import "User.h"
#import "LoginViewController.h"



#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import <CLToolKit/UIKitExt.h>
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"


@interface ProfileVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) NSMutableArray *profileDataArray;
@end

@implementation ProfileVC

- (void)initView {
    [super initView];
    [self initialisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [self PopulateUi];
    [self getProfileDetails];
    [self getSurpriceCountApi];
}

-(void)initialisation{
    self.profileImage.layer.cornerRadius = self.profileImage.height/2;
    NSDictionary *cell1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Favorite spots",@"profileData", @"favouriteIcon",@"profileDataImage",nil];
    NSDictionary *cell2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Coupons",@"profileData", @"couponIcon",@"profileDataImage",nil];
    NSDictionary *cell3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Surprise box",@"profileData", @"surpriseIcon",@"profileDataImage",nil];
    self.profileDataArray = [NSMutableArray arrayWithObjects:cell1,cell2,cell3,nil];
}

-(void)PopulateUi{
    User *user=[User getUser];
    NSLog(@"%@>>>%d",user,user.user_id);
    if ([user.first_name isEqual:[NSNull null]] || user.first_name==nil || user.first_name==NULL || [user.first_name isEqualToString:@"null"]) {
        // [self ShowAlert:@"Something went wrong, Please login to continue"];
        [self addLogInVC];
    }else{
        self.nameLabel.text=[NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name];
        self.placeLabel.text=user.city;
        NSString *profileId=[NSString stringWithFormat:@"%d.jpg?%@",user.user_id,user.user_image_cache];
        NSString *finalProfImgUrlStg = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
        [self.profileImage sd_setImageWithURL:[NSURL URLWithString:finalProfImgUrlStg] placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"] options:SDWebImageRefreshCached completed:nil];
        
    }
}
- (IBAction)ImageViewTapAction:(id)sender {
    [self addingFullImageControllerWithImagae:self.profileImage.image withImageView:self.profileImage];
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

#pragma mark - UITable View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.profileDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileTableCell" owner:self options:nil] lastObject];
    }
    cell.topLineView.hidden = YES;
    if(indexPath.row == 0){
        cell.topLineView.hidden = NO;
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",[[self.profileDataArray objectAtIndex:indexPath.row] valueForKey:@"profileData"]];
        cell.imageIcon.image = [UIImage imageNamed:[[self.profileDataArray objectAtIndex:indexPath.row]valueForKey:@"profileDataImage"]];
    }else {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",[[self.profileDataArray objectAtIndex:indexPath.row] valueForKey:@"profileData"]];
        cell.imageIcon.image = [UIImage imageNamed:[[self.profileDataArray objectAtIndex:indexPath.row]valueForKey:@"profileDataImage"]];
    }
     if(indexPath.row == 2){
         NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"count"]);
         NSString *temp=[[NSUserDefaults standardUserDefaults]valueForKey:@"count"];
         if(temp==nil){
             
         }
         cell.surpriceCountLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"count"];
         cell.surpriceCountLabel.hidden=NO;
         if([[[NSUserDefaults standardUserDefaults]valueForKey:@"count"] isEqualToString:@"0"]||temp==nil){
             cell.surpriceCountLabel.hidden=YES;
         }
     }
    return cell;
    
}

#pragma mark - Table View Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self addingFavoriteSpots];
    }else if (indexPath.row == 1){
        [self addingSavedCoupons];
    } else{
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"count"];
        [self.profileTableView reloadData];
        [self addingSurpriseBox];
    }
}

-(void)addingFavoriteSpots{
    FavouriteSpotsVC *favorietSpots = [[FavouriteSpotsVC alloc] initWithNibName:@"FavouriteSpotsVC" bundle:nil];
    UINavigationController *favoriteSpotNavCntrlr = [[UINavigationController alloc] initWithRootViewController:favorietSpots];
    [self presentViewController:favoriteSpotNavCntrlr animated:YES completion:nil];
}

-(void)addingSavedCoupons{
    SavedCouponViewController *favorietSpots = [[SavedCouponViewController alloc] initWithNibName:@"SavedCouponViewController" bundle:nil];
    UINavigationController *favoriteSpotNavCntrlr = [[UINavigationController alloc] initWithRootViewController:favorietSpots];
    [self presentViewController:favoriteSpotNavCntrlr animated:YES completion:nil];
}

-(void)addingCoupons{
    BusinessOwnerVC *favor = [[BusinessOwnerVC alloc] initWithNibName:@"BusinessOwnerVC" bundle:nil];
    [self presentViewController:favor animated:YES completion:nil];
}

-(void)addingSurpriseBox{
    SurpriseBoxVc *surpriseBoxVC = [[SurpriseBoxVc alloc] initWithNibName:@"SurpriseBoxVc" bundle:nil];
    UINavigationController *surpriseBoxNavCntlr = [[UINavigationController alloc] initWithRootViewController:surpriseBoxVC];
    [self presentViewController:surpriseBoxNavCntlr animated:YES completion:nil];
}


#pragma mark - Button Actions

- (IBAction)SettingsButtonAction:(UIButton *)sender {
    UserSettingsVC *settingsVC = [[UserSettingsVC alloc] initWithNibName:@"UserSettingsVC" bundle:nil];
    settingsVC.isUserSettings = YES;
    UINavigationController *settingsNavCntrlr = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:settingsNavCntrlr animated:YES completion:nil];
    });
}
#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self addLogInVC];
    }];
    [alert addAction:firstAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}
-(void)addLogInVC{
    LoginViewController *logInVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:logInVC animated:YES completion:nil];
    });
}
#pragma mark - Get ProfileDetails Api call

-(void)getProfileDetails {
    User *user = [ User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"user_id=%d",user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETPROFILE withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        user.user_image_cache=[NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"data"] valueForKey:@"user_image_cache"]];
        [[CLCoreDataAdditions sharedInstance] saveEntity];
        NSString *profileId=[NSString stringWithFormat:@"%d.jpg?%@",user.user_id,[[responseObject valueForKey:@"data"] valueForKey:@"user_image_cache"]];
        NSString *finalProfImgUrlStg = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
        [self.profileImage sd_setImageWithURL:[NSURL URLWithString:finalProfImgUrlStg] placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"] options:SDWebImageRefreshCached completed:nil];
        
         } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
             
             
         }];
}
#pragma mark -getSurpriceCountApi call

-(void)getSurpriceCountApi {
    User *user = [ User getUser];
    NSString *urlParameter = [NSString stringWithFormat:@"user_id=%d",user.user_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESURPRICECOUNT withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
      NSString *temp=[NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"data"] valueForKey:@"count"]];
     [[NSUserDefaults standardUserDefaults]setObject:temp forKey:@"count"];
        [self.profileTableView reloadData];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
        
    }];
}

@end
