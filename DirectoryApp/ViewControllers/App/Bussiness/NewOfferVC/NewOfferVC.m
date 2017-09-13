//
//  NewOfferVC.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/21/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#define DescriptionPlaceHolderText @"Deal description"

#import "Offers.h"
#import "Constants.h"
#import "Utilities.h"
#import "Constants.h"
#import "NewOfferVC.h"
#import "UrlGenerator.h"
#import "BusinessUser.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "NSString+NSstring_Category.h"
#import "NSDate+NSDate_Category.h"
#import <CLToolKit/NSString+Extension.h>
#import "TOCropViewController.h"


@interface NewOfferVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewDelegate,TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *delaNameTF;
@property (weak, nonatomic) IBOutlet UITextView *dealDescTV;
@property (weak, nonatomic) IBOutlet UITextField *availableDateTF;
@property (weak, nonatomic) IBOutlet UITextField *expDateTF;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UIToolbar *dateToolBar;
@property (nonatomic, strong) NSString *pickerDateStringValue;
@property (nonatomic, strong) NSString *currentDateStringValue;

@property (nonatomic, strong) NSString *expDateStringValue;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *expirationToolBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *expirationDatePicker;
@end

@implementation NewOfferVC

-(void)initView{
    [super initView];
    [self initialisation];
}

-(void)populatingOfferDetails{
    Offers *offer = (Offers *)self.offerDetails;
    self.delaNameTF.text = offer.offerName;
    self.dealDescTV.text = offer.offerDescription;
    self.dealDescTV.textColor = [UIColor blackColor];
    self.availableDateTF.text = [offer.availableDate convertDateWithInitialFormat:@"yyyy-MM-dd" ToDateWithFormat:@"MM/dd/yyyy"];
    if(offer.expiryDate.length>0)
        self.expDateTF.text = [offer.expiryDate convertDateWithInitialFormat:@"yyyy-MM-dd" ToDateWithFormat:@"MM/dd/yyyy"];
    NSString *urlParameter = [NSString stringWithFormat:@"%d/%@",offer.offerID,offer.firstImageFileName];
    NSURL *offerImageUrl = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFOROFFER withURLParameter:urlParameter];
    [self.photoImageView sd_setImageWithURL:offerImageUrl placeholderImage:[UIImage imageNamed:@"noImage"] options:SDWebImageRefreshCached];
}

-(void)initialisation{
    if(self.isFromSpecialCouponOffer){
        self.title  =@"Custom Coupon";
        [self.saveButton setTitle:@"Send" forState:UIControlStateNormal];
    }
    else if(self.isFromEdit){
        self.title = @"Update Offer";
        [self populatingOfferDetails];
        [self.saveButton setTitle:@"Update" forState:UIControlStateNormal];
    }
    else{
        self.title  =@"New Offer";
    }
    [self showButtonOnLeftWithImageName:@""];
     [[Utilities standardUtilities]addGradientLayerTo:self.saveButton];
    self.availableDateTF.inputView = self.datePicker;
    self.availableDateTF.inputAccessoryView = self.dateToolBar;
    self.expDateTF.inputView = self.expirationDatePicker;
    self.expDateTF.inputAccessoryView = self.expirationToolBar;
    self.datePicker.minimumDate = [NSDate date];
    self.expirationDatePicker.minimumDate = [NSDate date];
}

#pragma mark - Button Actions


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGFloat value=0;
    if(IS_IPHONE_5){
        value=30;
    }
    [UIView animateWithDuration:.3 animations:^{
        if (textField == self.delaNameTF) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } else if (textField == self.availableDateTF) {
            self.scrollView.contentOffset = CGPointMake(0, value+50);
        }else if (textField == self.expDateTF) {
            self.scrollView.contentOffset = CGPointMake(0, value+50);
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField == self.delaNameTF)
        [self.dealDescTV becomeFirstResponder];
    return YES;
}

