//
//  SendToVC.m
//  DirectoryApp
//
//  Created by Vishnu KM on 15/02/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "User.h"
#import "BusinessUser.h"
#import "SendToVC.h"
#import "SendTableCell.h"
#import "CustomContactView.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <CLToolKit/UIKitExt.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <CLToolKit/ImageCache.h>
#import "UIImageView+WebCache.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface SendToVC ()<UISearchBarDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,SendContactsTableViewCellDelegate,SendContactViewDelegate,UIDocumentInteractionControllerDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,CNContactViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
@property (strong, nonatomic) NSMutableArray *demoArray;
@property (weak, nonatomic) IBOutlet UISearchBar *sendListSearch;
@property (weak, nonatomic) IBOutlet UIView *backSearchView;
@property (weak, nonatomic) CALayer *layerS;
@property (weak, nonatomic) IBOutlet UITableView *sendtableView;
@property (strong, nonatomic) NSMutableArray *contactsDummyArray;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (retain) UIDocumentInteractionController * documentInteractionController;
@property (strong, nonatomic)CustomContactView *customContactView;
@property (strong, nonatomic)UIView *stausBar;
@property (strong, nonatomic)NSMutableArray *alradySendedList;
@property (strong, nonatomic)NSString *contactSelected;

@end

@implementation SendToVC

- (void)initView {
    [super initView];
    [self.loadImageView sd_setImageWithURL:self.itemImageUrl placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached completed:nil];
    [self initialisation];
    if(self.isFromProductDetail){
        [self recommendUsersList];
    }else{
        [self ShareUsersList];
    }
}

-(void)initialisation{
    self.alradySendedList=[[NSMutableArray alloc]init];
    self.title = @"Send to";
    [self showButtonOnLeftWithImageName:@"closeIcon"];
    [self showButtonOnRightWithImageName:@"addContactIcon"];
    UITextField *field = [self.sendListSearch valueForKey:@"_searchField"];
    field.font = [UIFont fontWithName:@"Dosis-Regular" size:17.0];
    
    self.gradientView.hidden = YES;
    self.nameArray = [[NSMutableArray alloc]init];
    self.contactsDummyArray = [[NSMutableArray alloc]init];
    [self fetchContactsandAuthorization];
    self.layerS = self.backSearchView.layer;
    self.backSearchView.layer.cornerRadius =2;
    self.layerS.shadowOffset = CGSizeMake(.5,.5);
    self.layerS.shadowColor = [[UIColor blackColor] CGColor];
    self.layerS.shadowRadius = 2.0f;
    self.layerS.shadowOpacity = 0.40f;
    self.sendListSearch.layer.borderWidth = 1;
    self.sendListSearch.layer.borderColor = [[UIColor whiteColor] CGColor];
    UITextField *txfSearchField = [self.sendListSearch valueForKey:@"_searchField"];
    [txfSearchField setFont:[UIFont systemFontOfSize:15]];
    [txfSearchField setTextColor:[UIColor colorWithRed:0.24 green:0.22 blue:0.29 alpha:0.7]];
}

-(void)viewDidLayoutSubviews{
    self.layerS.shadowPath = [[UIBezierPath bezierPathWithRect:self.layerS.bounds] CGPath];
}


#pragma mark - Button Actions

-(void)backButtonAction:(UIButton *)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonAction:(UIButton *)rightButton{
    ABNewPersonViewController *addContactVC = [[ABNewPersonViewController alloc] init];
    addContactVC.newPersonViewDelegate      = self;
    UINavigationController *navController   = [[UINavigationController alloc] initWithRootViewController:addContactVC];
    [self presentViewController:navController animated:NO completion:nil];
}

-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    if (person != nil) {
        [self.nameArray removeAllObjects];
        [self.contactsDummyArray removeAllObjects];
        [self fetchContactsandAuthorization];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Tap Action

- (IBAction)tapAction:(id)sender {
    self.gradientView.hidden = YES;
    [self.view endEditing:YES];
    
}

#pragma mark - Search bar Button Action

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.gradientView.hidden = YES;
    [self searchContactList];
    [self.sendtableView reloadData];
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""] || [searchText isEqualToString:@"Search"]){
        self.gradientView.hidden = NO;
    }
    else{
        self.gradientView.hidden = YES;
    }
    if([searchText length] != 0) {
        [self searchContactList];
    }
    else{
        self.nameArray = self.contactsDummyArray;
    }
    [self.sendtableView reloadData];
}

