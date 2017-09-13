
//  BusinessRegisterVC.m
//  DirectoryApp
//
//  Created by Bibin Mathew on 2/16/17.
//  Copyright © 2017 Codelynks. All rights reserved.
#import "WebViewVC.h"
#import "WebViewUrls.h"
#import "BusinessUser.h"
#import "BusinessRegisterVC.h"
#import "UploadBusinessImageVC.h"
#import <CLToolKit/NSString+Extension.h>

#import "States.h"
#import "Countries.h"
#import "Utilities.h"
@import GooglePlacePicker;

@interface BusinessRegisterVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,EditBusinessProfileVCDelegate>
{
    GMSPlacePicker *_placePicker;
    GMSPlacesClient *_placesClient;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *businessNameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *stateTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkbuttonHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *passwordTFView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UIPickerView *countryPickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *countryDoneToolBar;
@property (weak, nonatomic) IBOutlet UIView *confirmPassView;
@property (nonatomic, strong) States *state;
@property (nonatomic, strong) NSMutableArray *countryArray;
@property (nonatomic, strong) NSMutableArray *stateArray;
@property (nonatomic, strong) NSMutableDictionary *businessProfileDetails;
@property (strong, nonatomic) IBOutlet UIPickerView *statePickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *stateDoneToolBar;
@property (strong, nonatomic) IBOutlet UIToolbar *mobDoneToolBar;
@property (nonatomic, strong) id selctedCountry;
@property (nonatomic, strong) id selectedState;

@property (weak, nonatomic) IBOutlet UITextField *streetTxt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordHeight;
@property (nonatomic, assign) CLLocationCoordinate2D currentPlace;
@property (nonatomic, assign) CLLocationCoordinate2D selectedLocation;

@end

@implementation BusinessRegisterVC

-(void)initView{
    [super initView];
    [self initialisation];
    [self gettingCurrentplace];
    if(self.isFromBusinessEditProfile){
        self.title = @"Edit Business Profile";
        [self.createButton setTitle:@"Update" forState:UIControlStateNormal];
        [self populateBusinessDetails];
    }
    [[Utilities standardUtilities]webViewContentApi];
    [self populateStates];
}

#pragma mark - Initialisation

-(void)initialisation{
    self.countryArray=[[NSMutableArray alloc]init];
    self.stateArray=[[NSMutableArray alloc]init];
    self.streetTxt.delegate=self;
    self.scrollView.delegate=self;
    self.title = @"Create Business Account";
    [self showButtonOnLeftWithImageName:@""];
    [self initialisingTermsAndConditionsLabel];
    [[Utilities standardUtilities]addGradientLayerTo:self.createButton];
    self.businessProfileDetails = [[NSMutableDictionary alloc]init];
    self.countryTF.inputView = self.countryPickerView;
    self.countryTF.inputAccessoryView = self.countryDoneToolBar;
    self.stateTF.inputView = self.statePickerView;
    self.stateTF.inputAccessoryView = self.stateDoneToolBar;
    self.phoneTF.inputAccessoryView = self.mobDoneToolBar;
    NSArray *countriesArray = [Countries getCountries];
    if(countriesArray.count == 0){
        [[Utilities standardUtilities] getCountriesApiSuccessResponse:^(id repsonseObject) {
            [self populateCountries];
        } andFailureResponse:^(id errorResponse, int statusCode) {
             [self populateCountries];
        }];
    }
    else
        [self populateCountries];
}

-(void)populateBusinessDetails{
    BusinessUser *busUser = [BusinessUser getBusinessUser];
    [[Utilities standardUtilities] getStatesApiWithCountryid:busUser.country_id SuccessResponse:^(id responseObject) {
        self.state = [States getStatesWithStateId:[NSNumber numberWithLong:busUser.state_id]];
        [self populateState];
    } andFailureresponse:^(id errorRespnse, int statusCode) {
        
    }];
    self.firstNameTF.text = busUser.firstName;
    self.firstNameTF.userInteractionEnabled = NO;
    self.lastNameTF.text = busUser.lastName;
    self.lastNameTF.userInteractionEnabled = NO;
    self.businessNameTF.text = busUser.businessName;
    self.zipCodeTF.text = busUser.zipCode;
    self.cityTF.text = busUser.city;
    self.addressTF.text = busUser.address;
    self.countryTF.text = busUser.countryName;
    self.countryTF.userInteractionEnabled = NO;
    self.phoneTF.text = busUser.phone;
    self.emailTF.text = busUser.email;
    self.streetTxt.text = busUser.street;
    self.stateTF.text = busUser.stateName;
    self.stateTF.userInteractionEnabled = NO;
    self.emailTF.userInteractionEnabled = NO;
    self.checkbuttonHeightConstraint.constant = 0;
    self.agreeLabelHeightConstraint.constant = 0;
    self.passwordTFView.hidden = YES;
    self.confirmPassView.hidden = YES;
    self.agreeLabel.hidden=YES;
    
}

-(void)populateState{
//    self.stateTF.text = self.state.stateName;
//    self.stateTF.userInteractionEnabled = NO;
}

-(void)initialisingTermsAndConditionsLabel{
    UIColor *normalColor = [UIColor colorWithRed:0.24 green:0.22 blue:0.29 alpha:1.0];
    UIColor *highlightColor = AppCommonBlueColor;
    UIFont *normalFont = [UIFont fontWithName:@"Dosis-Regular" size:14.0];
    UIFont *highlightedFont = [UIFont fontWithName:@"Dosis-Bold" size:14.0];
    NSDictionary *normalAttributes = @{NSFontAttributeName:normalFont, NSForegroundColorAttributeName:normalColor};
    NSDictionary *highlightAttributes = @{NSFontAttributeName:highlightedFont, NSForegroundColorAttributeName:highlightColor};
    NSAttributedString *normalText;
    if(IS_IPHONE_6_OrLater)
        normalText = [[NSAttributedString alloc] initWithString:@"I am the owner or authorized to manage this\nbusiness and I agreed to the " attributes:normalAttributes];
    else
        normalText = [[NSAttributedString alloc] initWithString:@"I am the owner or authorized to manage this business and I agreed to the " attributes:normalAttributes];
    NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"terms and conditions" attributes:highlightAttributes];
    
    NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:normalText];
    [finalAttributedString appendAttributedString:highlightedText];
    self.agreeLabel.attributedText = finalAttributedString;
}

#pragma mark - Validation

-(BOOL)isvalidInput{
    BOOL isvalid = NO;
    if ([self.firstNameTF.text empty]){
        [self ShowAlert:@"Please enter your first name"];
    }else if ([self.lastNameTF.text empty]){
        [self ShowAlert:@"Please enter your last name"];
    }else if ([self.businessNameTF.text empty]){
        [self ShowAlert:@"Please enter your business name"];
    }else if ([self.addressTF.text empty]){
        [self ShowAlert:@"Please enter your address"];
    }else if ([self.zipCodeTF.text empty]){
        [self ShowAlert:@"Please enter a zip code"];
    }else if ([self.cityTF.text empty]){
        [self ShowAlert:@"Please enter your city"];
    }else if ([self.stateTF.text empty]){
        [self ShowAlert:@"Please enter your state"];
    }else if ([self.phoneTF.text length] < 10){
        self.phoneTF.text = @"";
        [self ShowAlert:@"Please enter a valid mobile number"];
    }else if ([self.streetTxt.text empty]){
        [self ShowAlert:@"Please enter a street"];
    }else if ([self.emailTF.text empty]){
        [self ShowAlert:@"Please enter an email address"];
    }else if (![self.emailTF.text validEmail]){
        self.emailTF.text = @"";
        [self ShowAlert:@"Please enter a valid email address"];
    }else if ([self.pwdTF.text length] < 8){
        [self ShowAlert:@"Your password should be 8 digits"];
    }else if (![self.confirmPassword.text isEqualToString:self.pwdTF.text]){
        [self ShowAlert:@"Password and Confirm password should be same"];
    }else if((!self.checkButton.isSelected)){
        [self ShowAlert:@"Need to accept our terms and Condition"];
    }
    else {
        isvalid = YES;
    }
    return isvalid;
}


