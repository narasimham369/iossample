//
//  UserRegisterVC.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/15/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#define GenderKey @"gender"
#define GenderIdKey @"id"

#import "User.h"
#import "States.h"
#import "Countries.h"
#import "WebViewVC.h"
#import <CLToolKit/UIKitExt.h>
#import "UserRegisterVC.h"
#import "RequestBodyGenerator.h"
#import "NSDate+NSDate_Category.h"
#import <CLToolKit/NSString+Extension.h>
#import "TOCropViewController.h"
#import "NSString+NSstring_Category.h"
#import "FacebookLoginVC.h"
#import "WebViewUrls.h"
#import "HookedDealsVC.h"

@interface UserRegisterVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,TOCropViewDelegate,TOCropViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIToolbar *phoneToolbar;
@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profImageView;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *countryToolBar;
@property (strong, nonatomic) IBOutlet UIPickerView *statePicker;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIToolbar *stateToolBar;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *genderDoneToolBar;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *dateToolBar;
@property (weak, nonatomic) IBOutlet UIButton *createUserccountButton;
@property (strong, nonatomic) UIImage *uploadImage;
@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) States *state;
@property (nonatomic, strong) id selectedGender;
@property (nonatomic, strong) NSArray *countryArray;
@property (nonatomic, strong) id selectedCountry;
@property (nonatomic, strong) NSMutableArray *statesArray;
@property (nonatomic, strong) id selectedState;
@property (nonatomic, strong) NSString *pickerDateStringValue;
@property (nonatomic, strong) NSString *currentDateStringValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeLabelheightconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordHeight;

@property (nonatomic, assign) int stateApiCallingCount;
@end

@implementation UserRegisterVC

-(void)initView{
    [super initView];
    [self initialisation];
    if(self.isFromFacebookLogIn)
        [self populateFacebookDetails];
    else if (self.isFromEditProfile){
        self.title = @"Edit Profile";
        [self.createUserccountButton setTitle:@"Update" forState:UIControlStateNormal];
        [self populateEditProfile];
        
    }
    self.registerScrollView.delegate=self;
    [self callingStateApi];
    [[Utilities standardUtilities]webViewContentApi];
}

