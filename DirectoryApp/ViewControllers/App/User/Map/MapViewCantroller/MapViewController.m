//
//  MapViewController.m
//  DirectoryApp
//
//  Created by Hari R Krishna on 2/16/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//
#import "States.h"
#import "Constants.h"
#import "Countries.h"
#import "UserRegisterVC.h"
#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "NetworkHandler.h"
#import "UrlGenerator.h"
#import "MapCategoryTableCell.h"
#import "LoginViewController.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ProductDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MapInfoWindow.h"
#import "CategoryList.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import <CLToolKit/UIKitExt.h>

@interface MapViewController () <CLLocationManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,SelectedCategoryHomeTableCellDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture1;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture2;
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;
@property (weak, nonatomic) CALayer *layers;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *myLocationButton;
@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSString *subPlace;
@property (strong, nonatomic) NSString *selectedCategoryId;
@property (strong, nonatomic) NSString *bussinessLogoImage;
@property (strong, nonatomic) NSString *categoryType;
@property (strong, nonatomic)NSString *distanceToSearch;
@property (strong, nonatomic)NSString *nameToSearch;
@property (strong, nonatomic)NSMutableArray *currentBussiness;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *dummycategoryArray;
@property (strong, nonatomic) id selectedCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableWidthConstraint;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UIToolbar *searchToolBar;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfeild;
@property (strong, nonatomic) IBOutlet UIToolbar *categoryToolBar;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *pickerTextField;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *apppleMapView;
@property (weak, nonatomic)MapInfoWindow *MarkerView;
@property (nonatomic) CLLocationDegrees  myLatitude;
@property (nonatomic) CLLocationDegrees  myLongitude;
@property (nonatomic) CLLocationDegrees  userLatitude;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic) CLLocationDegrees  userLongitude;
@property (nonatomic) BOOL isCalledDetails;
@property (nonatomic) BOOL isFromMyLocationAction;
@end

@implementation MapViewController

#pragma mark - View LifeCycle

- (void)initView {
    [super initView];
    [self Custumisation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews{
    self.layers.shadowPath = [[UIBezierPath bezierPathWithRect:self.layers.bounds] CGPath];
}

#pragma mark - View Custumisation

-(void)Custumisation{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self getCategoryListApi];
    [self IntializingMap];
    self.nameToSearch=@"";
    self.categoryType=@"";
    self.tableWidthConstraint.constant = self.searchTextfeild.width - (self.searchTextfeild.width/4);
    self.tapGesture1.delegate = self;
    self.tapGesture2.delegate = self;
    self.categoryTable.hidden = YES;
    self.searchTextfeild.delegate=self;
    self.pickerTextField.delegate=self;
    self.categoryPicker.delegate=self;
    self.gradientView.hidden = YES;
    self.layers = self.searchView.layer;
    self.layers.shadowOffset = CGSizeMake(.5,.5);
    self.layers.shadowColor = [[UIColor blackColor] CGColor];
    self.layers.shadowRadius = 2.0f;
    self.layers.shadowOpacity = 0.40f;
    self.searchView.layer.cornerRadius =2;
    self.self.pickerTextField.inputView=self.categoryPicker;
    self.pickerTextField.inputAccessoryView=self.categoryToolBar;
    self.pickerTextField.tintColor=[UIColor clearColor];
    if(_isFromBussinessUser){
        [self.menuButton setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.categoryTable]) {
        return NO;
    }
    return YES;
}
- (BOOL)isLocationServiceEnabled {
    return ([CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied);
}
#pragma mark - View Actions

- (IBAction)searchDropDownAction:(id)sender {
    self.gradientView.hidden = NO;
    self.categoryTable.hidden =NO;
    self.checkTag = -1;
    [self.categoryTable reloadData];
}

- (IBAction)ViewTapAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)gradientViewTapAction:(id)sender {
    self.gradientView.hidden = YES;
    [self.view endEditing:YES];
    self.searchTextfeild.text=@"";
    self.nameToSearch=@"";
    self.myLocationButton.userInteractionEnabled=NO;
    self.isCalledDetails=NO;
    [self LocationFetch];
}

- (IBAction)SeachDoneAction:(id)sender {
    [self.view endEditing:YES];
    self.nameToSearch=self.searchTextfeild.text;
    self.myLocationButton.userInteractionEnabled=NO;
    self.isCalledDetails=NO;
    [self LocationFetch];
}

- (IBAction)CategoryDoneAction:(id)sender {
    if(self.selectedCategory == nil) {
        self.selectedCategory = [self.categoryArray firstObject];
        self.categoryType=[NSString stringWithFormat:@"%@",[self.selectedCategory valueForKey:@"categoryID"]];
        self.searchTextfeild.text = [self.selectedCategory valueForKey:@"categoryName"];
    }
    self.searchTextfeild.text = [self.selectedCategory valueForKey:@"categoryName"];
    self.categoryType=[NSString stringWithFormat:@"%@",[self.selectedCategory valueForKey:@"categoryID"]];
    [self.pickerTextField resignFirstResponder];
    self.gradientView.hidden = YES;
    self.isCalledDetails=NO;
    [self LocationFetch];
}

- (IBAction)SearchButtonViewAction:(id)sender {
    [self.view endEditing:YES];
    self.gradientView.hidden = YES;
    self.isCalledDetails=NO;
    [self LocationFetch];
}


- (IBAction)MenuButtonAction:(id)sender {
    if(!self.isFromBussinessUser){
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:isLoggedIn];
    if(isLogIn){
        [self resetTopView];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self addLogInVC];
    }}else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)ProductTapAction:(id)sender {
}