#pragma mark - Text Field Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    CGFloat value=0;
    if(IS_IPHONE_5){
        value=30;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, value+70);
    }];
    ;;
    if([textView.text isEqualToString:DescriptionPlaceHolderText])
        textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length == 0){
        textView.textColor = [UIColor colorWithRed:0.68 green:0.69 blue:0.70 alpha:1.0];
        textView.text = DescriptionPlaceHolderText;
        [textView resignFirstResponder];
    }
    else{
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.delaNameTF) {
        NSString *newString = self.delaNameTF.text;
        int charCount = (int)newString.length;
        if ((charCount >= 20) && (range.length ==0 )) {
            return NO;
        }
        return YES;
    }
    else
        return YES;
}


#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonAction:(UIButton *)sender {
    if([self isValidOffer]){
        if(self.isFromEdit){
            [self callingUpdateOfferApi];
        }
        else if(self.isFromSpecialCouponOffer){
            [self callingSaveOfferApi];
        }
        else{
            [self callingSaveOfferApi];
        }
    }
}

- (IBAction)viewTapGestureAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
    }];
}
- (IBAction)addPhotoButtonAction:(UIButton *)sender {
    [self actionSheetAlertControllerForImagePicking];
}
- (IBAction)addPhotoTapGestureAction:(UITapGestureRecognizer *)sender {
    [self actionSheetAlertControllerForImagePicking];
}
- (IBAction)dateDoneButtonAction:(UIBarButtonItem *)sender {
    [self datePickerChanged:self.datePicker isFromExpDate:NO];
    if([self.pickerDateStringValue isEqualToString:@""] || self.pickerDateStringValue == nil){
        [self currentDate];
        self.availableDateTF.text = self.currentDateStringValue;
    }else{
        self.availableDateTF.text = self.pickerDateStringValue;
        self.expirationDatePicker.minimumDate = self.datePicker.date;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        [self.expDateTF becomeFirstResponder];
    }];
}
- (IBAction)expDoneButtonAction:(UIBarButtonItem *)sender {
    [self datePickerChanged:self.datePicker isFromExpDate:YES];
    if([self.expDateStringValue isEqualToString:@""] || self.expDateStringValue == nil){
        [self currentDate];
        self.expDateTF.text = self.currentDateStringValue;
    }else{
        self.expDateTF.text = self.expDateStringValue;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
    }];
}
- (IBAction)expirationClearAction:(id)sender {
    self.expDateTF.text=@"";
    [self.view endEditing:YES];
}

- (void)currentDate {
    NSDate *d = [NSDate date];
    self.currentDateStringValue= [d convertDateToDateWithFormat:@"MM/dd/yyyy"];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker isFromExpDate:(BOOL)isfromExpDate {
    NSString  *date2 = @"";
    if(isfromExpDate){
        date2 = [self.expirationDatePicker.date convertDateToDateWithFormat:@"MM/dd/yyyy"];
        self.expDateStringValue = date2;
    }
    else{
        date2 = [self.datePicker.date convertDateToDateWithFormat:@"MM/dd/yyyy"];
        self.pickerDateStringValue = date2;
    }
}

#pragma mark - Alert Controller for Image Picking

- (void)actionSheetAlertControllerForImagePicking{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [[Utilities standardUtilities]goToCameraIsFromUser:NO withSuccessBlock:^(BOOL isSuccess) {
                                                                  if(isSuccess){
                                                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                      picker.delegate = self;
                                                                      picker.allowsEditing = YES;
                                                                      picker.sourceType =
                                                                      UIImagePickerControllerSourceTypeCamera;
                                                                      picker.view.backgroundColor = [UIColor whiteColor];
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [self presentViewController:picker animated:YES completion:nil];
                                                                      });
                                                                  }
                                                              }];
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Choose from gallery"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               if([[Utilities standardUtilities]gotoGalleryIsFromUser:NO]){
                                                                   UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                                                                   imagePickerController.delegate = self;
                                                                   imagePickerController.view.backgroundColor = [UIColor whiteColor];
                                                                   imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                   });
                                                               }
                                                               
                                                           }];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = self.photoImageView;
    popPresenter.sourceRect = self.photoImageView.bounds;
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *SecondAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [alert addAction:SecondAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    self.photoImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];

