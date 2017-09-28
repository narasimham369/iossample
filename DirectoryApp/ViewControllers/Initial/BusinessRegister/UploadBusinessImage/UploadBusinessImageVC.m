//
//  UploadBusinessImageVC.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/22/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Constants.h"
#import "Utilities.h"
#import "BusinessUser.h"
#import "UrlGenerator.h"
#import "CategoryList.h"
#import "MBProgressHUD.h"
#import "SubCategories.h"
#import "NetworkHandler.h"
#import "CategoryList.h"
#import "SubCategories.h"
#import "BusinessOwnerVC.h"
#import "UploadBusinessImageVC.h"
#import <CLToolKit/CLDateHandler.h>
#import "NSString+NSstring_Category.h"
#import <CLToolKit/NSString+Extension.h>
#import "TOCropViewController.h"
#import "FacebookLoginVC.h"


@interface UploadBusinessImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,TOCropViewDelegate,TOCropViewControllerDelegate>
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *subcategoryArray;
@property (nonatomic, strong) UIImage *businessLogoImage;
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
@property (weak, nonatomic) IBOutlet UITextField *subCategoryTF;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *subCategoryToolbar;
@property (weak, nonatomic) IBOutlet UITextField *openingTime;
@property (weak, nonatomic) IBOutlet UITextField *closingTime;
@property (nonatomic,strong)NSString * subCategoryName;
@property (strong, nonatomic) NSString *workingDays;
@property (strong, nonatomic) id selectedCategory;
@property (strong, nonatomic) id selectedSubCategory;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *subCategoryPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *dateToolbar;
@property (nonatomic, strong) BusinessUser *busUser;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIButton *sundayButton;
@property (weak, nonatomic) IBOutlet UIButton *mondayButton;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *wedesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *thursdayButton;
@property (weak, nonatomic) IBOutlet UIButton *fridayButton;
@property (weak, nonatomic) IBOutlet UIButton *saturdayButton;
@property (weak, nonatomic) IBOutlet UIButton *allDateButton;

@property (weak, nonatomic) NSString *openTimeApi;
@property (weak, nonatomic) NSString *closeTimeApi;
@property (weak, nonatomic) NSNumber *subcategoryIdApi;
@property (weak, nonatomic) NSNumber *maincategoryIdApi;


@end

@implementation UploadBusinessImageVC

-(void)initView{
    [super initView];
    [self initialisation];
    if(self.isFromBusinessEdit){
        [self populateUiForUpdateBusiness];
    }
}

-(void)initialisation{
    self.busUser = [BusinessUser getBusinessUser];
    [self getCategoryListApi];
    NSLog(@"%lld",self.busUser.bus_user_id);
    NSLog(@"%d",self.busUser.mainCategoryId);
    [self getSubCategoryListApi];
    [[Utilities standardUtilities]addGradientLayerTo:self.submitButton];
    self.categoryTF.inputView=self.categoryPicker;
    self.categoryTF.inputAccessoryView=self.doneToolbar;
    self.subCategoryTF.inputView=self.subCategoryPicker;
    self.subCategoryTF.inputAccessoryView=self.subCategoryToolbar;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.openingTime setInputView:self.datePicker];
    [self.closingTime setInputView:self.datePicker];
    self.openingTime.inputAccessoryView=self.dateToolbar;
    self.closingTime.inputAccessoryView=self.dateToolbar;
    self.title = @"Upload Business Image";
    [self showButtonOnLeftWithImageName:@""];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.allDateButton.selected = YES;
    [self selectUnselectDate:YES];
}