- (IBAction)MyLocationButton:(id)sender {
    if([self isLocationServiceEnabled]){
        [self ShowAlertForLocationPermission:@"Glu would like to access your location to provide you better service. \n\n Do you want to enable Location service?"];
    }else{
        self.myLocationButton.userInteractionEnabled=NO;
        self.isCalledDetails=NO;
        self.isFromMyLocationAction=YES;
        self.myLatitude=self.userLatitude;
        self.myLongitude=self.userLongitude;
        [self GetMyBussinesses];
    }
}

#pragma mark - Category Picker Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.categoryArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.categoryArray objectAtIndex:row]valueForKey:@"categoryName"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedCategory = [self.categoryArray objectAtIndex:row];
    
}

#pragma mark - Resetting TopView

- (void)resetTopView {
    ECSlidingViewController *slidingViewController = self.slidingViewController;
    UIView *topGradientView;
    if (slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        UIViewController *topViewController = slidingViewController.topViewController;
        UIView *view = [[topViewController.view subviews] lastObject];
        if(view.tag == 101)
            [view removeFromSuperview];
        [slidingViewController resetTopViewAnimated:YES];
    } else {
        topGradientView= [[UIView alloc] init];
        topGradientView.tag = 101;
        topGradientView.backgroundColor = [UIColor clearColor];
        topGradientView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [topGradientView addGestureRecognizer:tapGesture];
        UIViewController *topViewController = slidingViewController.topViewController;
        [topViewController.view addSubview:topGradientView];
        [slidingViewController anchorTopViewToRightAnimated:YES];
    }
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tapGesture{
    ECSlidingViewController *slidingViewController = self.slidingViewController;
    UIViewController *topViewController = slidingViewController.topViewController;
    [[[topViewController.view subviews] lastObject] removeFromSuperview];
    [slidingViewController resetTopViewAnimated:YES];
}

#pragma mark - Text Feild Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.gradientView.hidden = NO;
}

#pragma mark - Text Feild Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchTextfeild) {
        [self.searchTextfeild resignFirstResponder];
        self.myLocationButton.userInteractionEnabled=NO;
        self.isCalledDetails=NO;
        [self LocationFetch];
        self.nameToSearch=self.searchTextfeild.text;
        self.gradientView.hidden = YES;
    }
    return YES;
}

#pragma mark - UITable View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categoryArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapCategoryTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MapCategoryTableCell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MapCategoryTableCell" owner:self options:nil] lastObject];
    }
    cell.categoryName.text = [[self.categoryArray objectAtIndex:indexPath.row] valueForKey:@"categoryName"];
    cell.tag = indexPath.row;
    cell.delegateSelectionCell = self;
    NSInteger storedValued = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rowValue"]integerValue];
    if(storedValued!=-1){
        if(self.checkTag == indexPath.row ||indexPath.row == storedValued){
            cell.selectionButton.selected = YES;
        }else{
            cell.selectionButton.selected = NO;
        }
    }else{
        cell.selectionButton.selected = NO;
    }
    return cell;
}

#pragma mark - User Defined Delegate Methods