#pragma mark - searchlist

-(void)searchContactList{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName contains[cd] %@",self.sendListSearch.text];
    NSArray *searchResults = [[self.contactsDummyArray filteredArrayUsingPredicate:predicate] mutableCopy];
    self.nameArray = [searchResults mutableCopy];
}

#pragma mark - Text field deligates

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.gradientView.hidden = NO;
    return YES;
}

#pragma mark - UITable View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)self.nameArray.count);
    return self.nameArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SendTableCell" owner:self options:nil] lastObject];
    }
   // NSLog(@">>>%@",[self.nameArray objectAtIndex:indexPath.row]);
    cell.contactDetails = [self.nameArray objectAtIndex:indexPath.row];
    cell.delegateCell = self;
    cell.tag = indexPath.row;
    
    if([[[self.nameArray objectAtIndex:indexPath.row] valueForKey:@"EmailAddresses"] count]!=0){
        NSString *emai;
        NSArray *resultsArray ;
        for(int i=0; i<[[[self.nameArray objectAtIndex:indexPath.row] valueForKey:@"EmailAddresses"] count];i++){
            emai=[[[self.nameArray objectAtIndex:indexPath.row] valueForKey:@"EmailAddresses"] objectAtIndex:i];
            NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF.email == %@||SELF.non_app_user_email == %@",emai,emai];
            resultsArray = [self.alradySendedList filteredArrayUsingPredicate: predicate];
            if([resultsArray count]!=0){
                cell.sendButton.layer.borderWidth = 2.0;
                cell.sendButton.layer.borderColor = [UIColor colorWithRed:0.99 green:0.30 blue:0.30 alpha:1.0].CGColor;
                cell.sendButton.userInteractionEnabled=NO;
                [cell.sendButton setTitle: @"SENT" forState: UIControlStateNormal];
                [cell.sendButton setTitleColor:[UIColor colorWithRed:0.99 green:0.30 blue:0.30 alpha:1.0] forState:UIControlStateNormal];
                break;
            }
        }
    }else{
    }
    
    if([[[self.nameArray objectAtIndex:indexPath.row] valueForKey:@"PhoneNumbers"] count]!=0){
        NSString *phoneNo;
        NSArray *resultsArray;
        for(int i=0; i<[[[self.nameArray objectAtIndex:indexPath.row] valueForKey:@"PhoneNumbers"] count];i++){
            phoneNo=[NSString stringWithFormat:@"%@",[[[self.nameArray objectAtIndex:indexPath.row] valueForKey:@"PhoneNumbers"] objectAtIndex:i]];
            phoneNo=[phoneNo stringByReplacingOccurrencesOfString:@"(" withString:@""];
             phoneNo=[phoneNo stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneNo=[phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneNo=[phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo=[phoneNo stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
            NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF.phone == %@||SELF.non_app_user_phone == %@",phoneNo,phoneNo];
            resultsArray = [self.alradySendedList filteredArrayUsingPredicate: predicate];
            if([resultsArray count]!=0){
                cell.sendButton.layer.borderWidth = 2.0;
                cell.sendButton.layer.borderColor = [UIColor colorWithRed:0.99 green:0.30 blue:0.30 alpha:1.0].CGColor;
                cell.sendButton.userInteractionEnabled=NO;
                [cell.sendButton setTitle: @"SENT" forState: UIControlStateNormal];
                [cell.sendButton setTitleColor:[UIColor colorWithRed:0.99 green:0.30 blue:0.30 alpha:1.0] forState:UIControlStateNormal];
                break;
            }
        }
    }else{
        
    }
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Fetch Contacts and Authorization method
-(void)fetchContactsandAuthorization
{
    // Request authorization to Contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES)
        {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey,CNContactEmailAddressesKey];
            //NSString *containerId = store.defaultContainerIdentifier;
            //NSArray * contactContainerArray =  [store containersMatchingPredicate:nil error:nil];
            CNContactFetchRequest * fetchRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
            [store enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                NSString *email;
                UIImage *profileImage;
                    NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]init];
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }else{
                        profileImage = nil;
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            if(![contactNumbersArray containsObject:phone])
                                [contactNumbersArray addObject:phone];
                        }
                    }
                    NSMutableArray *contactEmailsArray = [[NSMutableArray alloc]init];
                    for (CNLabeledValue *label in contact.emailAddresses) {
                        email = label.value;
                        if(![contactEmailsArray containsObject:email])
                            [contactEmailsArray addObject:email];
                    }
                    NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
                    [personDict setObject:fullName forKey:@"fullName"];
                    if(profileImage!=nil)
                        [personDict setObject:profileImage forKey:@"userImage"];
                    [personDict setObject:contactNumbersArray forKey:@"PhoneNumbers"];
                    [personDict setObject:contactEmailsArray forKey:@"EmailAddresses"];
                    if(![self.nameArray containsObject:personDict])
                        [self.nameArray addObject:personDict];
                    self.contactsDummyArray = self.nameArray;
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.sendtableView reloadData];
            });