-(void)populateUiForUpdateBusiness{
    NSLog(@">>%@",self.businessRegistrationDetails);
    NSLog(@">>%@",self.busUser);
    CategoryList *catList = [CategoryList getCategoriesWithCategoryId:[NSNumber numberWithInt:self.busUser.mainCategoryId]];
    self.categoryTF.text = catList.categoryName;
    NSArray *subCtList =[SubCategories getSubCategoryWithParentID:[NSNumber numberWithInt:self.busUser.mainCategoryId]];
    for (SubCategories *sub in subCtList) {
        if(sub.categoryID == self.busUser.subCategoryId)
        {
            self.subCategoryName = sub.categoryName;
        }
    }
    self.subCategoryTF.text = self.subCategoryName;
     NSString *businessID=[NSString stringWithFormat:@"%lld.jpg",self.busUser.business_id];
    if([self.busUser.business_image_cache length]!=0){
    businessID=[NSString stringWithFormat:@"%lld.jpg?%@",self.busUser.business_id,self.busUser.business_image_cache];
    }
    NSURL *finalProfImgUrlStg = [[UrlGenerator sharedHandler]urlForRequestType:EGLUEIMAGEURLFORBUSINESSUSER withURLParameter:businessID];
    [self.self.businessImageView sd_setImageWithURL:finalProfImgUrlStg placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"] options:SDWebImageRefreshCached completed:nil];
    self.categoryTF.text = self.busUser.mainCategoryName;
    self.subCategoryTF.text = self.busUser.subCategoryName;
    self.openingTime.text = [self.busUser.openingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"HH:mm"];;
    self.closingTime.text = [self.busUser.closingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"HH:mm"];
}

- (IBAction)submitButtonAction:(UIButton *)sender {
    if(self.isFromBusinessEdit){
        [self callingUpdateBusinessProfileApi:[NSNumber numberWithLong:self.busUser.business_id] :[NSNumber numberWithLong:self.busUser.bus_user_id]];
    }else{
        if([self isValidInputs])
            [self callingRegisterApi];
    }
}

#pragma mark - Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat value=0;
    if(IS_IPHONE_5){
        value=30;
    }
    [UIView animateWithDuration:.3 animations:^{
        if (textField == self.categoryTF) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } else if (textField == self.subCategoryTF){
            self.scrollView.contentOffset = CGPointMake(0, value+50);
        }
        else if (textField == self.openingTime){
            self.scrollView.contentOffset = CGPointMake(0, value+110);
        }
        else if (textField == self.closingTime){
            self.scrollView.contentOffset = CGPointMake(0, value+110);
        }
    }];
}

#pragma mark - Button Actions