-(BOOL)isvalidEditProfile{
    BOOL isvalid = NO;
    if ([self.firstNameTF.text empty]){
        [self ShowAlert:@"Please enter your first name"];
    }else if ([self.lastNameTF.text empty]){
        [self ShowAlert:@"Please enter your last name"];
    }else if ([self.businessNameTF.text empty]){
        [self ShowAlert:@"Please enter your business name"];
    }else if ([self.addressTF.text empty]){
        [self ShowAlert:@"Please enter your address"];
    }else if ([self.zipCodeTF.text empty]){
        [self ShowAlert:@"Please enter a zip code"];
    }else if ([self.cityTF.text empty]){
        [self ShowAlert:@"Please enter your city"];
    }else if ([self.stateTF.text empty]){
        [self ShowAlert:@"Please enter your state"];
    }else if ([self.phoneTF.text length] < 10){
        self.phoneTF.text = @"";
        [self ShowAlert:@"Please enter a valid mobile number"];
    }else if ([self.streetTxt.text empty]){
        [self ShowAlert:@"Please enter a street"];
    }else {
        isvalid = YES;
    }
    return isvalid;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat value=0;
    if(IS_IPHONE_5){
        value=30;
    }
    [UIView animateWithDuration:.3 animations:^{
        if (textField == self.firstNameTF) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } else if (textField == self.lastNameTF) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }else if (textField == self.businessNameTF) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if (textField == self.addressTF){
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if (textField == self.countryTF){
            self.scrollView.contentOffset = CGPointMake(0, value);
        }
        else if (textField == self.zipCodeTF){
            self.scrollView.contentOffset = CGPointMake(0, value+20);
        }
        else if (textField == self.cityTF){
            self.scrollView.contentOffset = CGPointMake(0, value+20);
        }
        else if (textField == self.stateTF){
            self.scrollView.contentOffset = CGPointMake(0, value+125);
        }
        else if (textField == self.phoneTF){
            self.scrollView.contentOffset = CGPointMake(0, value+150);
        }
        else if (textField == self.streetTxt){
            self.scrollView.contentOffset = CGPointMake(0, value+215);
        }
        else if (textField == self.emailTF){
            self.scrollView.contentOffset = CGPointMake(0, value+250);
        }
        else if (textField == self.pwdTF){
            self.scrollView.contentOffset = CGPointMake(0, value+300);
        }
        else if (textField == self.confirmPassword){
            self.scrollView.contentOffset = CGPointMake(0, value+350);
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.phoneTF) {
        NSString *newString = [self.phoneTF.text stringByReplacingCharactersInRange:range withString:string];
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
    if(textField == self.firstNameTF)
        [self.lastNameTF becomeFirstResponder];
    else if (textField == self.lastNameTF)
        [self.businessNameTF becomeFirstResponder];
    else if (textField == self.businessNameTF){
    }
    else if (textField == self.addressTF)
        [self.countryTF becomeFirstResponder];
    else if (textField == self.zipCodeTF)
        [self.cityTF becomeFirstResponder];
    else if (textField == self.cityTF)
        [self.stateTF becomeFirstResponder];
    else if (textField == self.stateTF){
        [self.phoneTF becomeFirstResponder];
    }else if (textField == self.streetTxt){
        [self.emailTF becomeFirstResponder];
    }else if (textField == self.emailTF){
        [self.pwdTF becomeFirstResponder];
    }else if (textField == self.pwdTF){
        [self.confirmPassword becomeFirstResponder];
    }
    else if (textField == self.pwdTF){
        [UIView animateWithDuration:.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }
    return YES;
}

#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    if(self.isFromBusinessEditProfile){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)checkBoxAction:(UIButton *)sender {
    if(![sender isSelected]){
        sender.selected = YES;
    }
    else{
        sender.selected = NO;
    }
}

- (IBAction)createBusinessAccountAction:(UIButton *)sender {
   
    if(self.isFromBusinessEditProfile){
          [self showingUploadImage];
    }
    else{
        if ([self isvalidInput]){
             [self emailCheckApi];
        }
    }
}

-(void)urlType:(NSNumber *)ID{
    WebViewUrls *urls = [WebViewUrls getUrlsWithId:ID];
    WebViewVC *terms = [[WebViewVC alloc]initWithNibName:@"WebViewVC" bundle:nil];
    terms.url = [NSURL URLWithString:urls.url_name];
    terms.title= urls.content_type;
    [self.navigationController pushViewController:terms animated:YES];
}

#pragma mark - Showing UploadImagesVC

-(void)showingUploadImage{
    UploadBusinessImageVC *uploadBusinessImageVC = [[UploadBusinessImageVC alloc]initWithNibName:@"UploadBusinessImageVC" bundle:nil];
    uploadBusinessImageVC.editProfileDelegate=self;
    if(self.isFromBusinessEditProfile){
        uploadBusinessImageVC.businessRegistrationDetails=[self UpdateProfileDetailsDict];
        uploadBusinessImageVC.isFromBusinessEdit=YES;
    }else{
        uploadBusinessImageVC.businessRegistrationDetails=[self RegistationDetailsDict];
    }
    [self.navigationController pushViewController:uploadBusinessImageVC animated:YES];
}
-(void)UpdateButtonActionDelegate{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(NSMutableDictionary*)RegistationDetailsDict{
    NSMutableDictionary *businessDictionary = [[NSMutableDictionary alloc] init];
    [businessDictionary setValue:self.firstNameTF.text forKey:@"firstName"];
    [businessDictionary setValue:self.lastNameTF.text forKey:@"lastName"];
    [businessDictionary setValue:self.businessNameTF.text forKey:@"businessName"];
    [businessDictionary setValue:self.addressTF.text forKey:@"address"];
    [businessDictionary setValue:[self.selctedCountry valueForKey:@"countryId"] forKey:@"country_id"];
    [businessDictionary setValue:self.countryTF.text forKey:@"countryName"];
    [businessDictionary setValue:self.zipCodeTF.text forKey:@"zip"];
    [businessDictionary setValue:self.cityTF.text forKey:@"city"];
    [businessDictionary setValue:[self.selectedState valueForKey:@"stateId"] forKey:@"state_id"];
    [businessDictionary setValue:self.stateTF.text forKey:@"stateName"];
    [businessDictionary setValue:self.phoneTF.text forKey:@"phone"];
    [businessDictionary setValue:self.emailTF.text forKey:@"email"];
    [businessDictionary setValue:self.pwdTF.text forKey:@"password"];
    [businessDictionary setValue:self.streetTxt.text forKey:@"street"];
    [businessDictionary setValue:[NSNumber numberWithDouble:self.selectedLocation.latitude] forKey:@"latitude"];
    [businessDictionary setValue:[NSNumber numberWithDouble:self.selectedLocation.longitude] forKey:@"longitude"];
    return businessDictionary;
}

-(NSMutableDictionary*)UpdateProfileDetailsDict{
    NSMutableDictionary *businessDictionary = [[NSMutableDictionary alloc] init];
    [businessDictionary setValue:self.firstNameTF.text forKey:@"firstName"];
    [businessDictionary setValue:self.lastNameTF.text forKey:@"lastName"];
    [businessDictionary setValue:self.businessNameTF.text forKey:@"businessName"];
    [businessDictionary setValue:self.addressTF.text forKey:@"address"];
    [businessDictionary setValue:self.countryTF.text forKey:@"countryName"];
    [businessDictionary setValue:self.zipCodeTF.text forKey:@"zip"];
    [businessDictionary setValue:self.cityTF.text forKey:@"city"];
    [businessDictionary setValue:self.stateTF.text forKey:@"stateName"];
    [businessDictionary setValue:self.phoneTF.text forKey:@"phone"];
    [businessDictionary setValue:self.emailTF.text forKey:@"email"];
    [businessDictionary setValue:self.streetTxt.text forKey:@"street"];
    [businessDictionary setValue:[NSNumber numberWithDouble:self.selectedLocation.latitude] forKey:@"latitude"];
    [businessDictionary setValue:[NSNumber numberWithDouble:self.selectedLocation.longitude] forKey:@"longitude"];
    return businessDictionary;
}

- (IBAction)countryDoneButtonAction:(UIBarButtonItem *)sender {
    if(self.selctedCountry == nil){
        if(self.countryArray.count>0){
            self.selctedCountry = [self.countryArray firstObject];
        }
    }
    if(self.selctedCountry!=nil){
        self.countryTF.text = [self.selctedCountry valueForKey:@"countryName"];
        int countryId = [[self.selctedCountry valueForKey:@"countryId"] intValue];
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
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.zipCodeTF becomeFirstResponder];
    }];
}

- (IBAction)addressButtonAction:(UIButton *)sender {
    [self loadingMapview];
    
}
- (IBAction)mobDoneButtonAction:(UIBarButtonItem *)sender {
    if(self.isFromBusinessEditProfile) {
        [self.view endEditing:YES];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
        [self.streetTxt becomeFirstResponder];
    }
}

-(void)gettingCurrentplace{
    _placesClient = [GMSPlacesClient sharedClient];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            return;
        }
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.currentPlace = place.coordinate;
            }
        }
    }];
}