- (void)selectedCategoryHomeTableCellItem:(MapCategoryTableCell *)cell buttonClickWithIndex:(NSInteger)index withstatus :(BOOL)status{
    self.checkTag = index;
    self.selectedCategoryId = [NSString stringWithFormat:@"%@",[[self.categoryArray objectAtIndex:index] valueForKey:@"categoryID"]];
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedCategoryId forKey:@"categoryId"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:index] forKey:@"rowValue"];
    if(!status){
        self.checkTag = -1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:-1] forKey:@"rowValue"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"categoryId"];
    }
    [self.categoryTable reloadData];
}

#pragma mark - Map Initialization

- (void)IntializingMap{
    [self LocationFetch];
    self.apppleMapView.delegate = self;
}

#pragma mark - Fetching Current Location

-(void)LocationFetch{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - Location Manager Deligates

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.userLatitude=newLocation.coordinate.latitude;
    self.userLongitude=newLocation.coordinate.longitude;
    if (!self.isCalledDetails) {
        self.myLatitude=self.userLatitude;
        self.myLongitude=self.userLongitude;
        self.isCalledDetails=YES;
        [self.apppleMapView removeAnnotations:self.apppleMapView.annotations];
        [self UpdateMap];
        [self GetMyBussinesses];
    }
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Cordinates to Place Name Converstion

-(void)placeNameWithCoordinated{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.userLatitude longitude:self.userLongitude];
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      if([placemark.administrativeArea isEqualToString:@"PA"]){
                      }else{
                          [self ShowAlert:@"Glu services are not available in your area. Please check back later."];
                      }
                      [MBProgressHUD hideHUDForView:self.view  animated:YES];
                  }else {
                  }
              }];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    MKAnnotationView *test=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"reuse"];
    MKPointAnnotation * anotation = test.annotation;
    if(![anotation isKindOfClass:[MKUserLocation class]] && ![anotation.title isEqualToString:@"My Location"] && annotation != mapView.userLocation) {
        MapInfoWindow *MarkerView =  [[[NSBundle mainBundle] loadNibNamed:@"MapInfoWindow" owner:self options:nil] objectAtIndex:0];
        test.image=[UIImage imageNamed:@"mapTouch"];
        MarkerView .frame=CGRectMake(test.frame.origin.x+55, test.frame.origin.y+35, test.frame.size.width-24, test.frame.size.height-10);
        NSString *imageUrl = anotation.title;
        MarkerView.ImageUrl=imageUrl;
        [test addSubview:MarkerView];
        MarkerView.layer.shadowColor=[[UIColor lightGrayColor]colorWithAlphaComponent:.8].CGColor;
        MarkerView.layer.shadowOffset= CGSizeMake(0, 1);
        MarkerView.layer.shadowOpacity=1;
        MarkerView.layer.shadowRadius= 1.0;
        MarkerView.layer.cornerRadius= 5.0;
        MarkerView.clipsToBounds= NO;
        MarkerView.userInteractionEnabled=YES;
        [test setUserInteractionEnabled:YES];
        [test setCanShowCallout:YES];
    }else{
        return nil;
    }
    return test;
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    [mapView deselectAnnotation:view.annotation animated:YES];
    MKPointAnnotation * anotation = view.annotation;
    if(![anotation isKindOfClass:[MKUserLocation class]] && ![anotation.title isEqualToString:@"My Location"]) {
//    if(![anotation.title isEqualToString:@"My Location"]){
        NSArray* splitArray = [anotation.title componentsSeparatedByString: @"/"];
        NSString* finalString;
        if(splitArray.count!=0){
            NSString* firstBit = [splitArray objectAtIndex: splitArray.count-1];
            NSArray* finalArray = [firstBit componentsSeparatedByString: @"."];
            if(finalArray.count!=0){
                finalString = [finalArray objectAtIndex: 0];
            }
        }
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:finalString];
        if(myNumber!=nil){
            NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF.business_id == %@",myNumber];
            NSArray *resultsArray = [self.currentBussiness filteredArrayUsingPredicate: predicate];
            if([resultsArray count]!=0){
                if(!self.isFromBussinessUser){
                ProductDetailViewController *signUpVC = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
                UINavigationController *vc= [[UINavigationController alloc] initWithRootViewController:signUpVC];
                signUpVC.bussinessDetails=[resultsArray objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:vc animated:YES completion:nil];
                });
                }
            }
        }else{
            NSLog(@">>>>Image Url Parsing issue");
        }
    }else{
        
    }
}

#pragma mark - Plot values on map

