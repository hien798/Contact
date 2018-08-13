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
    
    [[ContactPicker sharedInstance] getAllContactsWithSection:^(NSDictionary *contacts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
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
    self.selectedItems = [[NSMutableArray alloc] init];
    [self setIsSearching:NO];
}

- (void)constraintData {
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.searchBar setDelegate:self];
    [self.tableView registerClass: [ZATableViewCell class] forCellReuseIdentifier: @"tableViewCell"];
    [self.collectionView registerClass: [ZACollectionViewCell class] forCellWithReuseIdentifier: @"collectionViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_isSearching) {
        return [_contactSection count];
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!_isSearching) {
        NSString *key = [self.allCategories objectAtIndex: section];
        return key;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_isSearching) {
        NSString *key = [self.allCategories objectAtIndex: section];
        return [[_contactSection objectForKey: key] count];
    } else {
        return [_searchedContactList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    ContactEntity *contact = [self contactAtIndexPath: indexPath];
    [cell.title setText: [NSString stringWithFormat: @"%@ %@", contact.firstName, contact.lastName]];
    [cell.avatar setText: [contact.contactList objectForKey: @"avatar"]];
    [cell setAvatarColorWithTitle: cell.avatar.text];
    if (contact.isAvailableImage) {
        [[ContactPicker sharedInstance] getThumbnailImageWithIdentifier:contact.identifier completion:^(UIImage *thumbnailImage, NSError *error) {
            [cell setThumbnailWithImage:thumbnailImage];
        }];
    } else {
        [cell setThumbnailWithImage:nil];
    }
    if (contact.checked) {
        [cell.tickBox setImage: [UIImage imageNamed:@"ic-tick"]];
    } else {
        [cell.tickBox setImage: [UIImage imageNamed:@"ic-none"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactEntity *contact = [self contactAtIndexPath:indexPath];
    if (contact.checked) { // Uncheck
        ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.tickBox setImage: [UIImage imageNamed:@"ic-none"]];
        NSUInteger index = [_selectedItems indexOfObject:contact];
        [self.collectionView performBatchUpdates:^{
            [self.selectedItems removeObjectAtIndex:index];
            [self.collectionView deleteItemsAtIndexPaths: @[[NSIndexPath indexPathForItem:index inSection:0]]];
        } completion:nil];
        if ([_selectedItems count] <= 0) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.collectionView setHidden:YES];
            }];
        }
        [contact setChecked: !contact.checked];
    } else { // Check
        if ([_selectedItems count] >= 5) {
            // Out of range
            NSLog(@"Chon qua 5 nguoi");
        } else {
            ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.tickBox setImage: [UIImage imageNamed:@"ic-tick"]];
            [_selectedItems addObject: contact];
            NSIndexPath *lastIndex = [NSIndexPath indexPathForItem: [_selectedItems count]-1 inSection: 0];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths: @[lastIndex]];
            } completion:^(BOOL finished) {
                if (finished) {
                }
            }];
            [contact setChecked: !contact.checked];
            [UIView animateWithDuration:0.3 animations:^{
                [self.collectionView setHidden:NO];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


// UICollectionViewDelegate, UICollectibViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_selectedItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    ContactEntity *contact = [_selectedItems objectAtIndex: indexPath.row];
    [cell.avatar setText: [contact.contactList objectForKey:@"avatar"]];
    [cell setAvatarColorWithTitle: cell.avatar.text];
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
    [self setIsSearching:NO];
    [self.searchBar setText:@""];
    [self.searchBar endEditing:YES];
    [self.tableView reloadData];
    ContactEntity *contact = [_selectedItems objectAtIndex:indexPath.row];
    NSIndexPath *index = [self indexPathForSelectedContact:contact];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


// UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"begin search");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"end search");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self setIsSearching:NO];
    [self.searchBar setText:@""];
    [self.searchBar endEditing:YES];
    [self.tableView reloadData];
    NSLog(@"cancel search");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        // normal searching is NO
        NSLog(@"no searcing");
        [self setIsSearching:NO];
        [self.tableView reloadData];
    } else {
        // searching is YES
        [self setIsSearching:YES];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstName contains[c] %@ OR SELF.lastName contains[c] %@", searchText, searchText];
        _searchedContactList = [_contactList filteredArrayUsingPredicate:predicate];
        NSLog(@"%lu: ", (unsigned long)[_searchedContactList count]);
        for (ContactEntity *contact in _searchedContactList) {
            NSLog(@"%@ %@", contact.firstName, contact.lastName);
        }
        [self.tableView reloadData];
    }
}


// Done and Cancel

- (void)cancelSelection {

    for (ContactEntity *contact in self.selectedItems) {
        [contact setChecked:NO];
    }
    [self.selectedItems removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneSelection {
    NSLog(@"Done");
    [self setIsSearching:NO];
    [self.searchBar setText:@""];
    [self.searchBar endEditing:YES];
    [self.tableView reloadData];
}


// Utils

- (ContactEntity *)contactAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isSearching) {
        NSString *key = [self.allCategories objectAtIndex: indexPath.section];
        NSArray *contacts = [_contactSection objectForKey: key];
        return [contacts objectAtIndex: indexPath.row];
    } else {
        return [_searchedContactList objectAtIndex:indexPath.row];
    }
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
    return [NSIndexPath indexPathForRow:row inSection:section];
}

@end