- (IBAction)sundayAction:(UIButton *)sender {
    if (self.sundayButton.selected) {
        self.sundayButton.selected = NO;
    }else {
        self.sundayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)monAction:(UIButton *)sender {
    if (self.mondayButton.selected) {
        self.mondayButton.selected = NO;
    } else {
        self.mondayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)tueAction:(UIButton *)sender {
    if (self.tuesdayButton.selected) {
        self.tuesdayButton.selected = NO;
    } else {
        self.tuesdayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)wedAction:(UIButton *)sender {
    if (self.wedesdayButton.selected) {
        self.wedesdayButton.selected = NO;
    } else {
        self.wedesdayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)thuAction:(UIButton *)sender {
    if (self.thursdayButton.selected) {
        self.thursdayButton.selected = NO;
    } else {
        self.thursdayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)friAction:(UIButton *)sender {
    if (self.fridayButton.selected) {
        self.fridayButton.selected = NO;
    } else {
        self.fridayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)satAction:(UIButton *)sender {
    if (self.saturdayButton.selected) {
        self.saturdayButton.selected = NO;
    } else {
        self.saturdayButton.selected = YES;
    }
    [self CheckDateSelectionStatus];
}

- (IBAction)allDateAction:(UIButton *)sender {
    if (self.allDateButton.selected) {
        self.allDateButton.selected = NO;
        [self selectUnselectDate:NO];
    } else {
        self.allDateButton.selected = YES;
        [self selectUnselectDate:YES];
    }
    [self CheckDateSelectionStatus];
}

-(void)selectUnselectDate:(BOOL)select{
    self.mondayButton.selected=select;
    self.tuesdayButton.selected=select;
    self.wedesdayButton.selected=select;
    self.thursdayButton.selected=select;
    self.fridayButton.selected=select;
    self.saturdayButton.selected=select;
    self.sundayButton.selected=select;
}

-(void)CheckDateSelectionStatus{
    NSString *sun;
    NSString *mon;
    NSString *tue;
    NSString *wed;
    NSString *thu;
    NSString *fri;
    NSString *sat;
    if(self.sundayButton.isSelected){
        sun=@"1";
    }else{
        sun=@"0";
    }
    if(self.mondayButton.isSelected){
        mon=@"1";
    }else{
        mon=@"0";
    }
    if(self.tuesdayButton.isSelected){
        tue=@"1";
    }else{
        tue=@"0";
    }
    if(self.wedesdayButton.isSelected){
        wed=@"1";
    }else{
        wed=@"0";
    }
    if(self.thursdayButton.isSelected){
        thu=@"1";
    }else{
        thu=@"0";
    }
    if(self.fridayButton.isSelected){
        fri=@"1";
    }else{
        fri=@"0";
    }
    if(self.saturdayButton.isSelected){
        sat=@"1";
    }else{
        sat=@"0";
    }
    self.workingDays=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",sun,mon,tue,wed,thu,fri,sat];
    if([self.workingDays isEqualToString:@"0000000"]){
        self.allDateButton.selected=NO;
    }else if([self.workingDays isEqualToString:@"1111111"]){
        self.allDateButton.selected=YES;
    }
}

-(void)backButtonAction:(UIButton *)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Toolbar Buttons Actions

- (IBAction)categoryDoneAction:(id)sender {
    if(self.selectedCategory == nil) {
        self.categoryTF.text = [[self.categoryArray objectAtIndex:0]valueForKey:@"categoryName"];
        self.selectedCategory = [self.categoryArray objectAtIndex:0];
    }
    else {
        self.categoryTF.text = [self.selectedCategory valueForKey:@"categoryName"];
    }
    [self getSubCategoryListApi];
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (IBAction)subCategoryDoneButtonAction:(id)sender {
    if(self.selectedSubCategory==nil){
        if(self.subcategoryArray.count>0){
            self.selectedSubCategory = [self.subcategoryArray firstObject];
        }
    }
    if(self.selectedSubCategory!=nil){
        self.subCategoryTF.text = @"";
        self.subCategoryTF.text = [self.selectedSubCategory valueForKey:@"categoryName"];
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}
- (IBAction)dateDoneButtonAction:(id)sender {
    if ([self.openingTime isEditing]) {
        self.openingTime.text = [[CLDateHandler standardUtilities] convertDate:self.datePicker.date toFormatedString:@"HH:mm" withTimeZone:[NSTimeZone systemTimeZone]];
    }
    else if([self.closingTime isEditing]){
        self.closingTime.text = [[CLDateHandler standardUtilities] convertDate:self.datePicker.date toFormatedString:@"HH:mm" withTimeZone:[NSTimeZone systemTimeZone]];
    }
    else{
        
    }
    [self.view endEditing:YES];
    self.scrollView.contentOffset = CGPointMake(0, 0);
}


-(void)emailConfirm{
    FacebookLoginVC *fbLogin =[[FacebookLoginVC alloc]initWithNibName:@"FacebookLoginVC" bundle:nil];
    fbLogin.isFromBussinessRegister=YES;
    fbLogin.userName=[self.businessRegistrationDetails valueForKey:@"email"];
    fbLogin.password=[self.businessRegistrationDetails valueForKey:@"password"];
    [self.navigationController pushViewController:fbLogin animated:YES];
}

#pragma mark - Gesture Actions

- (IBAction)viewTapGestureAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
    
}
- (IBAction)imageViewTapGestureAction:(UITapGestureRecognizer *)sender {
    [self actionSheetAlertControllerForImagePicking];
}

#pragma mark - Alert Controller for Image Picking

- (void)actionSheetAlertControllerForImagePicking{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [[Utilities standardUtilities] goToCameraIsFromUser:NO withSuccessBlock:^(BOOL isSuccess) {
                                                                  if(isSuccess){
                                                                      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                      picker.delegate = self;
                                                                      picker.allowsEditing = YES;
                                                                      picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
                                                                   imagePickerController.view.backgroundColor = [UIColor whiteColor];                                      imagePickerController.delegate = self;
                                                                   imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       [self presentViewController:imagePickerController animated:YES completion:nil];
                                                                   });
                                                               }
                                                               
                                                           }];
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = self.businessImageView;
    popPresenter.sourceRect = self.businessImageView.bounds;
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.businessImageView.image = image;
    self.businessLogoImage = image;
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Category Picker Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.categoryPicker)
        return [self.categoryArray count];
    else
        return [self.subcategoryArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView == self.categoryPicker)
        return [[self.categoryArray objectAtIndex:row]valueForKey:@"categoryName"];
    else
        return [[self.subcategoryArray objectAtIndex:row]valueForKey:@"categoryName"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == self.categoryPicker){
        self.selectedCategory = [self.categoryArray objectAtIndex:row];
        self.selectedSubCategory = nil;
        self.subCategoryTF.text = @"";
    }
    else
        self.selectedSubCategory = [self.subcategoryArray objectAtIndex:row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)isValidInputs{
    BOOL valid = YES;
    NSString *errorMessageString = @"";
    if ([self.categoryTF.text empty]){
        errorMessageString = @"Please select business category";
        valid = NO;
    }
    else if ([self.subCategoryTF.text empty]){
        errorMessageString = @"Please select business sub category";
        valid = NO;
    }
    else if ([self.subCategoryTF.text empty]){
        errorMessageString = @"Please select business sub category";
        valid = NO;
    }
    else if ([self.openingTime.text empty]){
        errorMessageString = @"Please select opening time";
        valid = NO;
    }
    else if ([self.closingTime.text empty]){
        errorMessageString = @"Please select closing time";
        valid = NO;
    }
    if(!valid)
        [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:errorMessageString];
    return valid;
}

#pragma mark - user defined delegate method

-(void)closeButtonActionDelegate{
    [self dismissViewControllerAnimated:YES completion:nil];;
}

#pragma mark - Get Category List Api call

-(void)getCategoryListApi {
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETCATEGORYLIST withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [CategoryList saveCategoryListDetails:[responseObject valueForKey:@"data"]];
        self.categoryArray =[CategoryList getCategoryList];
        [self.categoryPicker reloadAllComponents];
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
    }];
}

#pragma mark - Get SubCategory List Api call

-(void)getSubCategoryListApi {
    NSString *urlParameter;
    if([self.selectedCategory valueForKey:@"categoryID"]){
        urlParameter = [NSString stringWithFormat:@"%@", [self.selectedCategory valueForKey:@"categoryID"]];
    }
    else{
        urlParameter = [NSString stringWithFormat:@"%d",self.busUser.mainCategoryId];
    }
    
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETSUBCATEGORYLIST withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [SubCategories saveSubCategoriesDetails:[responseObject valueForKey:@"data"]];
        if([self.selectedCategory valueForKey:@"categoryID"]){
            self.subcategoryArray = [SubCategories getSubCategoryWithParentID:[self.selectedCategory valueForKey:@"categoryID"]];
        }
        else{
            self.subcategoryArray = [SubCategories getSubCategoryWithParentID:[NSNumber numberWithInt:self.busUser.mainCategoryId]];
        }
        [self.subCategoryPicker reloadAllComponents];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
    }];
}

#pragma mark - Showing Home Page

-(void)updateLoginDetails{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isBusinessUser];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }];
    
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//---------------------------------------------------API CALL------------------------------------------------------