-(void)markOnMap{
    [self.apppleMapView removeAnnotations:self.apppleMapView.annotations];
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.0;
    if([self.currentBussiness count]!=0){
        for (int i = 0; i<self.currentBussiness.count; i++) {
            id data = [self.currentBussiness objectAtIndex:i];
            latitude=[[data valueForKey:@"latitude"]doubleValue];
            longitude=[[data valueForKey:@"longitude"]doubleValue];
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coord];
            NSString *imageUrl = [NSString stringWithFormat:@"%@""%@.jpg?%@",@"http://admin.glucommunity.com/BizDirectoryApp/uploads/BusinessLogos/",[data valueForKey:@"business_id"],[data valueForKey:@"business_image_cache"]];
            annotation.title=imageUrl;
            [self.apppleMapView addAnnotation:annotation];
            
        }}
}

#pragma mark - RefreshMap

-(void)UpdateMap{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.myLatitude, self.myLongitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 600,0);
    [self.apppleMapView setRegion:[self.apppleMapView regionThatFits:region] animated:YES];
    
}

#pragma mark - Get MyBussinesses Api call

-(void)GetMyBussinesses {
    self.distanceToSearch=@"20";
    NSString *category=[[NSUserDefaults standardUserDefaults] valueForKey:@"categoryId"];
    if([category length]==0){
        category=@"";
    }
    NSString *request=[NSString stringWithFormat:@"keyword=%@&latitude=%f&longitude=%f&maxDistance=%@&rating=%@&categoryId=%@&subcategoryId=%@",self.nameToSearch,self.myLatitude,self.myLongitude,self.distanceToSearch,@"",category,@""];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEBUSINESEARCH withURLParameter:request];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        self.currentBussiness=[responseObject valueForKey:@"data"];
        if(![[responseObject valueForKey:@"data"]isEqual:[NSNull null]]){
            if([self.currentBussiness count]!=0){
                if(!self.isFromMyLocationAction){
                    self.myLatitude=[[[self.currentBussiness objectAtIndex:0]valueForKey:@"latitude"] doubleValue];
                    self.myLongitude=[[[self.currentBussiness objectAtIndex:0]valueForKey:@"longitude"] doubleValue];
                }else{
                    self.isFromMyLocationAction=NO;
                    self.myLocationButton.userInteractionEnabled=YES;
                }
                [self UpdateMap];
            }
            [self markOnMap];
        }else{
            [self.apppleMapView removeAnnotations:self.apppleMapView.annotations];
            self.myLatitude=self.userLatitude;
            self.myLongitude=self.userLongitude;
            [self UpdateMap];
            [self placeNameWithCoordinated];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.myLocationButton.userInteractionEnabled=YES;
        self.isCalledDetails=YES;
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.myLocationButton.userInteractionEnabled=YES;
        self.isCalledDetails=YES;
    }];
}

#pragma mark - Get Category List Api call

-(void)getCategoryListApi {
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETCATEGORYLIST withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        [CategoryList saveCategoryListDetails:[responseObject valueForKey:@"data"]];
        self.categoryArray =[CategoryList getCategoryList];
        self.dummycategoryArray=self.categoryArray;
        [self.categoryTable reloadData];
        [self.categoryPicker reloadAllComponents];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        
    }];
}

#pragma mark - Alerts & Loading controllers

-(void)addingAlertControllerForLogInOrRegister{
    UIAlertController *logInAlertController = [UIAlertController alertControllerWithTitle:AppName message:@"You have to register/login to use this feature of the application" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *logInAction = [UIAlertAction actionWithTitle:@"Log In" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addLogInVC];
    }];
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"Register" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addLogInVC];
    }];
    [logInAlertController addAction:logInAction];
    [logInAlertController addAction:registerAction];
    [self presentViewController:logInAlertController animated:YES completion:nil];
}

-(void)addLogInVC{
    LoginViewController *logInVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:logInVC animated:YES completion:nil];
    });
}

-(void)addRegisterVC{
    UserRegisterVC *userRegisterVC = [[UserRegisterVC alloc] initWithNibName:@"UserRegisterVC" bundle:nil];
    UINavigationController *registerNavCntrlr = [[UINavigationController alloc] initWithRootViewController:userRegisterVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:registerNavCntrlr animated:YES completion:nil];
    });
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

-(void)ShowAlertForLocationPermission:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
        if (canOpenSettings)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *SecondAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    [alert addAction:SecondAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}

@end