-(void)callingStateApi{
    int countryId = 1;
    [[Utilities standardUtilities]getStatesApiWithCountryid:countryId SuccessResponse:^(id responseObject) {
        [self populateStates];
    } andFailureresponse:^(id errorRespnse, int statusCode) {
      [self populateStates];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Initialisation

-(void)initialisation{
    self.title = @"Create User Account";
    self.stateApiCallingCount = 0;
    self.statesArray=[[NSMutableArray alloc]init];
    [self showButtonOnLeftWithImageName:@"backImage"];
    [self initialisingTermsAndConditionsLabel];
    self.profileView.layer.cornerRadius = self.profileView.height/2;
    [[Utilities standardUtilities]addGradientLayerTo:self.createUserccountButton];
    [[Utilities standardUtilities]addGradientLayerTo:self.profileView];
    self.sexTextField.inputView = self.genderPicker;
    self.sexTextField.inputAccessoryView=self.genderDoneToolBar;
    self.birthdayTextField.inputView = self.datePicker;
    self.datePicker.maximumDate = [NSDate date];
    self.birthdayTextField.inputAccessoryView = self.dateToolBar;
    self.countryTF.inputView = self.countryPicker;
    self.countryTF.inputAccessoryView = self.countryToolBar;
    self.mobileTextField.inputAccessoryView = self.phoneToolbar;
    self.stateTextField.inputView = self.statePicker;
    self.stateTextField.inputAccessoryView = self.stateToolBar;
    self.genderArray=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Male",GenderKey,@"0",GenderIdKey, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Female",GenderKey,@"1",GenderIdKey, nil],nil];
    NSArray *countriesArray = [Countries getCountries];
    if(countriesArray.count == 0){
        [[Utilities standardUtilities] getCountriesApiSuccessResponse:^(id repsonseObject) {
            [self populateCountries];
        } andFailureResponse:^(id errorResponse, int statusCode) {
            
        }];
    }
    else
        [self populateCountries];
    
}
-(void)populateFacebookDetails{
    self.passwordHeightConstraint.constant = 0;
    self.confirmPasswordHeight.constant = 0;
    if([self.fbUserDetails valueForKey:@"email"]){
        self.emailTextField.text = [NSString stringWithFormat:@"%@",[self.fbUserDetails valueForKey:@"email"]];
        self.emailTextField.userInteractionEnabled = NO;
    }
    if([self.fbUserDetails valueForKey:@"first_name"]){
        self.firstNameTextField.text = [NSString stringWithFormat:@"%@",[self.fbUserDetails valueForKey:@"first_name"]];
    }
    if([self.fbUserDetails valueForKey:@"last_name"]){
        self.lastNameTextField.text = [NSString stringWithFormat:@"%@",[self.fbUserDetails valueForKey:@"last_name"]];
    }
    if([self.fbUserDetails valueForKey:@"dob"]){
    }
    if([self.fbUserDetails valueForKey:@"gender"]){
        NSString *gender = [NSString stringWithFormat:@"%@",[self.fbUserDetails valueForKey:@"gender"]];
        if([gender isEqualToString:@"male"]){
            self.selectedGender = [self.genderArray firstObject];
            self.sexTextField.text = [self.selectedGender valueForKey:GenderKey];
            [self.genderPicker selectRow:0 inComponent:0 animated:YES];
        }
        else{
            self.selectedGender = [self.genderArray objectAtIndex:1];
            self.sexTextField.text = [self.selectedGender valueForKey:GenderKey];
            [self.genderPicker selectRow:1 inComponent:0 animated:YES];
        }
    }
    
    if([self.fbUserDetails  objectForKey:@"birthday"]){
        NSString *birthDayString = [self.fbUserDetails objectForKey:@"birthday"];
        self.birthdayTextField.text = [birthDayString convertDateWithInitialFormat:@"MM/dd/yyyy" ToDateWithFormat:@""];
        self.birthdayTextField.userInteractionEnabled = NO;
    }
    NSString *profileImgUrlString = [[[self.fbUserDetails  valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
    if(profileImgUrlString.length>0){
        [self convertingUrlToImageData:profileImgUrlString withCompletionBlock:^(id responseObject) {
            NSData *imageData = (NSData *)responseObject;
            self.uploadImage = [UIImage imageWithData:imageData];
            self.profImageView.image = self.uploadImage;
        }];
    }
    
}

-(void)populateEditProfile{
    User *editUser = [User getUser];;
    [[Utilities standardUtilities] getStatesApiWithCountryid:editUser.country_id SuccessResponse:^(id responseObject) {
        self.state = [States getStatesWithStateId:[NSNumber numberWithInt:editUser.state_id]];
        [self populateState];
    } andFailureresponse:^(id errorRespnse, int statusCode) {
        
    }];
    NSString *profileId=[NSString stringWithFormat:@"%d.jpg",editUser.user_id];
    //54.214.172.192:8080
    //testing purpose
   NSString *finalProfImgUrlStg = [NSString stringWithFormat:@"%@""%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
    
    //mainserver
//    NSString *finalProfImgUrlStg = [NSString stringWithFormat:@"%@""%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
    [self.profImageView sd_setImageWithURL:[NSURL URLWithString:finalProfImgUrlStg] placeholderImage:[UIImage imageNamed:@"ProfilePlaceholder"] options:SDWebImageRefreshCached completed:nil];

    self.firstNameTextField.text = editUser.first_name;
    self.firstNameTextField.userInteractionEnabled = NO;
    self.lastNameTextField.text = editUser.last_name;
    self.lastNameTextField.userInteractionEnabled = NO;
    self.birthdayTextField.text = editUser.dob;
    self.birthdayTextField.userInteractionEnabled = NO;
    if(editUser.gender == 0)
        self.sexTextField.text = @"male";
    else
        self.sexTextField.text = @"female";
    self.sexTextField.userInteractionEnabled = NO;
    self.countryTF.text = editUser.countryName;
    self.countryTF.userInteractionEnabled = NO;
    self.stateTextField.userInteractionEnabled = NO;
    self.mobileTextField.text = editUser.phone;
    self.emailTextField.text = editUser.email;
    self.passwordHeightConstraint.constant = 0;
    self.agreeLabelheightconstraint.constant = 0;
    self.agreeButtonHeightConstraint.constant = 0;
    self.confirmPasswordHeight.constant = 0;
    self.emailTextField.userInteractionEnabled = NO;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)populateState{
    self.stateTextField.text = self.state.stateName;
}
-(void)convertingUrlToImageData:(NSString *)imageUrlString withCompletionBlock:(void(^)(id responseObject))completion{
    NSString *strImgURLAsString = imageUrlString;
    [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            completion(data);
        }else{
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            completion(nil);
        }
    }];
}


-(void)initialisingTermsAndConditionsLabel{
    UIColor *normalColor = [UIColor colorWithRed:0.24 green:0.22 blue:0.29 alpha:1.0];
    UIColor *highlightColor = AppCommonBlueColor;
    UIFont *normalFont = [UIFont fontWithName:@"Dosis-Regular" size:14.0];
    UIFont *highlightedFont = [UIFont fontWithName:@"Dosis-Bold" size:14.0];
    NSDictionary *normalAttributes = @{NSFontAttributeName:normalFont, NSForegroundColorAttributeName:normalColor};
    NSDictionary *highlightAttributes = @{NSFontAttributeName:highlightedFont, NSForegroundColorAttributeName:highlightColor};
    
    NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:@"I agree to the " attributes:normalAttributes];
    NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"terms and conditions" attributes:highlightAttributes];
    
    NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:normalText];
    [finalAttributedString appendAttributedString:highlightedText];
    self.agreeLabel.attributedText = finalAttributedString;
}