#pragma mark - Register Api calling

-(void)callingRegisterApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSNumber *subcategoryId;
    NSNumber *maincategoryId;
    subcategoryId = [self.selectedSubCategory valueForKey:@"categoryID"];
    maincategoryId = [NSNumber numberWithInt:self.busUser.mainCategoryId];
    NSString *openingTime = [self.openingTime.text convertDateWithInitialFormat:@"HH:mm" ToDateWithFormat:@"HH:mm:ss"];
    NSString *closingTime = [self.closingTime.text convertDateWithInitialFormat:@"HH:mm" ToDateWithFormat:@"HH:mm:ss"];
    UIImage *uploadingImage = [[Utilities standardUtilities]compressImage:self.businessLogoImage];
    NSData *uploadImageData = UIImageJPEGRepresentation(uploadingImage, 0.1);
    NSURL *uploadProfPicUrl = [NSURL URLWithString:BaseUrl];
    self.openTimeApi=openingTime;
    self.closeTimeApi=closingTime;
    self.subcategoryIdApi=subcategoryId;
    self.maincategoryIdApi=maincategoryId;
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"firstName"] forKey:@"firstName"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"lastName"] forKey:@"lastName"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"phone"] forKey:@"phone"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"email"] forKey:@"email"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"password"] forKey:@"password"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"address"] forKey:@"address"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"city"] forKey:@"city"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"state_id"] forKey:@"state"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"zip"] forKey:@"zip"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"businessName"] forKey:@"businessName"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"street"] forKey:@"street"];
    [dataDictionary setValue:subcategoryId forKey:@"category_id"];
    [dataDictionary setValue:@" " forKey:@"website"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"latitude"] forKey:@"latitude"];
    [dataDictionary setValue:[self.businessRegistrationDetails valueForKey:@"longitude"] forKey:@"longitude"];
    [dataDictionary setValue:openingTime forKey:@"opening_time"];
    [dataDictionary setValue:closingTime forKey:@"closing_time"];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:uploadProfPicUrl withBody:dataDictionary withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startUploadRequest:@"DirectoryProfilePhoto" withData:uploadImageData withType:fileTypeJPGImage withUrlParameter:businessRegistration withFileLocation:@"imageFile" SuccessBlock:^(id responseObject) {
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSNumber *businessId = [[responseObject valueForKey:@"data"] valueForKey:@"business_id"];
            NSNumber *busUserId = [[responseObject valueForKey:@"data"] valueForKey:@"user_id"];
            [self savingToLocalDBWithBusinessId:businessId withUserId:busUserId];
            [self callingUpdateBusinessProfileApi:businessId :busUserId];
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } FailureBlock:^(NSString *errorDescription, id errorResponse) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self ShowAlert:errorDescription];
    }];
}


