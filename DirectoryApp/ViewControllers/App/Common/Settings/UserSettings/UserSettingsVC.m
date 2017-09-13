//
//  UserSettingsVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 23/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//


#import "WebViewVC.h"
#import "Constants.h"
#import "WebViewUrls.h"
#import "BusinessUser.h"
#import "CategoryList.h"
#import "SubCategories.h"
#import "ResetPasswordVC.h"
#import "UserSettingsVC.h"
#import "UserRegisterVC.h"
#import "BusinessRegisterVC.h"
#import "SettingsTableCell.h"
#import "CLToolKit/CLDateHandler.h"
#import "User.h"

#define YOUR_APP_STORE_ID 310633997

@interface UserSettingsVC ()<UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource    >
    @property (nonatomic,strong)NSString * opening;
    @property (nonatomic,strong)NSString * subCategoryName;
    @property (nonatomic,strong)NSString * closing;
    @property (strong, nonatomic)BusinessUser *busUser;
    @property (strong, nonatomic)CategoryList *catList;
    @property (strong, nonatomic)NSArray *subCtList;
    @property (strong, nonatomic) NSArray *categoryArray;
    @property (strong, nonatomic) NSArray *subcategoryArray;
    @property (strong, nonatomic) NSMutableArray *generalArray;
    @property (strong, nonatomic) id selectedCategory;
    @property (strong, nonatomic) id selectedCategoryID;
    @property (strong, nonatomic) id selectedSubCategory;
    @property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
    @property (strong, nonatomic) IBOutlet UIPickerView *subCategoryPicker;
    @property (strong, nonatomic) IBOutlet UIDatePicker *openingTimePicker;
    @property (strong, nonatomic) IBOutlet UIToolbar *categoryToolbar;
    @property (strong, nonatomic) IBOutlet UIToolbar *subCategoryToolbar;
    @property (strong, nonatomic) IBOutlet UIDatePicker *closingTimePicker;
    @property (strong, nonatomic) IBOutlet UIToolbar *openingTimeToolbar;
    @property (strong, nonatomic) IBOutlet UIToolbar *closingTimeToolbar;
    @property (weak, nonatomic) IBOutlet UITableView *settingsTableview;
    @property (strong, nonatomic) NSMutableArray *accountArray;
    @end

@implementation UserSettingsVC
    