#pragma mark - Picker Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.genderPicker)
        return [self.genderArray count];
    else if (pickerView == self.countryPicker)
        return [self.countryArray count];
    else if(pickerView == self.statePicker)
        return self.statesArray.count;
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {;
    if(pickerView == self.genderPicker)
        return [[self.genderArray objectAtIndex:row] valueForKey:GenderKey];
    else if (pickerView == self.countryPicker)
        return [[self.countryArray objectAtIndex:row] valueForKey:@"countryName"];
    else if(pickerView == self.statePicker)
        return [[self.statesArray objectAtIndex:row] valueForKey:@"stateName"];
    else
        return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == self.genderPicker)
        self.selectedGender = [self.genderArray objectAtIndex:row];
    else if (pickerView == self.countryPicker){
        self.selectedCountry = [self.countryArray objectAtIndex:row];
        self.selectedState = nil;
        self.stateTextField.text = @"";
    }
    else if (pickerView == self.statePicker)
        self.selectedState = [self.statesArray objectAtIndex:row];
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat value=10;
    if(IS_IPHONE_5){
        value=45;
    }
    [UIView animateWithDuration:.3 animations:^{
        if (textField == self.firstNameTextField) {
            self.registerScrollView.contentOffset = CGPointMake(0, 0);
        } else if (textField == self.lastNameTextField) {
            self.registerScrollView.contentOffset = CGPointMake(0, 0);
        }else if (textField == self.birthdayTextField) {
            self.registerScrollView.contentOffset = CGPointMake(0, 10);
        }
        else if (textField == self.sexTextField){
            self.registerScrollView.contentOffset = CGPointMake(0, 10);
        }
//        else if (textField == self.countryTF){
//            self.registerScrollView.contentOffset = CGPointMake(0, value+35);
//        }
        else if (textField == self.mobileTextField){
            self.registerScrollView.contentOffset = CGPointMake(0, value+105);
        }
        else if (textField == self.stateTextField){
            self.registerScrollView.contentOffset = CGPointMake(0, value+105);
        }
        else if (textField == self.emailTextField){
            self.registerScrollView.contentOffset = CGPointMake(0, value+130);
        }
        else if (textField == self.passwordTextField){
            self.registerScrollView.contentOffset = CGPointMake(0, value+200);
        }
        else if (textField == self.confirmPassword){
            self.registerScrollView.contentOffset = CGPointMake(0, value+250);
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.mobileTextField) {
        NSString *newString = [self.mobileTextField.text stringByReplacingCharactersInRange:range withString:string];
        int charCount = (int)newString.length;
        if (charCount > 12) {
            return NO;
        }
        return YES;
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField == self.firstNameTextField)
        [self.lastNameTextField becomeFirstResponder];
    else if (textField == self.lastNameTextField)
        [self.birthdayTextField becomeFirstResponder];
    else if (textField == self.birthdayTextField)
        [self.sexTextField becomeFirstResponder];
    else if (textField == self.sexTextField)
        [self.mobileTextField becomeFirstResponder];
    else if (textField == self.mobileTextField)
        [self.stateTextField becomeFirstResponder];
    else if (textField == self.mobileTextField)
        [self.emailTextField becomeFirstResponder];
    else if (textField == self.emailTextField){
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == self.passwordTextField){
        [self.confirmPassword becomeFirstResponder];
    }
    else if (textField == self.confirmPassword){
        [UIView animateWithDuration:.3 animations:^{
            self.registerScrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    return YES;
}

#pragma mark - Alert Controller for Image Picking

- (void)actionSheetAlertControllerForImagePicking{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [[Utilities standardUtilities] goToCameraIsFromUser:YES withSuccessBlock:^(BOOL isSuccess) {
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
                                                               if([[Utilities standardUtilities]gotoGalleryIsFromUser:YES]){                          UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                                                                   imagePickerController.view.backgroundColor = [UIColor whiteColor];                                      imagePickerController.delegate = self;
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
    popPresenter.sourceView = self.profImageView;
    popPresenter.sourceRect = self.profImageView.bounds;
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
    self.profImageView.image = image;
    self.uploadImage = image;
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)genderClearAction:(id)sender {
    self.sexTextField.text=@"";
}
- (IBAction)dateClearAction:(id)sender {
    self.birthdayTextField.text=@"";
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    if(self.isFromEditProfile)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraButtonAction:(UIButton *)sender {
    [self actionSheetAlertControllerForImagePicking];
}
- (IBAction)phoneTextDoneButtonAction:(id)sender {
    if(self.isFromEditProfile){
        [self.view endEditing:YES];
        self.registerScrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
        [self.stateTextField becomeFirstResponder];
    }
}

- (IBAction)dateDoneButtonAction:(UIBarButtonItem *)sender {
    [self datePickerChanged:self.datePicker];
    if([self.pickerDateStringValue isEqualToString:@""] || self.pickerDateStringValue == nil){
        [self currentDate];
        self.birthdayTextField.text = self.currentDateStringValue;
    }else{
        self.birthdayTextField.text = self.pickerDateStringValue;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.registerScrollView.contentOffset = CGPointMake(0, 0);
        [self.view endEditing:YES];
        [self.sexTextField becomeFirstResponder];
    }];
}
- (IBAction)pickerDoneAction:(UIBarButtonItem *)sender {
    if(self.selectedGender == nil)
        self.selectedGender = [self.genderArray firstObject];
    self.sexTextField.text = [self.selectedGender valueForKey:GenderKey];
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.registerScrollView.contentOffset = CGPointMake(0, 0);
        [self.mobileTextField becomeFirstResponder];
    }];
}
- (IBAction)countryDoneButtonAction:(UIBarButtonItem *)sender {
    if(self.selectedCountry == nil){
        if(self.countryArray.count>0){
            self.selectedCountry = [self.countryArray firstObject];
        }
    }
    if(self.selectedCountry!=nil){
        self.countryTF.text = [self.selectedCountry valueForKey:@"countryName"];
        int countryId = [[self.selectedCountry valueForKey:@"countryId"] intValue];
        NSArray *stateArray = [States getStatesWithCountryCode:[NSNumber numberWithInt:countryId]];
        if(stateArray.count==0){
            [[Utilities standardUtilities]getStatesApiWithCountryid:countryId SuccessResponse:^(id responseObject) {
                [self populateStates];
            } andFailureresponse:^(id errorRespnse, int statusCode) {
                
            }];
        }
        else{
            [self populateStates];
        }
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.registerScrollView.contentOffset = CGPointMake(0, 0);
        [self.stateTextField becomeFirstResponder];
    }];
}
- (IBAction)stateDoneButtonAction:(UIBarButtonItem *)sender {
    if(self.selectedState == nil){
        if(self.statesArray.count>0){
            self.selectedState = [self.statesArray firstObject];
        }
    }
    if(self.selectedState!=nil){
        self.stateTextField.text = [self.selectedState valueForKey:@"stateName"];
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.registerScrollView.contentOffset = CGPointMake(0, 0);
        [self.emailTextField becomeFirstResponder];
    }];
}

- (IBAction)termsCheckBoxAction:(UIButton *)sender {
    if(![sender isSelected]){
        sender.selected = YES;
    }
    else{
        sender.selected = NO;
    }
}
- (IBAction)createAccountButtonAction:(UIButton *)sender {
    if(self.isFromFacebookLogIn){
        if([self isValidFBRegistration]){
            [self callingSocialRegisterApi];
        }
    }
    else if(self.isFromEditProfile){
        if([self isValidEditProfile]){
             [self editProfileApi];
        }
    }
    else{
        if([self isValidRegistration]){
            
            [self emailCheckApi];
        }
    }
}

-(BOOL)isValidRegistration{
    BOOL valid = YES;
    NSString *errorMessageString = @"";
    if([self.firstNameTextField.text empty]){
        errorMessageString = @"Please enter first name";
        valid = NO;
    }
    else if (![self.firstNameTextField.text validName]){
        self.firstNameTextField.text = @"";
        errorMessageString = @"Please enter valid first name";
        valid = NO;
    }
    else if ([self.lastNameTextField.text empty]){
        errorMessageString = @"Please enter last name";
        valid = NO;
    }
    else if (![self.lastNameTextField.text validName]){
        self.lastNameTextField.text = @"";
        errorMessageString = @"Please enter valid last name";
        valid = NO;
    }
    else if ([self.stateTextField.text empty]){
        errorMessageString = @"Please choose your state";
        valid = NO;
    }
    else if ([self.mobileTextField.text empty]){
        errorMessageString = @"Please enter your mobile number";
        valid = NO;
    }
    else if ([self.mobileTextField.text length] < 10){
        errorMessageString = @"Please enter a valid mobile number";
        valid = NO;
        
    }
    else if ([self.emailTextField.text empty]){
        errorMessageString = @"Please enter your email id";
        valid = NO;
    }
    else if (![self.emailTextField.text validEmail]){
        self.emailTextField.text = @"";
        errorMessageString = @"Please enter valid email id";
        valid = NO;
    }
    else if ([self.passwordTextField.text empty]){
        errorMessageString = @"Please enter password";
        valid = NO;
    }
    else if ([self.passwordTextField.text length] < 8){
        errorMessageString = @"Your password should be 8 digits";
        valid = NO;
    }else if (![self.confirmPassword.text isEqualToString:self.passwordTextField.text]){
        errorMessageString = @"Password and Confirm password should be same";
        valid = NO;
    }
    else if (![self.agreeButton isSelected]){
        errorMessageString = @"Need to accept our terms and Condition";
        valid = NO;
    }
    
    if(!valid){
        [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:errorMessageString];
    }
    return valid;
}

-(BOOL)isValidFBRegistration{
    BOOL valid = YES;
    NSString *errorMessageString = @"";
    if([self.firstNameTextField.text empty]){
        errorMessageString = @"Please enter first name";
        valid = NO;
    }
    else if (![self.firstNameTextField.text validName]){
        self.firstNameTextField.text = @"";
        errorMessageString = @"Please enter valid first name";
        valid = NO;
    }
    else if ([self.lastNameTextField.text empty]){
        errorMessageString = @"Please enter last name";
        valid = NO;
    }
    else if (![self.lastNameTextField.text validName]){
        self.lastNameTextField.text = @"";
        errorMessageString = @"Please enter valid last name";
        valid = NO;
    }
    else if ([self.stateTextField.text empty]){
        errorMessageString = @"Please choose your state";
        valid = NO;
    }
    else if ([self.mobileTextField.text empty]){
        errorMessageString = @"Please enter your mobile number";
        valid = NO;
    }
    else if ([self.mobileTextField.text length] < 10){
        errorMessageString = @"Please enter a valid mobile number";
        valid = NO;
        
    }
    else if ([self.emailTextField.text empty]){
        errorMessageString = @"Please enter your email id";
        valid = NO;
    }
    else if (![self.emailTextField.text validEmail]){
        self.emailTextField.text = @"";
        errorMessageString = @"Please enter valid email id";
        valid = NO;
    }
    else if (![self.agreeButton isSelected]){
        errorMessageString = @"Need to accept our terms and Condition";
        valid = NO;
    }
    
    if(!valid){
        [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:errorMessageString];
    }
    return valid;
}

-(BOOL)isValidEditProfile{
    BOOL valid = YES;
    NSString *errorMessageString = @"";
    if ([self.mobileTextField.text empty]){
        errorMessageString = @"Please enter your mobile number";
        valid = NO;
    }
    else if ([self.mobileTextField.text length] < 10){
        errorMessageString = @"Please enter a valid mobile number";
        valid = NO;
        
    }
    if(!valid){
        [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:errorMessageString];
    }
    return valid;
}


#pragma mark - Geature Actions

- (IBAction)viewGestureAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.registerScrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (IBAction)imageViewTapGestureAction:(UITapGestureRecognizer *)sender {
    [self actionSheetAlertControllerForImagePicking];
}

- (IBAction)agreeLabelGestureAction:(UITapGestureRecognizer *)sender {
    [self urlType:[NSNumber numberWithInt:2]];
}

#pragma mark - Converting Date

- (void)currentDate {
    NSDate *d = [NSDate date];
    self.currentDateStringValue= [d convertDateToDateWithFormat:@"MM/dd/yyyy"];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSString  *date2 = [self.datePicker.date convertDateToDateWithFormat:@"MM/dd/yyyy"];
    self.pickerDateStringValue = date2;
}


#pragma mark - Register Api calling

-(void)callingRegisterApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *dob = [self getDobInApiFormat];
    NSString *stateIdString = [NSString stringWithFormat:@"%@",[self.selectedState valueForKey:@"stateId"]];
    if([stateIdString isEqualToString:@"(null)"]){
        stateIdString=@"39";
    }
    NSString *genderId = @"";
    if(self.selectedGender!=nil)
        genderId = [self.selectedGender valueForKey:GenderIdKey];
    NSString *registerString = [NSString stringWithFormat:@"firstName=%@&lastName=%@&dob=%@&phone=%@&email=%@&password=%@&address=%@&city=%@&state=%@&zip=%@&gender=%@",self.firstNameTextField.text,self.lastNameTextField.text,dob,self.mobileTextField.text,self.emailTextField.text,self.passwordTextField.text,@"",@"",stateIdString,@"",genderId];
    NSURL *registerUrlString = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEUSERREGISTER withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:registerUrlString withBody:registerString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [[CLCoreDataAdditions sharedInstance]saveEntity];
            NSNumber *userId = [[responseObject valueForKey:@"data"] valueForKey:@"user_id"];
            [[Utilities standardUtilities]clearAllLocalData];
            [self savingRegisteredUserDetailsToLocalDbWithUserId:userId];
            [self callingUploadProfileImageApi];
            [self HookDelasTap];
             //[self emailConfirm];
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


-(void)editProfileApi {
    User *user = [ User getUser];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEEDITPROFILE withURLParameter:nil];
    NSString *registerString = [NSString stringWithFormat:@"user_id=%d&phone=%@&address=%@&city=%@&state_id=%d&zip=%@",user.user_id,self.mobileTextField.text,@"",@"",user.state_id,@""];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:registerString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            [[CLCoreDataAdditions sharedInstance]saveEntity];
            [self savingRegisteredUserDetailsToLocalDbWithUserId:[NSNumber numberWithInt:user.user_id]];
            [self callingUploadProfileImageApi];
            [self.navigationController popViewControllerAnimated:YES];
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



-(void)callingUploadProfileImageApi{
    NSData *uploadImageData;
    if(![self.profImageView image]){
        int gender = [[self.selectedGender valueForKey:GenderIdKey] intValue];
        UIImage *placeImage;
        if(gender == 0)
            placeImage = [UIImage imageNamed:@"malePlaceHolder"];
        else
            placeImage = [UIImage imageNamed:@"femalePlaceHolder"];
        uploadImageData = UIImageJPEGRepresentation(placeImage, 1.0);
    }
    else{
        UIImage *uploadingImage = [[Utilities standardUtilities]compressImage:self.uploadImage];
        uploadImageData = UIImageJPEGRepresentation(uploadingImage, 0.1);
    }
    
    User *user = [User getUser];
    NSURL *uploadProfPicUrl = [NSURL URLWithString:BaseUrl];
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:[NSNumber numberWithInt:user.user_id] forKey:@"user_id"];
    if(self.isFromEditProfile)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetworkHandler *networkHandler = [[NetworkHandler alloc] initWithRequestUrl:uploadProfPicUrl withBody:dataDictionary withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startUploadRequest:@"DirectoryProfilePhoto" withData:uploadImageData withType:fileTypeJPGImage withUrlParameter:updateUserProfPic withFileLocation:@"imageFile" SuccessBlock:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *profileId=[NSString stringWithFormat:@"%@.jpg",[NSNumber numberWithInt:user.user_id]];
        
        //54.214.172.192:8080
        //testing purpose
          NSString *imageUrl = [NSString stringWithFormat:@"%@%@",@"http://dev.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
        
        //main server
        // NSString *imageUrl = [NSString stringWithFormat:@"%@%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/ProfileImages/",profileId];
        [[SDImageCache sharedImageCache] removeImageForKey:imageUrl fromDisk:YES withCompletion:^{
         
        }];
        
    } ProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } FailureBlock:^(NSString *errorDescription, id errorResponse) {
    }];
    
}
#pragma mark - emailCheckApi Api call

-(void)emailCheckApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlParameter = [NSString stringWithFormat:@"email=%@",self.emailTextField.text];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEEMAILCHECK withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[[responseObject valueForKey:@"data"]valueForKey:@"isExist"]isEqual:[NSNumber numberWithInt:0]]){
            [self phoneNumberCheckApi];
        }else{
            [self ShowAlert:@"Email id is already exist, Please try with a diffrent id"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - phoneNumberCheckApi Api call

-(void)phoneNumberCheckApi{
    NSString *urlParameter = [NSString stringWithFormat:@"phone=%@",self.mobileTextField.text];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEPHONECHECK withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[[responseObject valueForKey:@"data"]valueForKey:@"isExist"]isEqual:[NSNumber numberWithInt:0]]){
            if(self.isFromEditProfile){
                if([self isValidEditProfile]){
                    [self editProfileApi];
                }
            }
            else{
                if([self isValidRegistration]){
                    [self callingRegisterApi];
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            [self ShowAlert:@"Phone number is already exist, Please try with a diffrent number"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


-(void)callingSocialRegisterApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *dob = [self getDobInApiFormat];
    NSString *stateIdString = [NSString stringWithFormat:@"%@",[self.selectedState valueForKey:@"stateId"]];
    if([stateIdString isEqualToString:@"(null)"]){
        stateIdString=@"39";
    }
    NSString *socialMediaId = [NSString stringWithFormat:@"%@",[self.fbUserDetails valueForKey:@"id"]];
    NSString *genderId = @"";
    if(self.selectedGender!=nil)
    genderId = [self.selectedGender valueForKey:GenderIdKey];
    NSString *registerString = [NSString stringWithFormat:@"firstName=%@&lastName=%@&dob=%@&phone=%@&email=%@&socialMediaId=%@&address=%@&city=%@&state=%@&zip=%@&gender=%@",self.firstNameTextField.text,self.lastNameTextField.text,dob,self.mobileTextField.text,self.emailTextField.text,socialMediaId,@"",@"",stateIdString,@"",genderId];
    NSURL *registerUrlString = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESOCIALREGISTRATION withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:registerUrlString withBody:registerString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSArray *userDetailArray = [responseObject valueForKey:@"data"];
            id userDetails;
            if(userDetailArray.count>0)
             userDetails = [userDetailArray firstObject];;
            NSNumber *userId = [userDetails valueForKey:@"user_id"];
            [[Utilities standardUtilities]clearAllLocalData];
            [self savingRegisteredUserDetailsToLocalDbWithUserId:userId];
            [self callingUploadProfileImageApi];
            if(!self.isFromEditProfile){
                //[self emailConfirm];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isNormalUser];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoggedIn];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isFacebookLogIn];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:DirectoryShowHome object:nil];
            }
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



-(NSString *)getDobInApiFormat{
    NSString *dateString = [self.birthdayTextField.text convertDateWithInitialFormat:@"MM/dd/yyyy" ToDateWithFormat:@"yyyy-MM-dd"];
    return dateString;
}

#pragma mark - Populating Countries

-(void)populateCountries{
    self.countryArray = [Countries getCountries];
    [self.countryPicker reloadAllComponents];
}

-(void)populateStates{
    if(self.countryArray.count>0){
        self.statesArray = [[States getStatesWithCountryCode:[NSNumber numberWithInt:1]]mutableCopy];
        if(self.statesArray.count==0)
        {
            NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
            [commentadd setValue:@"PA" forKey:@"countryCode"];
            [commentadd setValue:[NSNumber numberWithInteger:39] forKey:@"stateId"];
            [commentadd setValue:@"Pennsylvania" forKey:@"stateName"];
            [self.statesArray addObject:commentadd];
        }
    }else{
        if(self.statesArray.count==0)
        {
            NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
            [commentadd setValue:@"PA" forKey:@"state_code"];
            [commentadd setValue:[NSNumber numberWithInteger:39] forKey:@"state_Id"];
            [commentadd setValue:@"Pennsylvania" forKey:@"stateName"];
            [self.statesArray addObject:commentadd];
        }

    }
     [self.statePicker reloadAllComponents];
}

#pragma mark - Saving User Details To Local DB

-(void)savingRegisteredUserDetailsToLocalDbWithUserId:(NSNumber *)userId{
    User *user = [User getUser];
    NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc] init];
    [userDataDictionary setValue:[self.selectedCountry valueForKey:@"countryId"] forKey:@"country_id"];
    [userDataDictionary setValue:userId forKey:@"user_id"];
    [userDataDictionary setValue:user.password forKey:@"password"];
    [userDataDictionary setValue:self.countryTF.text forKey:@"country_name"];
    [userDataDictionary setValue:self.stateTextField.text forKey:@"stateName"];
    [userDataDictionary setValue:self.birthdayTextField.text forKey:@"dob"];
    [userDataDictionary setValue:self.firstNameTextField.text forKey:@"first_name"];
    [userDataDictionary setValue:self.lastNameTextField.text forKey:@"last_name"];
    [userDataDictionary setValue:[self.selectedGender valueForKey:GenderIdKey] forKey:@"gender"];
    [userDataDictionary setValue:self.mobileTextField.text forKey:@"phone"];
    [userDataDictionary setValue:self.emailTextField.text forKey:@"email"];
    [userDataDictionary setValue:[self.selectedState valueForKey:@"stateId"] forKey:@"state_id"];
    [User saveUserDetails:userDataDictionary];
    
}
-(void)urlType:(NSNumber *)ID{
        WebViewUrls *urls = [WebViewUrls getUrlsWithId:ID];
        WebViewVC *terms = [[WebViewVC alloc]initWithNibName:@"WebViewVC" bundle:nil];
        terms.url = [NSURL URLWithString:urls.url_name];
        terms.title= urls.content_type;
        [self.navigationController pushViewController:terms animated:YES];
    }


-(void)emailConfirm{
    FacebookLoginVC *fbLogin =[[FacebookLoginVC alloc]initWithNibName:@"FacebookLoginVC" bundle:nil];
    UINavigationController *fabLogNav = [[UINavigationController alloc] initWithRootViewController:fbLogin];
    fbLogin.userName=self.emailTextField.text;
    fbLogin.password=self.passwordTextField.text;
    [self presentViewController:fabLogNav animated:YES completion:nil];
}

-(void)HookDelasTap{
    HookedDealsVC *hookdelas =[[HookedDealsVC alloc]initWithNibName:@"HookedDealsVC" bundle:nil];
    UINavigationController *fabLogNav = [[UINavigationController alloc] initWithRootViewController:hookdelas];
    hookdelas.userName=self.emailTextField.text;
    hookdelas.password=self.passwordTextField.text;
    [self presentViewController:fabLogNav animated:YES completion:nil];
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