-(void)savingToLocalDBWithBusinessId:(NSNumber *)businessId withUserId:(NSNumber *)busUserId{
    NSMutableDictionary *businessDictionary = [[NSMutableDictionary alloc] init];
    [businessDictionary setValue:businessId forKey:@"business_id"];
    [businessDictionary setValue:busUserId forKey:@"user_id"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"firstName"]forKey:@"firstName"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"lastName"] forKey:@"lastName"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"businessName"] forKey:@"businessName"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"address"] forKey:@"address"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"phone"] forKey:@"country_id"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"countryName"]  forKey:@"countryName"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"zip"] forKey:@"zip"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"city"] forKey:@"city"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"state_id"] forKey:@"state_id"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"stateName"] forKey:@"stateName"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"phone"] forKey:@"phone"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"street"] forKey:@"street"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"email"] forKey:@"email"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"password"] forKey:@"password"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"latitude"] forKey:@"latitude"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"longitude"] forKey:@"longitude"];
    [businessDictionary setValue:self.subcategoryIdApi forKey:@"subCategoryId"];
    [businessDictionary setValue:self.subcategoryIdApi forKey:@"mainCategoryId"];
    [businessDictionary setValue:@" " forKey:@"website"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"latitude"] forKey:@"latitude"];
    [businessDictionary setValue:[self.businessRegistrationDetails valueForKey:@"longitude"] forKey:@"longitude"];
    [businessDictionary setValue:self.openTimeApi forKey:@"openingTime"];
    [businessDictionary setValue:self.closeTimeApi forKey:@"closingTime"];
    
    [BusinessUser saveBusinessuserToLocalDbWithDataDictionary:businessDictionary];
}

#pragma mark - Calling Update Business Profile Api