- (void)initView {
    [super initView];
    [self initialisation];
    if(!(self.isUserSettings)){
        [self getCategoryListApi];
        [self getSubCategoryListApi];
        [self showButtonOnRightWithImageName:@"whiteTickIcon"];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [self.settingsTableview reloadData];
    [self populateCategoryList];
}
    
-(void)initialisation{
    self.title = @"Settings";
    [self showButtonOnLeftWithImageName:@""];
    self.busUser =[BusinessUser getBusinessUser];
    [[Utilities standardUtilities]webViewContentApi];
    
    self.categoryPicker.delegate = self;
    self.subCategoryPicker.delegate = self;
    self.openingTimePicker.datePickerMode = UIDatePickerModeTime;
    self.closingTimePicker.datePickerMode = UIDatePickerModeTime;
    NSDictionary *cell1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Edit Profile",@"account", @"editIcon",@"accountImage",nil];
    NSDictionary *cell2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Change Password",@"account", @"passwordIcon",@"accountImage",nil];
    NSDictionary *cell3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Business Category",@"account", @"businessCategoryIcon",@"accountImage",nil];
    NSDictionary *cell4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Business Hours",@"account", @"businessHoursIcon",@"accountImage",nil];
    NSDictionary *cell5 = [NSDictionary dictionaryWithObjectsAndKeys:@" ",@"account", @"",@"accountImage",nil];
    //NSDictionary *cell6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Feedback ",@"account", @"feedbackIcon",@"accountImage",nil];
    NSDictionary *cell7 = [NSDictionary dictionaryWithObjectsAndKeys:@"Rate & Review",@"account", @"reviewIcon",@"accountImage",nil];
    //NSDictionary *cell8 = [NSDictionary dictionaryWithObjectsAndKeys:@"FAQ ",@"account", @"faqIcon",@"accountImage",nil];
    NSDictionary *cell9 = [NSDictionary dictionaryWithObjectsAndKeys:@"Terms & Conditions",@"account", @"t&cIcon",@"accountImage",nil];
    NSDictionary *cell10 = [NSDictionary dictionaryWithObjectsAndKeys:@"Log out",@"account", @"logoutIcon",@"accountImage",nil];
    NSDictionary *cell11 = [NSDictionary dictionaryWithObjectsAndKeys:@" ",@"account", @"",@"accountImage",nil];
    BOOL isFbLogin = [[NSUserDefaults standardUserDefaults] boolForKey:isFacebookLogIn];
    if(isFbLogin)
    self.generalArray = [NSMutableArray arrayWithObjects:cell5,cell1,cell11,cell7,cell9,cell10,nil];
    else
    self.generalArray = [NSMutableArray arrayWithObjects:cell5,cell1,cell2,cell11,cell7,cell9,cell10,nil];
    self.accountArray = [NSMutableArray arrayWithObjects:cell5,cell1,cell2,cell3,cell4,cell11,cell7,cell9,cell10,nil];
    
}
    
    
#pragma mark - UITable View DataSource
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isUserSettings)
    return self.generalArray.count;
    else
    return self.accountArray.count;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isUserSettings){
        if((indexPath.row == 0) || (indexPath.row == 3)){
            return 35;
        }
        else
        return 55;
    }
    else{
        if((indexPath.row == 0) || (indexPath.row == 5)){
            return 35;
        }
        else if((indexPath.row == 3) || (indexPath.row == 4))
        return 70;
        else
        return 55;
    }
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingsTableCell" owner:self options:nil] lastObject];
    }
    cell.openingTime.hidden = YES;
    cell.closingTime.hidden = YES;
    cell.closingLabel.hidden = YES;
    cell.openingLabel.hidden = YES;
    cell.toAddPickerView.hidden = YES;
    cell.toAddSubCategoryPicker.hidden = YES;
    cell.categoryName.hidden = YES;
    cell.categorySubItem.hidden = YES;
    cell.downArrowButton.hidden = YES;
    cell.sectionHeader.hidden = YES;
    cell.openingTimeText.hidden = YES;
    cell.closingTimeText.hidden = YES;
    BOOL isFbLogin = [[NSUserDefaults standardUserDefaults] boolForKey:isFacebookLogIn];
    if(self.isUserSettings){
        if(isFbLogin){
            if(indexPath.row == 0){
                cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0];
                cell.sectionHeader.hidden = NO;
                cell.logoImage.hidden = YES;
                cell.bottomLineView.hidden = YES;
                cell.settingsName.hidden = YES;
                cell.sectionHeader.text = @"Account";
            }
            
            else if(indexPath.row == 2){
                cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0];
                cell.sectionHeader.hidden = NO;
                cell.settingsName.hidden = YES;
                cell.logoImage.hidden = YES;
                cell.sectionHeader.text = @"General";
            }
            else {
                cell.settingsName.text = [NSString stringWithFormat:@"%@",[[self.generalArray objectAtIndex:indexPath.row] valueForKey:@"account"]];
                cell.logoImage.image = [UIImage imageNamed:[[self.generalArray objectAtIndex:indexPath.row]valueForKey:@"accountImage"]];
                return cell;
                
            }
        }
        else{
            if(indexPath.row == 0){
                cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0];
                cell.sectionHeader.hidden = NO;
                cell.logoImage.hidden = YES;
                cell.bottomLineView.hidden = YES;
                cell.settingsName.hidden = YES;
                cell.sectionHeader.text = @"Account";
            }
            
            else if(indexPath.row == 3){
                cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0];
                cell.sectionHeader.hidden = NO;
                cell.settingsName.hidden = YES;
                cell.logoImage.hidden = YES;
                cell.sectionHeader.text = @"General";
            }
            else {
                cell.settingsName.text = [NSString stringWithFormat:@"%@",[[self.generalArray objectAtIndex:indexPath.row] valueForKey:@"account"]];
                cell.logoImage.image = [UIImage imageNamed:[[self.generalArray objectAtIndex:indexPath.row]valueForKey:@"accountImage"]];
                return cell;
                
            }
        }
    }
    else{
        if(indexPath.row == 0){
            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0];
            cell.sectionHeader.hidden = NO;
            cell.logoImage.hidden = YES;
            cell.bottomLineView.hidden = YES;
            cell.settingsName.hidden = YES;
            cell.sectionHeader.text = @"Account";
        }
        else if(indexPath.row == 4){
            cell.openingTime.hidden = NO;
            cell.closingTime.hidden = NO;
            cell.bottomLineView.hidden = YES;
            cell.closingLabel.hidden = NO;
            cell.openingLabel.hidden = NO;
            cell.closingTimeText.hidden = NO;
            cell.openingTimeText.hidden = NO;
            self.opening = [self.busUser.openingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"HH:mm"];
            cell.openingTimeText.text = self.opening;
            self.closing = [self.busUser.closingTime convertDateWithInitialFormat:@"HH:mm:ss" ToDateWithFormat:@"HH:mm"];
            cell.closingTimeText.text = self.closing;
            
            [cell.openingTimeText setInputView:self.openingTimePicker];
            [cell.closingTimeText setInputView:self.closingTimePicker];
            cell.openingTimeText.inputAccessoryView=self.openingTimeToolbar;
            cell.closingTimeText.inputAccessoryView=self.closingTimeToolbar;
            cell.settingsName.text = [NSString stringWithFormat:@"%@",[[self.accountArray objectAtIndex:indexPath.row] valueForKey:@"account"]];
            cell.logoImage.image = [UIImage imageNamed:[[self.accountArray objectAtIndex:indexPath.row]valueForKey:@"accountImage"]];
            return cell;
            
        }
        else if(indexPath.row == 3){
            cell.categoryName.hidden = NO;
            cell.categorySubItem.hidden = NO;
            cell.downArrowButton.hidden = NO;
            cell.toAddSubCategoryPicker.hidden = NO;
            cell.toAddSubCategoryPicker.hidden = NO;
            cell.openingTimeText.inputAccessoryView=self.openingTimeToolbar;
            cell.closingTimeText.inputAccessoryView=self.closingTimeToolbar;
            cell.categorySubItem.text = self.busUser.mainCategoryName;
            NSLog(@"%@",self.busUser.mainCategoryName);
            cell.categoryName.text = self.busUser.subCategoryName;
            cell.settingsName.text = [NSString stringWithFormat:@"%@",[[self.accountArray objectAtIndex:indexPath.row] valueForKey:@"account"]];
            cell.logoImage.image = [UIImage imageNamed:[[self.accountArray objectAtIndex:indexPath.row]valueForKey:@"accountImage"]];
            [cell.toAddPickerView setInputView:self.categoryPicker];
            [cell.toAddSubCategoryPicker setInputView:self.subCategoryPicker];
            cell.toAddPickerView.inputAccessoryView=self.categoryToolbar;
            cell.toAddSubCategoryPicker.inputAccessoryView=self.subCategoryToolbar;
            return cell;
        }
        else if(indexPath.row == 5){
            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.96 alpha:1.0];
            cell.sectionHeader.hidden = NO;
            cell.settingsName.hidden = YES;
            cell.logoImage.hidden = YES;
            
            cell.sectionHeader.text = @"General";
        }
        else {
            cell.settingsName.text = [NSString stringWithFormat:@"%@",[[self.accountArray objectAtIndex:indexPath.row] valueForKey:@"account"]];
            cell.logoImage.image = [UIImage imageNamed:[[self.accountArray objectAtIndex:indexPath.row]valueForKey:@"accountImage"]];
            return cell;
            
        }
        
    }
    return cell;
    
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isUserSettings){
        BOOL isFbLogin = [[NSUserDefaults standardUserDefaults] boolForKey:isFacebookLogIn];
        if(isFbLogin){
            if(indexPath.row == 1){
                [self userEditProfile];
            }
            else if (indexPath.row == 3)
            {
                [self rateApp];
            }
            else if (indexPath.row == 4)
            {
                [self urlType:[NSNumber numberWithInt:2]];
                
            }
            else if(indexPath.row == 5){
                [self addingAlertControllerForLogout];
            }
        }
        else{
            if(indexPath.row == 6){
                [self addingAlertControllerForLogout];
            }
            else if(indexPath.row == 1){
                [self userEditProfile];
            }
            else if (indexPath.row == 2)
            {
                [self resetPassword];
            }
            else if (indexPath.row == 5)
            {
                [self urlType:[NSNumber numberWithInt:2]];
                
            }
            else if (indexPath.row == 4)
            {
                [self rateApp];
            }
        }
        
    }
    else{
        if(indexPath.row == 8){
            [self addingAlertControllerForLogout];
        }
        else if(indexPath.row == 1){
            [self userEditBusinessProfile];
        }
        else if (indexPath.row == 2)
        {
            [self resetPassword];
        }
        else if(indexPath.row == 3)
        {
            SettingsTableCell *cellDetails = [self.settingsTableview cellForRowAtIndexPath:indexPath];
            [cellDetails.toAddPickerView becomeFirstResponder];
        }
        else if (indexPath.row == 7)
        {
            [self urlType:[NSNumber numberWithInt:2]];
            
        }
        else if (indexPath.row == 6)
        {
            [self rateApp];
        }
    }
}
    
    
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
    {
        return 1;
    }
    
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == self.categoryPicker){
        NSLog(@"%lu",(unsigned long)[self.categoryArray count]);
        return [self.categoryArray count];}
    else
    return [self.subcategoryArray count];
}
    
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView == self.categoryPicker){
        NSLog(@"%@",([[self.categoryArray objectAtIndex:row]valueForKey:@"categoryName"]));
        return [[self.categoryArray objectAtIndex:row]valueForKey:@"categoryName"];}
    else
    return [[self.subcategoryArray objectAtIndex:row]valueForKey:@"categoryName"];
}
    
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == self.categoryPicker){
        self.selectedCategory = [self.categoryArray objectAtIndex:row];
        self.selectedSubCategory = nil;
    }
    else
    self.selectedSubCategory = [self.subcategoryArray objectAtIndex:row];
}
    
    
    
