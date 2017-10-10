//
//  BaseTableView.m
//  TWExperience
//
//  Created by Jay Krish on 17/05/16.
//  Copyright © 2016 AkulaInternational. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView () 

@end

@implementation BaseTableView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self registerClass: [UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.delegate = self;
    self.dataSource = self;
    self.allowsMultipleSelectionDuringEditing = NO;
}

#pragma mark - Setters

- (void)setDataArray:(NSMutableArray *)dataArray {
    self.tableDataArray = dataArray;
    [self reloadData];
}

#pragma mark - UITableView  Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sectionCount = 1;
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRow = 0;
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 56;
    
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end