-(void)callingUpdateBusinessProfileApi:(NSNumber*)businessId :(NSNumber*)userId{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSNumber *subcategoryId;
    NSNumber *maincategoryId;
    if(!self.isFromBusinessEdit){
        subcategoryId = [self.selectedSubCategory valueForKey:@"categoryID"];
    }
    else{
        subcategoryId = [NSNumber numberWithInt:self.busUser.subCategoryId];
    }
    if(!self.isFromBusinessEdit){
        maincategoryId = [self.selectedCategory valueForKey:@"categoryID"];
    }
    else{
        maincategoryId = [NSNumber numberWithInt:self.busUser.mainCategoryId];
    }
    NSString *openingTime = [self.openingTime.text convertDateWithInitialFormat:@"HH:mm" ToDateWithFormat:@"HH:mm:ss"];
    NSString *closingTime = [self.closingTime.text convertDateWithInitialFormat:@"HH:mm" ToDateWithFormat:@"HH:mm:ss"];
    if(_isFromBusinessEdit){
        BusinessUser *busUser = [BusinessUser getBusinessUser];
        if([[self.businessRegistrationDetails valueForKey:@"latitude"] isEqual:[NSNumber numberWithInt:0]]){
             NSLog(@"%f",busUser.latitude);
            [self.businessRegistrationDetails setValue:[NSNumber numberWithDouble:busUser.latitude] forKey:@"latitude"];
            [self.businessRegistrationDetails setValue:[NSNumber numberWithDouble:busUser.longitude] forKey:@"longitude"];
        }
       
    }
    NSString *updateBusinessProfUrlString = [NSString stringWithFormat:@"business_id=%@&business_name=%@&category_id=%@&business_address=%@&business_email=%@&business_phone=%@&website=%@&latitude=%@&longitude=%@&opening_time=%@&closing_time=%@&street=%@&city=%@&zip=%@",businessId,[self.businessRegistrationDetails valueForKey:@"businessName"],subcategoryId,[self.businessRegistrationDetails valueForKey:@"address"],[self.businessRegistrationDetails valueForKey:@"email"],[self.businessRegistrationDetails valueForKey:@"phone"],[self.businessRegistrationDetails valueForKey:@"email"],[self.businessRegistrationDetails valueForKey:@"latitude"],[self.businessRegistrationDetails valueForKey:@"longitude"],openingTime,closingTime,[self.businessRegistrationDetails valueForKey:@"street"],[self.businessRegistrationDetails valueForKey:@"city"],[self.businessRegistrationDetails valueForKey:@"zip"]];
    NSURL *updateBusinessProfileUrl = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEUPDATEBUSINESSPROFILE withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:updateBusinessProfileUrl withBody:updateBusinessProfUrlString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(_isFromBusinessEdit){
                BusinessUser *busUser = [BusinessUser getBusinessUser];
                 [self savingToLocalDBWithBusinessId:businessId withUserId:userId];
                busUser.business_id = [businessId intValue];
                busUser.bus_user_id = [userId intValue];
                busUser.openingTime = openingTime;
                busUser.closingTime = closingTime;
                if([self.selectedCategory valueForKey:@"categoryID"]){
                busUser.mainCategoryId = [[self.selectedCategory valueForKey:@"categoryID"] intValue];
                busUser.mainCategoryName = [self.selectedCategory valueForKey:@"categoryName"];
                }
                else{
                    busUser.mainCategoryId =self.busUser.mainCategoryId;
                    busUser.mainCategoryName =self.busUser.mainCategoryName;
                }
                if([self.selectedSubCategory valueForKey:@"categoryID"]){
                    busUser.subCategoryId = [[self.selectedSubCategory valueForKey:@"categoryID"] intValue];
                    busUser.subCategoryName = [self.selectedSubCategory valueForKey:@"categoryName"];
                }
                else{
                    busUser.subCategoryId =self.busUser.subCategoryId;
                    busUser.subCategoryName =self.busUser.subCategoryName;
                }
                if(self.businessImageView.image){
                    [self callingUploadBusinessLogoImageApi];
                }

                [[CLCoreDataAdditions sharedInstance]saveEntity];
                [self.navigationController popViewControllerAnimated:NO];
                if(self.editProfileDelegate && [self.editProfileDelegate respondsToSelector:@selector(UpdateButtonActionDelegate)]){
                    [self.editProfileDelegate UpdateButtonActionDelegate];
                }

            }
            else{
            BusinessUser *busUser = [BusinessUser getBusinessUser];
            busUser.business_id = [businessId intValue];
            busUser.bus_user_id = [userId intValue];
            busUser.openingTime = openingTime;
            busUser.closingTime = closingTime;
            busUser.categoryID = [[self.selectedCategory valueForKey:@"categoryID"] intValue];
            busUser.mainCategoryName = [self.selectedCategory valueForKey:@"categoryName"];

            if([self.selectedSubCategory valueForKey:@"categoryID"]){
                busUser.subCategoryId = [[self.selectedSubCategory valueForKey:@"categoryID"] intValue];
                 busUser.subCategoryName = [self.selectedSubCategory valueForKey:@"categoryName"];
            }
            else{
                busUser.subCategoryId =self.busUser.subCategoryId;
                 busUser.subCategoryName =self.busUser.subCategoryName;
            }
            [[CLCoreDataAdditions sharedInstance]saveEntity];
            
            [self updateLoginDetails];
            if(self.businessImageView.image){
               // [self callingUploadBusinessLogoImageApi];
            }
            [self emailConfirm];
            }}
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
        
    }];
}

#pragma mark - Uploading Business Logo Image Api

-(void)callingUploadBusinessLogoImageApi{
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    UIImage *uploadingImage = [[Utilities standardUtilities]compressImage:self.businessLogoImage];
    NSData *uploadImageData = UIImageJPEGRepresentation(uploadingImage, 0.1);
    NSURL *uploadProfPicUrl = [NSURL URLWithString:BaseUrl];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:[NSNumber numberWithLong:busUser.business_id] forKey:@"business_id"];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:uploadProfPicUrl withBody:dataDictionary withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startUploadRequest:@"DirectoryProfilePhoto" withData:uploadImageData withType:fileTypeJPGImage withUrlParameter:uploadBusinesslogoImageUrl withFileLocation:@"imageFile" SuccessBlock:^(id responseObject) {
        NSString *profileId=[NSString stringWithFormat:@"%@.jpg",[NSNumber numberWithLong:busUser.business_id]];
        //testing purose
        //54.214.172.192:8080
       //  NSString *imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
        
        //mainserver
      NSString *imageUrl = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",profileId];
        [[SDImageCache sharedImageCache] removeImageForKey:imageUrl fromDisk:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:DirectoryShowBusImage object:nil];
    } ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } FailureBlock:^(NSString *errorDescription, id errorResponse) {
        
    }];
}

@end
