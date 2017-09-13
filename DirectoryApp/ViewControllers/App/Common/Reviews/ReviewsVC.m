//
//  ReviewsVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 17/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "ReviewsVC.h"
#import "BusinessUser.h"
#import "ReviewTableCell.h"
#import "MessageComposerView.h"

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

#define ComposerViewHeight 50

@interface ReviewsVC ()<MessageComposerViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *reviewTable;
@property (nonatomic, strong) MessageComposerView *messageComposerView;
@property (nonatomic, strong) NSMutableArray *reviewArray;
@property (nonatomic) BOOL isNewReviewer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *bottomProgressIndicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTableBottomConstraint;
@property (nonatomic) unsigned long int startIndex;
@property (nonatomic, assign) int reviewCount;
@property (nonatomic, assign) BOOL isApiCalled;
@property (weak, nonatomic) IBOutlet UILabel *noReviewsToShowLabel;
@end
@implementation ReviewsVC

- (void)initView {
    [super initView];
    [self initialisation];
    [self GetMyReviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initialisation{
    self.startIndex = 0;
    self.reviewCount = 100;
    self.isApiCalled = NO;
    self.reviewArray=[[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.reviewTable.estimatedRowHeight = 80;
    self.reviewTable.rowHeight = UITableViewAutomaticDimension;
    self.title = @"Reviews";
    [self showButtonOnLeftWithImageName:@"closeIcon"];
//    [self showButtonOnRightWithImageName:@"editIcon"];
    if(!self.isFromBusUser){
        [self AddMessageComposer];
    }
    else{
        self.reviewTableBottomConstraint.constant = 0;
    }
    
}
-(void)AddMessageComposer{
    [self.messageComposerView removeFromSuperview];
    self.messageComposerView = [[MessageComposerView alloc] init];
    self.messageComposerView.delegate = self;
    self.messageComposerView.messagePlaceholder = @"Write a review";
    self.messageComposerView.backgroundColor = [UIColor whiteColor];
    self.messageComposerView.frame = CGRectMake(0, self.view.frame.size.height - ComposerViewHeight, self.view.frame.size.width, ComposerViewHeight);
    [self.view addSubview:self.messageComposerView];
    
}
- (void)messageComposerBeginEditing{
    
}

#pragma mark - Message Composer View Delegates

- (void)messageComposerSendMessageClickedWithMessage:(NSString*)message{
    NSLog(@"Messaghe:%@",message);
    [self.view endEditing:YES];
    [self AddReviews:message];
    
}
- (void)messageComposerFrameDidChange:(CGRect)frame withAnimationDuration:(CGFloat)duration andCurve:(NSInteger)curve
{
    
}
- (void)messageComposerUserTyping{
    
}
- (void)sendButtonActionForComment:(UIButton *)button{
    NSLog(@"hai");
    
}


#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    if(self.isFromBusUser)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonAction:(UIButton *)rightButton{
    //    User *user=[User getUser];
    //    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF.user_id == %@",[NSNumber numberWithInteger:user.user_id]];
    //    NSArray *resultsArray = [self.reviewArray filteredArrayUsingPredicate: predicate];
    //    if([resultsArray count]!=0){
    //        NSString *temp=[[resultsArray objectAtIndex:0] valueForKey:@"message"];
    //        [self AddMessageComposer];
    //    }else{
    //
    //    }
    
}
- (IBAction)ViewTapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITable View DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.reviewArray.count == 0)
        self.noReviewsToShowLabel.hidden = NO;
    else
        self.noReviewsToShowLabel.hidden = YES;
    return self.reviewArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewTableCell *cell = (ReviewTableCell*) [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.tag = indexPath.section;
    cell.reviewListDict=[self.reviewArray objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
    // id temp=[self.myOffersArray objectAtIndex:indexPath.section];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.reviewTable){
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height-50;
        if (endScrolling >= scrollView.contentSize.height)
        {
            if(!self.isApiCalled){
                self.isApiCalled  = YES;
                [self GetMyReviews];
                [self.bottomProgressIndicatorView startAnimating];
            }
        }
    }

}

#pragma mark - GetMyReviews Api call

-(void)GetMyReviews{
    NSNumber *busId;
    NSString *userId;
    if(self.isFromBusUser){
        BusinessUser *busUser = [BusinessUser getBusinessUser];
        busId = [NSNumber numberWithLong:busUser.business_id];
        userId = @"";
    }
    else{
        User *user=[User getUser];
        busId = [self.bussinessDetails valueForKey:@"business_id"];
        userId = [NSString stringWithFormat:@"%d",user.user_id];
    }
    NSString *urlParameter = [NSString stringWithFormat:@"business_id=%@&user_id=%@&starting_index=%lu&count=%d",busId,userId,self.startIndex,self.reviewCount];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETREVIEWS withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
         if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
             NSArray *reviewArray = [responseObject valueForKey:@"data"];
             [self.reviewArray removeAllObjects];
             [self.reviewArray addObjectsFromArray:reviewArray];
             if(!self.isFromBusUser){
                 if(self.startIndex == 0){
                     if([[responseObject valueForKey:@"messageText"] length]!=0){
                         self.messageComposerView.messageTextView.text=[responseObject valueForKey:@"messageText"];
                         self.isNewReviewer=NO;
                     }else{
                         self.isNewReviewer=YES;
                     }
                 }
                
             }
             if(reviewArray.count!=0)
                 self.startIndex = self.reviewArray.count;
         }
        self.isApiCalled = NO;
        [self.bottomProgressIndicatorView stopAnimating];
        self.noReviewsToShowLabel.text=@"No reviews to added yet";
        [self.reviewTable reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        self.isApiCalled = NO;
        [self.bottomProgressIndicatorView stopAnimating];
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
        if(self.startIndex == 0)
            [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
    }];
}

#pragma mark - Add Reviews Api call

-(void)AddReviews:(NSString*)comment{
    User *user=[User getUser];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *tempString = [NSString stringWithFormat:@"user_id=%d&business_id=%@&rating=5&comment=%@",user.user_id,[self.bussinessDetails valueForKey:@"business_id"],comment];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESAVEREVIEW withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:tempString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        self.noReviewsToShowLabel.text=@"No reviews to added yet";
        if(!self.isNewReviewer){
            NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF.user_id == %@",[NSNumber numberWithInteger:user.user_id]];
            NSArray *resultsArray = [self.reviewArray filteredArrayUsingPredicate: predicate];
            if([resultsArray count]!=0){
                [self.reviewArray removeObject:[resultsArray objectAtIndex:0]];
            }
        }
        long long currentTime=[[NSDate date] timeIntervalSince1970]*1000;
        NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
        [commentadd setValue:[self.bussinessDetails valueForKey:@"business_id"] forKey:@"business_id"];
          [commentadd setValue:[NSNumber numberWithLongLong:currentTime] forKey:@"created_on"];
        [commentadd setValue:[self.bussinessDetails valueForKey:@"business_name"] forKey:@"business_name"];
        NSString *strComment = [comment stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        [commentadd setValue:strComment forKey:@"comment"];
        [commentadd setValue:[NSNumber numberWithInteger:user.user_id] forKey:@"user_id"];
        [commentadd setValue:[NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name ] forKey:@"user_name"];
        [self.reviewArray insertObject:commentadd atIndex:0];
        self.messageComposerView.messageTextView.text=comment;
        [self.reviewTable reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view  animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        self.messageComposerView.messageTextView.text=comment;
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

@end
