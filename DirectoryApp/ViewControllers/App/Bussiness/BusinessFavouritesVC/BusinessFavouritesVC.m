//
//  BusinessFavouritesVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 16/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "SayThanksVC.h"
#import "BusinessUser.h"
#import "Racommendations.h"
#import "BusinessFavouritesVC.h"
#import "BusinessFavouritesTableCell.h"
#import "BussinessFavorite.h"

@interface BusinessFavouritesVC ()<UITableViewDelegate>
@property (weak, nonatomic) CALayer *layerS;
@property (nonatomic, strong) NSArray *reccomendersArray;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecomendationLabel;
@end

@implementation BusinessFavouritesVC

- (void)initView {
    [super initView];
    [self initialisation];
    [self addingRefreshControl];
}

-(void)initialisation{
    [UIView transitionWithView:self.view duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self HideShowMoreView:YES]; }
                    completion:nil];
    
    self.layerS = self.moreButtonView.layer;
    self.moreButtonView.layer.cornerRadius =2;
    self.layerS.shadowOffset = CGSizeMake(.5,.5);
    self.layerS.shadowColor = [[UIColor blackColor] CGColor];
    self.layerS.shadowRadius = 2.0f;
    self.layerS.shadowOpacity = 0.40f;
    if(self.isBusinessFavourites){
        self.title = @"Those who Favorites";
        [self showButtonOnLeftWithImageName:closeImageName];
        [self showButtonOnRightWithImageName:@"moreButton"];
        [self populateFavorites];
        [self callingGetBusinessFavoritersApi];
        self.noRecomendationLabel.text = @"";
    }
    else{
        self.title = @"Those who Recommends";
        [self showButtonOnLeftWithImageName:@"closeIcon"];
        [self showButtonOnRightWithImageName:@"moreButton"];
        self.noRecomendationLabel.text = @"No recommendations found";
        [self populateRacommendations];
        [self callingGetBusinessReccomendersApi];
    }
}
-(void)HideShowMoreView:(BOOL)status{
    if(status){
        self.isSelected = NO;
        self.moreButtonView.hidden = YES;
        self.gradientView.hidden = YES;
    }else{
        self.isSelected = YES;
        self.moreButtonView.hidden = NO;
        self.gradientView.hidden = NO;
    }
}

#pragma mark - Adding refresh control

-(void)addingRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.recommendTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Refresh Control Action

-(void)refreshTable{
    if(self.isBusinessFavourites){
        [self callingGetBusinessFavoritersApi];
    }
    else{
        [self callingGetBusinessReccomendersApi];
    }
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightButtonAction:(UIButton *)rightButton{
    if(self.isSelected){
        [UIView transitionWithView:self.view duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ { [self HideShowMoreView:YES]; }
                        completion:nil];
        
    }else{
        [UIView transitionWithView:self.view duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ { [self HideShowMoreView:NO]; }
                        completion:nil];
    }
}

- (IBAction)thanksButtonAction:(id)sender {
    SayThanksVC *thanks = [[SayThanksVC alloc] initWithNibName:@"SayThanksVC" bundle:nil];
    if(self.isBusinessFavourites){
        thanks.isBusinessFavourites=YES;
    }
    [self.navigationController pushViewController:thanks animated:YES];
    [UIView transitionWithView:self.view duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self HideShowMoreView:YES]; }
                    completion:nil];
}

- (IBAction)specialCouponButtonAction:(id)sender {
    SayThanksVC *thanks = [[SayThanksVC alloc] initWithNibName:@"SayThanksVC" bundle:nil];
    thanks.isFromSpecialCoupon = YES;
    if(self.isBusinessFavourites){
        thanks.isBusinessFavourites=YES;
    }
    [self.navigationController pushViewController:thanks animated:YES];
    [UIView transitionWithView:self.view duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self HideShowMoreView:YES]; }
                    completion:nil];
    
}

#pragma mark - Tap Action

- (IBAction)tapAction:(id)sender {
    [UIView transitionWithView:self.view duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self HideShowMoreView:YES]; }
                    completion:nil];
}

#pragma mark - UITable View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.reccomendersArray.count == 0)
        self.noRecomendationLabel.hidden = NO;
    else
        self.noRecomendationLabel.hidden = YES;
    return self.reccomendersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessFavouritesTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessFavouritesTableCell" owner:self options:nil] lastObject];
    }
    cell.recommendDetails = [self.reccomendersArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Get Business Reccomenders Api

-(void)callingGetBusinessReccomendersApi{
    if(self.reccomendersArray.count == 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    BusinessUser *busUser=[BusinessUser getBusinessUser];
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%lld",busUser.business_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETBUSINESSRECCOMENDERS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            
            if(![[responseObject valueForKey:@"data"] isEqual:[NSNull null]])
                [Racommendations saveRecommendationsDetails:[responseObject valueForKey:@"data"]];
            [self populateRacommendations];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [self.recommendTableView reloadData];
        [self.refreshControl endRefreshing];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        [self.refreshControl endRefreshing];
        [self populateRacommendations];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
    
}

-(void)populateRacommendations{
    self.reccomendersArray = [Racommendations getAllRecommendations];
    [self.recommendTableView reloadData];
}

#pragma mark - Calling Business Favoriters Api

-(void)callingGetBusinessFavoritersApi{
    if(self.reccomendersArray.count == 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    BusinessUser *busUser=[BusinessUser getBusinessUser];
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%lld",busUser.business_id];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETBUSINESSFAVORITERS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(![[responseObject valueForKey:@"data"] isEqual:[NSNull null]])
                [BussinessFavorite saveFavoriteDetails:[responseObject valueForKey:@"data"]];
            [self populateFavorites];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [self.recommendTableView reloadData];
        [self.refreshControl endRefreshing];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        [self.refreshControl endRefreshing];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

-(void)populateFavorites{
    self.reccomendersArray = [BussinessFavorite getAllFavoritesUsers];
    [self.recommendTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