-(void)loadingMapview{
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.currentPlace.latitude,self.currentPlace.longitude);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            return;
        }
        
        if (place != nil) {
            
            self.addressTF.text = place.name;
            self.selectedLocation = place.coordinate;
        [self placeNameWithCoordinated];
        } else {
            
        }
    }];
}
#pragma mark - Cordinates to Place Name Converstion

-(void)placeNameWithCoordinated{
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.selectedLocation.latitude longitude:self.selectedLocation.longitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      if([placemark.administrativeArea isEqualToString:@"PA"]){
                      NSString *zip=[NSString stringWithFormat:@"%@",placemark.postalCode];
                      NSString *city=[NSString stringWithFormat:@"%@",placemark.locality];
                      NSString *street=[NSString stringWithFormat:@"%@",placemark.subLocality];
                      ([zip isEqualToString:@"(null)"])?(self.zipCodeTF.text=@""):(self.zipCodeTF.text=zip);
                      ([city isEqualToString:@"(null)"])?(self.cityTF.text=@""):(self.cityTF.text=city);
                      ([street isEqualToString:@"(null)"])?(self.streetTxt.text=@""):(self.streetTxt.text=street);
                      [self AutoFillCountry:placemark.country :placemark.administrativeArea];
                      }else{
                          [self ShowAlert:@"Please select a location in 'Pennsylvania'"];
                          self.addressTF.text=@"";
                      }
                      [MBProgressHUD hideHUDForView:self.view  animated:YES];
                  }else {
                      [self ShowAlert:@"Could not locate the area you give, Please fill the details manually"];
                      [MBProgressHUD hideHUDForView:self.view  animated:YES];
                  }
              }];
}

