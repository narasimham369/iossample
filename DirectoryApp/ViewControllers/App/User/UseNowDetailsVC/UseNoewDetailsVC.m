//
//  UseNoewDetailsVC.m
//  DirectoryApp
//
//  Created by smacardev on 21/09/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "UseNoewDetailsVC.h"
#import "Offers.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+NSstring_Category.h"
#import "SwipeImageCollectionViewCell.h"
@interface UseNoewDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,CouponCollectionViewDelegate,UICollectionViewDelegate,UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation UseNoewDetailsVC


- (void)initView {
    [super initView];
    [self Custumisation];
    [self CollectionViewInitial];
      [self PopulateUi];
    if([self.dateLabel.text length]==0){
        self.dateLabel.text=@"On going";
    }
}



-(void)PopulateUi{
    
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
    //NSString *imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
    
    // Main server
   NSString *imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
    [self.locationImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached completed:nil];
    
    if([self.dateLabel.text length]==0 ||[self.dateLabel.text isEqualToString:@"(null)"]){
        self.dateLabel.text=@"On going";
    }
}



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
       // cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[NSNumber numberWithLong:offer.offerID],[self.couponImagesArray objectAtIndex:0]];
        
        //main server
               cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[NSNumber numberWithLong:offer.offerID],[self.couponImagesArray objectAtIndex:0]];
    }
    
    else{
        //testing pirpose
      //  cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
        //main server
           cell.imageName= [NSString stringWithFormat:@"%@%@/%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/OfferImages/",[self.myOffersArray valueForKey:@"id"],[self.couponImagesArray objectAtIndex:0]];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)NavigateToAddress:(id)sender {
      [self AddressNavigation:@"Do you want navigation to this address?"];
}

- (IBAction)PhoneNumberTapAction:(id)sender {
    NSString *temp=[NSString stringWithFormat:@"Do you want to call %@ now?" ,self.phoneNumber.text];
    [self PhoneCall:temp];
}

- (IBAction)logoImageTapAction:(id)sender {
     [self addingFullImageControllerWithImagae:self.locationImageView.image withImageView:self.locationImageView];
}

- (IBAction)gradientTapAction:(id)sender {
     self.gradientView.hidden = YES;
}
@end