//            for(CNContainer * container in contactContainerArray) {
//                NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:container.identifier];
//                NSError *error;
//                NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//                if (error)
//                {
//                    NSLog(@"error fetching contacts %@", error);
//                }
//                else
//                {
//                    NSString *phone;
//                    NSString *fullName;
//                    NSString *firstName;
//                    NSString *lastName;
//                    NSString *email;
//                    UIImage *profileImage;
//                    
//                    for (CNContact *contact in cnContacts) {
//                        NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]init];
//                        // copy data to my custom Contacts class.
//                        firstName = contact.givenName;
//                        lastName = contact.familyName;
//                        if (lastName == nil) {
//                            fullName=[NSString stringWithFormat:@"%@",firstName];
//                        }else if (firstName == nil){
//                            fullName=[NSString stringWithFormat:@"%@",lastName];
//                        }
//                        else{
//                            fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
//                        }
//                        UIImage *image = [UIImage imageWithData:contact.imageData];
//                        if (image != nil) {
//                            profileImage = image;
//                        }else{
//                            profileImage = nil;
//                        }
//                        for (CNLabeledValue *label in contact.phoneNumbers) {
//                            phone = [label.value stringValue];
//                            if ([phone length] > 0) {
//                                if(![contactNumbersArray containsObject:phone])
//                                    [contactNumbersArray addObject:phone];
//                            }
//                        }
//                        NSMutableArray *contactEmailsArray = [[NSMutableArray alloc]init];
//                        for (CNLabeledValue *label in contact.emailAddresses) {
//                            email = label.value;
//                            if(![contactEmailsArray containsObject:email])
//                                [contactEmailsArray addObject:email];
//                        }
//                        NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
//                        [personDict setObject:fullName forKey:@"fullName"];
//                        if(profileImage!=nil)
//                            [personDict setObject:profileImage forKey:@"userImage"];
//                        [personDict setObject:contactNumbersArray forKey:@"PhoneNumbers"];
//                        [personDict setObject:contactEmailsArray forKey:@"EmailAddresses"];
//                        if(![self.nameArray containsObject:personDict])
//                            [self.nameArray addObject:personDict];
//                        self.contactsDummyArray = self.nameArray;
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.sendtableView reloadData];
//                    });
//                }
//            }
        }
        else{
            [self addingAlertControllerForContactPermission];
        }
    }];
}

#pragma mark - UserDefined Delegate Method

