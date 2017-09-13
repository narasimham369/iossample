//
//  CustomContactView.m
//  DirectoryApp
//
//  Created by Vishnu KM on 08/03/17.
//  Copyright © 2017 Codelynks. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"
#import "CustomContactView.h"
#import "CustomContactTableCell.h"
@interface CustomContactView()<UITableViewDelegate,UITableViewDataSource,SelectedContactTableViewCellDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewContact;
@property(strong,nonatomic)NSMutableArray *sendContact;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end
@implementation CustomContactView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.tapGesture.delegate = self;
    [[Utilities standardUtilities]addGradientLayerTo:self.sendButton];
     self.customView.layer.cornerRadius = 5;
    self.sendButton.layer.borderWidth = 2.0;
    self.sendButton.layer.borderColor = [[UIColor colorWithRed:0.14 green:0.62 blue:0.91 alpha:1.0] CGColor];
    self.sendButton.layer.cornerRadius = 5;
    self.checkTag = -1;
    self.tableViewContact.delegate = self;
    self.tableViewContact.dataSource = self;
}

#pragma mark - Setter methods

-(void)setStoreContacts:(id)storeContacts{
    self.sendContact = storeContacts;
    [self.tableViewContact reloadData];
    
}

#pragma mark - Button Action

- (IBAction)sendButtonAction:(id)sender {
    
    if(self.checkTag == -1){
        if (self.delegateButton && [self.delegateButton respondsToSelector:@selector(sendContactViewValidation:)]) {
            [self.delegateButton sendContactViewValidation:self];
        }

    }else{
        if (self.delegateButton && [self.delegateButton respondsToSelector:@selector(sendContactViewItem:buttonClickWithIndex:)]) {
            [self.delegateButton sendContactViewItem:self buttonClickWithIndex:[self.sendContact objectAtIndex:self.checkTag]];
        }
    }
}
- (IBAction)tapAction:(id)sender {
    [self removeFromSuperview];
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.customView]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UserDefined  Delegate methods
-(void)selectedContactTableViewCellItem:(CustomContactTableCell *)cell buttonClickWithIndex:(NSInteger)index{
    self.checkTag = index;
    [self.tableViewContact reloadData];
}


#pragma mark - UItable View Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sendContact.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"AVAILABLE CONTACTS";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomContactTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomContactTableCell" owner:self options:nil] lastObject];
    }

    cell.contactDetails.text = [self.sendContact objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.delegateSelectionCell = self;
    if(self.checkTag == indexPath.row){
        cell.selectionButton.selected = YES;
    }
    else{
        cell.selectionButton.selected = NO;
    }
    return cell;
}


@end