#pragma mark - Button Actions
    
- (IBAction)openingToolDoneAction:(id)sender {
    SettingsTableCell *cellDetails = [self.settingsTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    self.opening = [[CLDateHandler standardUtilities] convertDate:self.openingTimePicker.date toFormatedString:@"HH' 'mm'" withTimeZone:[NSTimeZone systemTimeZone]];
    cellDetails.openingTimeText.text = self.opening;
    [self.view endEditing:YES];
    
    
}
- (IBAction)categoryDoneButtonAction:(id)sender {
    SettingsTableCell *cellDetails = [self.settingsTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [cellDetails.toAddSubCategoryPicker becomeFirstResponder];
    cellDetails.categoryName.text = @"";
    if(self.selectedCategory == nil) {
        cellDetails.categorySubItem.text = [[self.categoryArray objectAtIndex:0]valueForKey:@"categoryName"];
        self.selectedCategory = [self.categoryArray objectAtIndex:0];
    }
    else {
        cellDetails.categorySubItem.text = [self.selectedCategory valueForKey:@"categoryName"];
        //self.selectedCategory = [self.selectedCategory valueForKey:@"categoryID"];
        
    }
    [[Utilities standardUtilities] getSubCategoryListApi:[[self.selectedCategory valueForKey:@"categoryID"] intValue] SuccessResponse:^(id responseObject) {
        self.subcategoryArray = [SubCategories getSubCategoryWithParentID:[self.selectedCategory valueForKey:@"categoryID"]];
        [self.subCategoryPicker reloadAllComponents];
    } andFailureresponse:^(id errorRespnse, int statusCode) {
        
    }];
    
    //[self getSubCategoryListApi];
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
    }];
    [self.view endEditing:YES];
    [cellDetails.toAddPickerView resignFirstResponder];
    [cellDetails.toAddSubCategoryPicker becomeFirstResponder];
    
    
}
- (IBAction)openingCancelButtonAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)subCategoryCancelButtonAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)closingCancelButtonAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)categoryCancelButtonAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)subCategoryDoneButtonAction:(id)sender {
    SettingsTableCell *cellDetails = [self.settingsTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if(self.selectedSubCategory==nil){
        if(self.subcategoryArray.count>0){
            self.selectedSubCategory = [self.subcategoryArray firstObject];
        }
    }
    if(self.selectedSubCategory!=nil){
        cellDetails.categoryName.text = @"";
        cellDetails.categoryName.text = [self.selectedSubCategory valueForKey:@"categoryName"];
    }
    [UIView animateWithDuration:.3 animations:^{
        [self.view endEditing:YES];
    }];
    
}
- (IBAction)closingToolDoneAction:(id)sender {
    SettingsTableCell *cellDetails = [self.settingsTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    self.closing = [[CLDateHandler standardUtilities] convertDate:self.closingTimePicker.date toFormatedString:@"HH' 'mm'" withTimeZone:[NSTimeZone systemTimeZone]];
    cellDetails.closingTimeText.text = self.closing;
    [self.view endEditing:YES];
}
    
    
    
-(void)backButtonAction:(UIButton *)backButton{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
-(void)rightButtonAction:(UIButton *)rightButton{
    [self.view endEditing:YES];
    [self callingUpdateBusinessProfileApi];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Adding Alert Controller for Logout
    
-(void)addingAlertControllerForLogout{
    UIAlertController *logoutAlertController = [UIAlertController alertControllerWithTitle:AppName message:@"Do you want to Logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionAfterLogout];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [logoutAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [logoutAlertController addAction:okAction];
    [logoutAlertController addAction:cancelAction];
    [self presentViewController:logoutAlertController animated:YES completion:nil];
}
    
#pragma mark - Perform Action after logout
    
-(void)actionAfterLogout{
    [self DeviceToken:@""];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isLoggedIn];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isBusinessUser];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isNormalUser];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isGuestUser];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isFacebookLogIn];
    [[Utilities standardUtilities]clearAllLocalData];
    [[NSNotificationCenter defaultCenter]postNotificationName:DirectoryShowHome object:nil];
}
    