- (void)sendContactsTableViewCellItem:(SendTableCell *)cell buttonClickWithIndex:(NSInteger)index{
    [self.view endEditing:YES];
    self.demoArray = [[NSMutableArray alloc]init];
    [self.demoArray addObjectsFromArray:[[self.nameArray objectAtIndex:index] valueForKey:@"PhoneNumbers"]];
    [self.demoArray addObjectsFromArray:[[self.nameArray objectAtIndex:index] valueForKey:@"EmailAddresses"]];
    NSArray *phoneArray = [[self.nameArray objectAtIndex:index] valueForKey:@"PhoneNumbers"];
    NSArray *mailArray = [[self.nameArray objectAtIndex:index] valueForKey:@"EmailAddresses"];
    if(self.demoArray.count > 1){
        self.customContactView = [[[NSBundle mainBundle]loadNibNamed:@"CustomContactView" owner:self options:nil]objectAtIndex:0];
        self.customContactView.storeContacts = self.demoArray;
        self.customContactView.delegateButton = self;
        self.customContactView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        [self.view addSubview:self.customContactView];
        
    }else{
        if((phoneArray.count == 0) && (mailArray.count == 0)){
            [self ShowAlert:@"No Contact informations."];
        }else if(phoneArray.count == 0){
            if(self.isFromProductDetail){
                [self recommendBusinessApi:[mailArray objectAtIndex:0]];
            }else{
                [self shareCouponApi:[mailArray objectAtIndex:0]];
                
            }
            
            //            [self addingMailComposerWithToRecipientsArray:[mailArray objectAtIndex:0]];
        }else if (mailArray.count == 0){
            NSString *phNo;
            if (phoneArray.count!=0) {
                phNo =[NSString stringWithFormat:@"%@",[phoneArray objectAtIndex:0]];
            }
            if(self.isFromProductDetail){
                [self recommendBusinessApi:[phoneArray objectAtIndex:0]];
            }else{
                [self shareCouponApi:[phoneArray objectAtIndex:0]];
            }
            //[self ShowSecondAlert:@"Do you really want to send it through MMS?" :phNo];
        }else{
            
        }
    }
    
}
-(void)sendContactViewValidation:(CustomContactView *)button{
    [self ShowAlert:@"Please select atleast one contact information"];
}

-(void)sendContactViewItem:(CustomContactView *)button buttonClickWithIndex:(NSString *)index{
    NSString *phNo =[NSString stringWithFormat:@"%@",index];
    if([index containsString:@"@"] ){
        //        [self addingMailComposerWithToRecipientsArray:index];
        
        if(self.isFromProductDetail){
            [self recommendBusinessApi:index];
        }else{
             [self shareCouponApi:index];
        }
        
    }
    else{
        if(self.isFromProductDetail){
           [self recommendBusinessApi:phNo];
        }else{
             [self shareCouponApi:phNo];
        }
        //        [self ShowSecondAlert:@"Do you really want to send it through MMS?" :phNo];
    }
}

#pragma mark - Adding Mail Composer

-(void)addingMailComposerWithToRecipientsArray:(NSString *)toRecipientsArray{
    NSString *custumMessage;
    if (self.isFromProductDetail){
        custumMessage=[NSString stringWithFormat:@"I would like to recommend %@ to you.",[self.bussinessDetails valueForKey:@"business_name"]];
    }else{
        custumMessage=[NSString stringWithFormat:@"I would like to share a %@ with you.",@"coupon"];
    }
    
    NSString *text= [NSString stringWithFormat:@"%s   %@","https://itunes.apple.com/us/app/glu/id1208348908?mt=8",custumMessage];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Invitaion"];
        NSMutableString *body = [NSMutableString string];
        // add HTML before the link here with line breaks (\n)
        [body appendString:@"<h3>Hi,</h3>\n"];
        [body appendString:@"<div></div>\n"];
        [body appendString:text];
        [mail setToRecipients:[NSArray arrayWithObject:toRecipientsArray]];
        [mail setMessageBody:body isHTML:YES];
        NSData *exportData = UIImageJPEGRepresentation(self.loadImageView.image ,1.0);
        if(exportData !=nil)
            [mail addAttachmentData:exportData mimeType:@"image/jpeg" fileName:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mail animated:YES completion:NULL];
        });
        
    }
}

#pragma mark - MailComposer delegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSMutableDictionary *contactDict = [[NSMutableDictionary alloc]init];
    if([self.contactSelected containsString:@"@"] ){
        [contactDict setValue:self.contactSelected forKey:@"email"];
    }else{
        [contactDict setValue:self.contactSelected forKey:@"phone"];
    }
    [self.alradySendedList addObject:contactDict];
    [self.sendtableView reloadData];
    NSString *alertMessage = @"";
    switch (result) {
        case MFMailComposeResultSent:
            alertMessage = @"Email send successfully";
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultFailed:
            alertMessage = @"Mail failed:  An error occurred when trying to compose this email";
            break;
        default:
            alertMessage = @"An error occurred when trying to compose this email";
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self ShowAlert:alertMessage];
        [self.customContactView removeFromSuperview];
    }];
}