-(void)AutoFillCountry: (NSString*)country :(NSString*)state{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.countryName contains[c] %@",country];
    NSArray *results = [self.countryArray filteredArrayUsingPredicate:predicate];
    if(results.count !=0){
        self.selctedCountry = [results firstObject];
        self.countryTF.text = [self.selctedCountry valueForKey:@"countryName"];
        [self getStatesApiWithCountryid:[[self.selctedCountry valueForKey:@"countryId"]intValue ] :state];
            }
}

#pragma mark - GetCountries Api call

-(void)getStatesApiWithCountryid:(int)countryId :(NSString*)state{
    state=@"Pennsylvania";
    NSString *urlParameter = [NSString stringWithFormat:@"%d",countryId];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETSTATES withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [States saveStatesDetails:[responseObject valueForKey:@"data"] withCountry:urlParameter]
        ;
        self.stateArray = [[States getStatesWithCountryCode:[self.selctedCountry valueForKey:@"countryId"]] mutableCopy];
        if(self.stateArray.count==0)
        {
            NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
            [commentadd setValue:@"PA" forKey:@"countryCode"];
            [commentadd setValue:[NSNumber numberWithInteger:39] forKey:@"stateId"];
            [commentadd setValue:@"Pennsylvania" forKey:@"stateName"];
            [self.stateArray insertObject:commentadd atIndex:0];
        }
        [self.statePickerView reloadAllComponents];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.stateName contains[c] %@",state];
        NSArray *results = [self.stateArray filteredArrayUsingPredicate:predicate];
        if(results.count !=0){
            self.selectedState = [results firstObject];
            self.stateTF.text = [self.selectedState valueForKey:@"stateName"];
        }else{
            self.stateTF.text=@"";
        }

    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
    }];
}