-(void)rateApp{
    NSString * appId = @"1208348908";
    NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
    if ([[UIDevice currentDevice].systemVersion integerValue] > 6) theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}
    
-(void)resetPassword {
    ResetPasswordVC *resetPassword = [[ResetPasswordVC alloc]initWithNibName:@"ResetPasswordVC" bundle:nil];
    [self.navigationController pushViewController:resetPassword animated:YES];
    
}
    
-(void)urlType:(NSNumber *)ID{
    WebViewUrls *urls = [WebViewUrls getUrlsWithId:ID];
    WebViewVC *terms = [[WebViewVC alloc]initWithNibName:@"WebViewVC" bundle:nil];
    terms.url = [NSURL URLWithString:urls.url_name];
    terms.title= urls.content_type;
    [self.navigationController pushViewController:terms animated:YES];
}
    
-(void)userEditProfile{
    UserRegisterVC *user = [[UserRegisterVC alloc]initWithNibName:@"UserRegisterVC" bundle:nil];
    user.isFromEditProfile = YES;
    [self.navigationController pushViewController:user animated:YES];
}
-(void)userEditBusinessProfile{
    BusinessRegisterVC *bususer = [[BusinessRegisterVC alloc]initWithNibName:@"BusinessRegisterVC" bundle:nil];
    bususer.isFromBusinessEditProfile = YES;
    [self.navigationController pushViewController:bususer animated:YES];
}
    