#pragma mark - Showing Alert Controller

-(void)ShowAlert:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        if ([alertMessage isEqualToString:@"Email send successfully"] && (self.isFromProductDetail)) {
            //[self recommendBusinessApi];
        }
    }];
    [alert addAction:firstAction];
    if(![alertMessage isEqualToString:@""]){
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)ShowSecondAlert:(NSString*)alertMessage : (NSString*)phoneNo{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//        
//    }];
//    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *custumMessage;
        if (self.isFromProductDetail){
            custumMessage=[NSString stringWithFormat:@"Hey, I would like to recommend %@ to you.",[self.bussinessDetails valueForKey:@"business_name"]];
        }else{
            custumMessage=[NSString stringWithFormat:@"Hey, I would like to share a %@ with you.",@"coupon"];
        }
        
        NSString *text= [NSString stringWithFormat:@"%s   %@","https://itunes.apple.com/us/app/glu/id1208348908?mt=8",custumMessage];
        [self addingMessageComposerWithMessageBody:text :phoneNo];
//    }];
//    
//    [alert addAction:firstAction];
//    [alert addAction:secondAction];
//    [self presentViewController:alert animated:YES completion:nil];
}


-(void)addingAlertControllerForContactPermission{
    UIAlertController *contactAlertCntlr = [UIAlertController alertControllerWithTitle:AppName message:contactListDisabledMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dontAllowAction = [UIAlertAction actionWithTitle:@"Don't Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Utilities standardUtilities]goingToSettingsPage];
    }];
    [contactAlertCntlr addAction:dontAllowAction];
    [contactAlertCntlr addAction:yesAction];
    [self presentViewController:contactAlertCntlr animated:YES completion:nil];
}


-(void)addingMessageComposerWithMessageBody:(NSString *)messageBody :(NSString*)Number{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        NSData *data = UIImagePNGRepresentation(self.loadImageView.image);
        controller.body = messageBody;
        controller.recipients = [NSArray arrayWithObjects:Number, nil];
        controller.messageComposeDelegate = self;
        [controller addAttachmentData:data typeIdentifier:@"public.data"filename:@"image.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:controller animated:YES completion:nil];
        });
        
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSMutableDictionary *contactDict = [[NSMutableDictionary alloc]init];
    if([self.contactSelected containsString:@"@"] ){
        [contactDict setValue:self.contactSelected forKey:@"email"];
    }else{
        [contactDict setValue:self.contactSelected forKey:@"phone"];
    }
    [self.alradySendedList addObject:contactDict];
    [self.sendtableView reloadData];
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            
            break;
        case MessageComposeResultSent:
        {
            if (self.isFromProductDetail){
                // [self recommendBusinessApi];
            }
            
        }
            
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:controller completion:^{
        [self.customContactView removeFromSuperview];
        
    }];
}

#pragma mark - Recommend Business Api call