#pragma mark - emailCheckApi Api call

-(void)emailCheckApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlParameter = [NSString stringWithFormat:@"email=%@",self.emailTF.text];
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
    NSString *urlParameter = [NSString stringWithFormat:@"phone=%@",self.phoneTF.text];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEPHONECHECK withURLParameter:urlParameter];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if([[[responseObject valueForKey:@"data"]valueForKey:@"isExist"]isEqual:[NSNumber numberWithInt:0]]){
            if(self.isFromBusinessEditProfile){
                [self showingUploadImage];
            }
            else{
                if ([self isvalidInput]){
                    [self showingUploadImage];
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


-(void)populateCountries{
    [self.countryArray addObjectsFromArray:[Countries getCountries]];
    if(self.countryArray.count==0){
        NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
        [commentadd setValue:@"US" forKey:@"countryCode"];
        [commentadd setValue:[NSNumber numberWithInteger:1] forKey:@"countryId"];
        [commentadd setValue:@"United States Of America" forKey:@"countryName"];
        [self.countryArray insertObject:commentadd atIndex:0];
    }
    [self.countryPickerView reloadAllComponents];
}

-(void)populateStates{
    if(self.countryArray.count>0){
        [self.stateArray addObjectsFromArray:[States getStatesWithCountryCode:[self.selctedCountry valueForKey:@"countryId"]]];
        if(self.stateArray.count==0)
        {
            NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
            [commentadd setValue:@"PA" forKey:@"countryCode"];
            [commentadd setValue:[NSNumber numberWithInteger:39] forKey:@"stateId"];
            [commentadd setValue:@"Pennsylvania" forKey:@"stateName"];
            [self.stateArray insertObject:commentadd atIndex:0];
        }
    }else{
        if(self.stateArray.count==0)
        {
            NSMutableDictionary *commentadd = [[NSMutableDictionary alloc]init];
            [commentadd setValue:@"PA" forKey:@"countryCode"];
            [commentadd setValue:[NSNumber numberWithInteger:39] forKey:@"stateId"];
            [commentadd setValue:@"Pennsylvania" forKey:@"stateName"];
            [self.stateArray insertObject:commentadd atIndex:0];
            
        }
        [self.statePickerView reloadAllComponents];
    }
    
}
- (IBAction)stateDoneButtonAction:(UIBarButtonItem *)sender {
    if(self.selectedState == nil){
        if(self.stateArray.count>0){
            self.selectedState = [self.stateArray firstObject];
        }
    }
    if(self.selectedState!=nil){
        self.stateTF.text = [self.selectedState valueForKey:@"stateName"];
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self.phoneTF becomeFirstResponder];
    }];
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

#pragma mark - Tap Geature Actions

- (IBAction)viewTapGestureAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (IBAction)termsAndConditionsGestureAction:(UITapGestureRecognizer *)sender {
   [self urlType:[NSNumber numberWithInt:2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Picker DataSources

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.countryPickerView)
        return [self.countryArray count];
    else if (pickerView == self.statePickerView)
        return [self.stateArray count];
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {;
    if(pickerView == self.countryPickerView)
        return [[self.countryArray objectAtIndex:row] valueForKey:@"countryName"];
    else if(pickerView == self.statePickerView)
        return [[self.stateArray objectAtIndex:row] valueForKey:@"stateName"];
    else
        return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.countryPickerView){
        self.selctedCountry = [self.countryArray objectAtIndex:row];
        self.selectedState = nil;
        self.stateTF.text = @"";
    }
    else if (pickerView == self.statePickerView)
        self.selectedState = [self.stateArray objectAtIndex:row];
}

#pragma mark - Showing Alert Controller



@end
