//
//  ContactsViewController.m
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactViewController.h"
#import "ZATableViewCell.h"
#import "ZACollectionViewCell.h"
#import "ContactPicker.h"
#import "ContactEntity.h"

@interface ContactViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic) NSMutableArray *selectedItems;
@property (nonatomic) NSArray *contactList;
@property (nonatomic) NSArray *searchedContactList;
@property (nonatomic) NSDictionary *contactSection;
@property (nonatomic) NSArray *allCategories;
@property (nonatomic) BOOL isSearching;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self constraintData];
    
    [[ContactPicker sharedInstance] getAllContactsWithSection:^(NSDictionary *contacts, NSError *error) {
        if (error) {
            NSLog(@"Error:%@", error.description);
        } else {
            self.contactSection = contacts;
            self.allCategories = [[contacts allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            [self.tableView reloadData];
            NSMutableArray *contactList = [[NSMutableArray alloc] init];
            for (NSString *key in self.allCategories) {
                NSArray *listContact = [contacts objectForKey:key];
                for (ContactEntity *contact in listContact) {
                    [contactList addObject:contact];
                }
            }
            self.contactList = contactList;
        }
    }];
}

- (void)initData {
    _selectedItems = [[NSMutableArray alloc] init];
    _isSearching = NO;
}

- (void)constraintData {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ZATableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ZACollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_isSearching) {
        return [_contactSection count];
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!_isSearching) {
        NSString *key = [self.allCategories objectAtIndex:section];
        return key;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_isSearching) {
        NSString *key = [self.allCategories objectAtIndex:section];
        NSUInteger count = [[_contactSection objectForKey:key] count];
        return count;
    } else {
        return [_searchedContactList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    ContactEntity *contact = [self contactAtIndexPath:indexPath];
    cell.title.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    cell.avatarLabel.text = [contact.contactList objectForKey:@"avatar"];
    [cell setAvatarColorWithTitle:cell.avatarLabel.text];
    if (contact.isAvailableImage) {
        [[ContactPicker sharedInstance] getThumbnailImageWithIdentifier:contact.identifier completion:^(UIImage *thumbnailImage, NSError *error) {
            [cell setThumbnailWithImage:thumbnailImage];
        }];
    } else {
        [cell setThumbnailWithImage:nil];
    }
    if (contact.checked) {
        cell.tickBox.image = [UIImage imageNamed:@"ic-tick"];
    } else {
        cell.tickBox.image = [UIImage imageNamed:@"ic-none"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactEntity *contact = [self contactAtIndexPath:indexPath];
    if (contact.checked) { // Uncheck
        ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.tickBox.image = [UIImage imageNamed:@"ic-none"];
        NSUInteger index = [_selectedItems indexOfObject:contact];
        [self.collectionView performBatchUpdates:^{
            [self.selectedItems removeObjectAtIndex:index];
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        } completion:nil];
        if ([_selectedItems count] <= 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.hidden = YES;
            }];
        }
        contact.checked = !contact.checked;
    } else { // Check
        if ([_selectedItems count] >= 5) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Không được chọn quá 5 người" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.tickBox.image = [UIImage imageNamed:@"ic-tick"];
            [_selectedItems addObject:contact];
            NSIndexPath *lastIndex = [NSIndexPath indexPathForItem:[_selectedItems count]-1 inSection:0];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:@[lastIndex]];
            } completion:^(BOOL finished) {
                if (finished) {
                }
            }];
            contact.checked = !contact.checked;
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.hidden = NO;
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


# pragma mark - UICollectionViewDelegate, UICollectibViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_selectedItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    ContactEntity *contact = [_selectedItems objectAtIndex:indexPath.row];
    cell.avatarLabel.text = [contact.contactList objectForKey:@"avatar"];
    [cell setAvatarColorWithTitle:cell.avatarLabel.text];
    if (contact.isAvailableImage) {
        [[ContactPicker sharedInstance] getThumbnailImageWithIdentifier:contact.identifier completion:^(UIImage *thumbnailImage, NSError *error) {
            [cell setThumbnailWithImage:thumbnailImage];
        }];
    } else {
        [cell setThumbnailWithImage:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _isSearching = NO;
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    [self.tableView reloadData];
    ContactEntity *contact = [_selectedItems objectAtIndex:indexPath.row];
    NSIndexPath *index = [self indexPathForSelectedContact:contact];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


# pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _isSearching = NO;
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        _isSearching = NO;
        [self.tableView reloadData];
    } else {
        _isSearching = YES;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@ OR SELF.lastName contains[c] %@", searchText, searchText];
        _searchedContactList = [_contactList filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
}


/// Done and Cancel

- (void)cancelSelection {
    for (ContactEntity *contact in self.selectedItems) {
        contact.checked = NO;
    }
    [self.selectedItems removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneSelection {
    _isSearching = NO;
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    [self.tableView reloadData];
}


/// Utils

- (ContactEntity *)contactAtIndexPath:(NSIndexPath *)indexPath {
    ContactEntity *result;
    if (!_isSearching) {
        NSString *key = [self.allCategories objectAtIndex:indexPath.section];
        NSArray *contacts = [_contactSection objectForKey:key];
        result = [contacts objectAtIndex:indexPath.row];
    } else {
        result = [_searchedContactList objectAtIndex:indexPath.row];
    }
    return result;
}

- (NSIndexPath *)indexPathForSelectedContact:(ContactEntity *)contact {
    NSInteger section, row;
    if (!_isSearching) {
        NSString *key;
        if (contact.firstName == nil || [contact.firstName isEqualToString:@""]) {
            key = @"";
        } else {
            key = [[contact.firstName substringToIndex:1] uppercaseString];
        }
        section = [_allCategories indexOfObject:key];
        row = [[_contactSection objectForKey:key] indexOfObject:contact];
    } else {
        row = [_contactList indexOfObject:contact];
        section = 0;
    }
    NSIndexPath *result = [NSIndexPath indexPathForRow:row inSection:section];
    return result;
}

@end