-(void)recommendBusinessApi:(NSString*)contact{
    if([contact containsString:@"@"] ){
    }else{
        contact=[contact stringByReplacingOccurrencesOfString:@"(" withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@")" withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@"-" withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@" " withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [User getUser];
    NSNumber *userId = [NSNumber numberWithLong:user.user_id];
    NSString *dataString = [NSString stringWithFormat:@"recommended_by=%@&recommend_to_phone_or_email=%@&business_id=%@",userId,contact,self.bussinessId];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPERECOMMENDBUSINESS withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:dataString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if(![[responseObject valueForKey:@"data"]isEqual:[NSNull null]]){
        NSString *data;
        if([[[responseObject valueForKey:@"data"]valueForKey:@"unknown_phones_or_email"] count]!=0){
            data=[[[responseObject valueForKey:@"data"]valueForKey:@"unknown_phones_or_email"] objectAtIndex:0];
            if([data containsString:@"@"] ){
                [self addingMailComposerWithToRecipientsArray:data];
            }else{
                [self ShowSecondAlert:@"Do you really want to send it through MMS?" :data];
            }
        }else{
            NSLog(@">>>>>>sucess");
            NSMutableDictionary *contactDict = [[NSMutableDictionary alloc]init];
            if([contact containsString:@"@"] ){
                [contactDict setValue:contact forKey:@"email"];
            }else{
                [contactDict setValue:contact forKey:@"phone"];
            }
            [self.alradySendedList addObject:contactDict];
            [self.sendtableView reloadData];
        }
            self.contactSelected=contact;
        }
         [self.customContactView removeFromSuperview];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Recommend Business Api call

-(void)recommendUsersList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [User getUser];
    NSNumber *userId = [NSNumber numberWithLong:user.user_id];
    NSString *dataString = [NSString stringWithFormat:@"business_id=%@&user_id=%@",self.bussinessId,userId] ;
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPEGETRECOMENTUSERSLIST withURLParameter:dataString];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if(![[responseObject valueForKey:@"data"]isEqual:[NSNull null]]){
        NSArray *responsArray = [responseObject valueForKey:@"data"];
        [self.alradySendedList addObjectsFromArray:responsArray];
        [self.sendtableView reloadData];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Share Business Api call

-(void)ShareUsersList{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [User getUser];
    NSNumber *userId = [NSNumber numberWithLong:user.user_id];
    NSString *dataString = [NSString stringWithFormat:@"coupon_id=%@&user_id=%@",[self.myOffersArray valueForKey:@"id"],userId] ;
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESHAREUSERSLIST withURLParameter:dataString];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:nil withMethodType:HTTPMethodGET withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if(![[responseObject valueForKey:@"data"]isEqual:[NSNull null]]){
        NSArray *responsArray = [responseObject valueForKey:@"data"];
        [self.alradySendedList addObjectsFromArray:responsArray];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.sendtableView reloadData];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)shareCouponApi:(NSString*)contact{
    if([contact containsString:@"@"] ){
    }else{
        contact=[contact stringByReplacingOccurrencesOfString:@"(" withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@")" withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@"-" withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@" " withString:@""];
        contact=[contact stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User *user = [User getUser];
    NSNumber *userId = [NSNumber numberWithLong:user.user_id];
    NSString *dataString = [NSString stringWithFormat:@"coupon_id=%@&shared_by=%@&shared_to_phone_or_email=%@",[self.myOffersArray valueForKey:@"id"],userId,contact];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    NSURL *url = [[UrlGenerator sharedHandler] urlForRequestType:EGLUEURLTYPESHARECOUPON withURLParameter:nil];
    NetworkHandler *networkHandler = [[NetworkHandler alloc]initWithRequestUrl:url withBody:dataString withMethodType:HTTPMethodPOST withHeaderFeild:nil];
    [networkHandler startServieRequestWithSucessBlockSuccessBlock:^(id responseObject, int statusCode){
        if(![[responseObject valueForKey:@"data"]isEqual:[NSNull null]]){
            NSString *data;
            if([[[responseObject valueForKey:@"data"]valueForKey:@"unknown_phones_or_emails"] count]!=0){
                data=[[[responseObject valueForKey:@"data"]valueForKey:@"unknown_phones_or_emails"] objectAtIndex:0];
                if([data containsString:@"@"] ){
                    [self addingMailComposerWithToRecipientsArray:data];
                }else{
                    [self ShowSecondAlert:@"Do you really want to send it through MMS?" :data];
                }
            }else{
                NSLog(@">>>>>>sucess");
                NSMutableDictionary *contactDict = [[NSMutableDictionary alloc]init];
                if([contact containsString:@"@"] ){
                    [contactDict setValue:contact forKey:@"email"];
                }else{
                    [contactDict setValue:contact forKey:@"phone"];
                }
                [self.alradySendedList addObject:contactDict];
                [self.sendtableView reloadData];
            }
            self.contactSelected=contact;
        }
        [self.customContactView removeFromSuperview];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } FailureBlock:^(NSError *error, int statusCode, id errorResponseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}



#pragma mark - Showing Alert Controller

-(void)ShowAlertMessage:(NSString*)alertMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:firstAction];
    if(![alertMessage isEqualToString:@""])
        [self presentViewController:alert animated:YES completion:nil];
}

@end