//    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
//    cropViewController.delegate = self;
//    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.photoImageView.image = image;
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(BOOL)isValidOffer{
    BOOL isValid = YES;
    NSString *errorMessageString = @"";
    if([self.delaNameTF.text empty]){
        errorMessageString = @"Please enter deal name";
        isValid = NO;
    }
    else if ([_dealDescTV.text isEqualToString:DescriptionPlaceHolderText] || [_dealDescTV.text empty]){
        errorMessageString = @"Please enter deal description";
        isValid = NO;
    }
//    else if ([self.availableDateTF.text empty]){
//        errorMessageString = @"Please enter available date";
//        isValid = NO;
//    }
    else if (!self.photoImageView.image){
        errorMessageString = @"Please upload offer image";
        isValid = NO;
    }
    if(!isValid)
       [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:errorMessageString];
    return isValid;
}

#pragma mark - Calling Save Offer Api

-(void)callingSaveOfferApi{
  NSData *dataenc = [self.dealDescTV.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *encodevalue = [[NSString alloc]initWithData:dataenc encoding:NSUTF8StringEncoding];
    NSData *dataencode = [self.delaNameTF.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *encodevalueName = [[NSString alloc]initWithData:dataencode encoding:NSUTF8StringEncoding];

    NSString *startDate;
    if([self.availableDateTF.text length]>0)
        startDate= [self.availableDateTF.text convertDateWithInitialFormat:@"MM/dd/yyyy" ToDateWithFormat:@"yyyy-MM-dd"];
    NSString *expDate;
    if([self.expDateTF.text length]>0)
        expDate= [self.expDateTF.text convertDateWithInitialFormat:@"MM/dd/yyyy" ToDateWithFormat:@"yyyy-MM-dd"];
    UIImage *uploadingImage = [[Utilities standardUtilities]compressImage:self.photoImageView.image];
    NSData *uploadImageData = UIImageJPEGRepresentation(uploadingImage, 1);
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    NSURL *uploadProfPicUrl = [NSURL URLWithString:BaseUrl];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:[NSNumber numberWithLong:busUser.business_id] forKey:@"business_id"];
    [dataDictionary setValue:encodevalueName forKey:@"offer_name"];
    if(self.isFromSpecialCouponOffer){
        [dataDictionary setValue:[NSNumber numberWithInt:1] forKey:@"is_special_coupon"];
    }else{
       [dataDictionary setValue:[NSNumber numberWithInt:0] forKey:@"is_special_coupon"];
    }
    [dataDictionary setValue:encodevalue forKey:@"description"];
    if(startDate == nil)
        [dataDictionary setValue:@"" forKey:@"available_date"];
    else
        [dataDictionary setValue:startDate forKey:@"available_date"];
    if(expDate == nil)
        [dataDictionary setValue:@"" forKey:@"expiry_date"];
    else
        [dataDictionary setValue:expDate forKey:@"expiry_date"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:uploadProfPicUrl withBody:dataDictionary withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startUploadRequest:@"DirectoryOfferPhoto.jpg" withData:uploadImageData withType:fileTypeJPGImage withUrlParameter:saveOffer withFileLocation:@"imageFile" SuccessBlock:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSNumber *offerId = [[responseObject valueForKey:@"data"] valueForKey:@"offer_id"];
            [self saveOfferDetailsToLocalDBWithOfferId:offerId wuthStartDate:startDate andExpiryDate:expDate andImageName:@"DirectoryOfferPhoto.jpg"];
            NSString *alertMessage;
            if(self.isFromEdit)
                alertMessage = @"Offer updated successfully";
            else
                alertMessage = @"Offer added successfully";
            if(self.isFromSpecialCouponOffer){
                if(self.offerVCDelegate && [self.offerVCDelegate respondsToSelector:@selector(sendButtonActionDelegateWithOfferID:)]){
                    [self.offerVCDelegate sendButtonActionDelegateWithOfferID:offerId];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [self addingAlertControllerForSuccessfulsaveofOfferWithMesaage:alertMessage];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        
    } ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } FailureBlock:^(NSString *errorDescription, id errorResponse) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

#pragma mark - Calling Update Offer Api

-(void)callingUpdateOfferApi{
    NSData *dataenc = [self.dealDescTV.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *encodevalue = [[NSString alloc]initWithData:dataenc encoding:NSUTF8StringEncoding];
    NSData *dataencode = [self.delaNameTF.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *encodevalueName = [[NSString alloc]initWithData:dataencode encoding:NSUTF8StringEncoding];
    NSString *startDate = [self.availableDateTF.text convertDateWithInitialFormat:@"MM/dd/yyyy" ToDateWithFormat:@"yyyy-MM-dd"];
    NSString *expDate;
    if([self.expDateTF.text length]>0)
        expDate= [self.expDateTF.text convertDateWithInitialFormat:@"MM/dd/yyyy" ToDateWithFormat:@"yyyy-MM-dd"];
    UIImage *uploadingImage = [[Utilities standardUtilities]compressImage:self.photoImageView.image];
    NSData *uploadImageData = UIImageJPEGRepresentation(uploadingImage, 1);
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    Offers *offer = (Offers *)self.offerDetails;
    NSURL *uploadProfPicUrl = [NSURL URLWithString:BaseUrl];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:[NSNumber numberWithInt:offer.offerID] forKey:@"offer_id"];
    [dataDictionary setValue:[NSNumber numberWithLong:busUser.business_id] forKey:@"business_id"];
    [dataDictionary setValue:encodevalueName forKey:@"offer_name"];
    [dataDictionary setValue:encodevalue forKey:@"description"];
    [dataDictionary setValue:[NSNumber numberWithInt:0] forKey:@"is_special_coupon"];
    
    [dataDictionary setValue:startDate forKey:@"available_date"];
    if(expDate == nil)
        [dataDictionary setValue:@"" forKey:@"expiry_date"];
    else
        [dataDictionary setValue:expDate forKey:@"expiry_date"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:uploadProfPicUrl withBody:dataDictionary withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startUploadRequest:offer.firstImageFileName withData:uploadImageData withType:fileTypeJPGImage withUrlParameter:updateOffer withFileLocation:@"imageFile" SuccessBlock:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSNumber *offerId = [NSNumber numberWithInt:offer.offerID];
            [self saveOfferDetailsToLocalDBWithOfferId:offerId wuthStartDate:startDate andExpiryDate:expDate andImageName:offer.firstImageFileName];
            [self addingAlertControllerForSuccessfulsaveofOfferWithMesaage:@"Offer updated successfully"];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        
    } ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } FailureBlock:^(NSString *errorDescription, id errorResponse) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

#pragma mark - Adding Alert Controller

-(void)addingAlertControllerForSuccessfulsaveofOfferWithMesaage:(NSString *)messageString{
    UIAlertController *saveOfferSuessAlertController = [UIAlertController alertControllerWithTitle:AppName message:messageString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.isFromSpecialCouponOffer){
            [self ShowAlert:@"Special Coupon has been sent"];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    [saveOfferSuessAlertController addAction:okAction];
    [self presentViewController:saveOfferSuessAlertController animated:YES completion:nil];
}

-(void)saveOfferDetailsToLocalDBWithOfferId:(NSNumber *)offerId wuthStartDate:(NSString *)startDate andExpiryDate:(NSString *)expDate andImageName:(NSString *)imageName{
    NSMutableDictionary *offerDictionary = [[NSMutableDictionary alloc] init];
    [offerDictionary setValue:offerId forKey:@"id"];
    [offerDictionary setValue:self.delaNameTF.text forKey:@"name"];
    [offerDictionary setValue:self.dealDescTV.text forKey:@"description"];
    [offerDictionary setValue:startDate forKey:@"available_date"];
    [offerDictionary setValue:expDate forKey:@"expiry_date"];
    [offerDictionary setValue:imageName forKey:@"files"];
    [Offers saveOfferDetailsWithDataDictionary:offerDictionary];
    
}

@end