#pragma mark - Calling Update Business Profile Api
    
-(void)callingUpdateBusinessProfileApi{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSNumber *categoryId;
    NSLog(@"%@",[self.selectedSubCategory valueForKey:@"categoryID"]);
    if([self.selectedSubCategory valueForKey:@"categoryID"]){
        categoryId = [self.selectedSubCategory valueForKey:@"categoryID"];
    }
    else{
        categoryId = [NSNumber numberWithInt:self.busUser.categoryID];
    }
    NSNumber *latitude = [NSNumber numberWithDouble:self.busUser.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:self.busUser.longitude];
    NSString *openingTime = [self.opening convertDateWithInitialFormat:@"HH:mm" ToDateWithFormat:@"HH:mm:ss"];
    NSString *closingTime = [self.closing convertDateWithInitialFormat:@"HH:mm" ToDateWithFormat:@"HH:mm:ss"];
    NSString *updateBusinessProfUrlString = [NSString stringWithFormat:@"business_id=%@&business_name=%@&category_id=%@&business_address=%@&business_email=%@&business_phone=%@&website=%@&latitude=%@&longitude=%@&opening_time=%@&closing_time=%@&street=%@",[NSNumber numberWithLong:self.busUser.business_id],self.busUser.businessName,categoryId,@"sersw",self.busUser.email,self.busUser.phone,self.busUser.email,latitude,longitude,openingTime,closingTime,self.busUser.street];
    NSURL *updateBusinessProfileUrl = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEUPDATEBUSINESSPROFILE withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:updateBusinessProfileUrl withBody:updateBusinessProfUrlString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject valueForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            BusinessUser *busUser = [BusinessUser getBusinessUser];
            busUser.openingTime = openingTime;
            busUser.closingTime = closingTime;
            busUser.mainCategoryId = [[self.selectedCategory valueForKey:@"categoryID"] intValue];
            busUser.subCategoryId = [[self.selectedSubCategory valueForKey:@"categoryID"] intValue];
            busUser.mainCategoryName =[self.selectedCategory valueForKey:@"categoryName"];
            busUser.subCategoryName = [self.selectedSubCategory valueForKey:@"categoryName"];
            [[CLCoreDataAdditions sharedInstance]saveEntity];
            self.catList = [CategoryList getCategoriesWithCategoryId:[NSNumber numberWithInt:self.busUser.categoryID]];
            self.subCtList =[SubCategories getSubCategoryWithParentID:[NSNumber numberWithInt:self.busUser.categoryID]];
            for (SubCategories *sub in self.subCtList) {
                if(sub.categoryID == self.busUser.subCategoryId)
                {
                    self.subCategoryName = sub.categoryName;
                }
            }
        }
        else{
            [[Utilities standardUtilities]showMessageAlertControllerInController:self withAlertMessage:[responseObject valueForKey:@"messageText"]];
        }
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[Utilities standardUtilities]handleApiFailureBlockInController:self withErrorResponse:errorResponseObject andStatusCode:statusCode];
        
    }];
}
    
#pragma mark - Get Category List Api call
    
-(void)getCategoryListApi {
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETCATEGORYLIST withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [CategoryList saveCategoryListDetails:[responseObject valueForKey:@"data"]];
        [self populateCategoryList];
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
    }];
}
    
-(void)populateCategoryList{
    self.categoryArray =[CategoryList getCategoryList];
    [self.categoryPicker reloadAllComponents];
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
    
#pragma mark - DeviceToken Api call
    
-(void)DeviceToken:(NSString*)token {
    User *user=[User getUser];
    NSString *tempString = [NSString stringWithFormat:@"user_id=%d&token=%@",user.user_id,token];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEDEVICEREGISTRATION withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:tempString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
    }];
}
    
#pragma mark - Showing Alert Controller
    
-(void)ShowAlert:(NSString*)alertMessage errorCode:(NSNumber*)code{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if ([code isEqualToNumber:[NSNumber numberWithInt:0]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert addAction:firstAction];
    [self presentViewController:alert animated:YES completion:nil];
}
    
    @end
