//
//  ContactPickerViewController.m
//  Contact
//
//  Created by Hiên on 8/7/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "NimbusContactViewController.h"
#import "ContactPicker.h"
#import "NITableViewModel.h"
#import "ContactEntity.h"
#import "ZATableViewCell.h"
#import "ZACollectionViewCell.h"
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"

@interface NimbusContactViewController () <UITableViewDelegate, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic) NSArray *allCategories;
@property (nonatomic) NITableViewModel *tableViewModel;
@property (nonatomic) NICollectionViewModel *collectionViewModel;
@property (nonatomic) NSArray *contactSectionArray;
@property (nonatomic) NSArray *contactListArray;
@property (nonatomic) NSMutableArray *selectedItems;
@property (nonatomic) NSArray *searchedContactList;

@end

@implementation NimbusContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self constraintData];
    
    [[ContactPicker sharedInstance] getAllContactsWithSection:^(NSDictionary *contacts, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.description);
        } else {
            self.allCategories = [[contacts allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            NSMutableArray *contactSectionArray = [[NSMutableArray alloc] init];
            NSMutableArray *contactListArray = [[NSMutableArray alloc] init];
            for (NSString *key in self.allCategories) {
                [contactSectionArray addObject:key];
                NSArray *listContact = [contacts objectForKey:key];
                for (ContactEntity *contact in listContact) {
                    NICellObject *object = [[NICellObject alloc] initWithCellClass:[ZATableViewCell class] userInfo:contact];
                    [contactSectionArray addObject:object];
                    [contactListArray addObject:object];
                }
            }
            self.contactSectionArray = contactSectionArray;
            self.contactListArray = contactListArray;
            [self buildTableViewModelWithSectionArray:contactSectionArray];
        }
    }];
}

- (void)buildTableViewModelWithSectionArray:(NSArray *)contactSectionArray {
    if (!self.tableView.dataSource) {
        self.tableViewModel = [[NITableViewModel alloc] initWithSectionedArray:contactSectionArray delegate:(id)[NICellFactory class]];
        [self.tableView setDataSource:self.tableViewModel];
        [self.tableView reloadData];
    } else {
        [self recompileTableViewModelDataWithSectionArray:contactSectionArray];
    }
}

- (void)recompileTableViewModelDataWithSectionArray:(NSArray *)contactSectionArray {
    [self.tableViewModel _compileDataWithSectionedArray:contactSectionArray];
    [self.tableView reloadData];
}

- (void)buildTableViewModelWithListArray:(NSArray *)contactListArray {
    if (!self.tableView.dataSource) {
        self.tableViewModel = [[NITableViewModel alloc] initWithListArray:contactListArray delegate:(id)[NICellFactory class]];
        [self.tableView setDataSource:self.tableViewModel];
        [self.tableView reloadData];
    } else {
        [self recompileTableViewModelDataWithListArray:contactListArray];
    }
}

- (void)recompileTableViewModelDataWithListArray:(NSArray *)contactListArray {
    [self.tableViewModel _compileDataWithListArray:contactListArray];
    [self.tableView reloadData];
}

- (void)buildCollectionViewWithListArray:(NSArray *)contactListArray {
    if (!self.collectionView.dataSource) {
        self.collectionViewModel = [[NICollectionViewModel alloc] initWithListArray:contactListArray delegate:(id)[NICollectionViewCellFactory class]];
        [self.collectionView setDataSource:self.collectionViewModel];
        [self.collectionView reloadData];
    } else {
        [self recompileCollectionViewModelDataWithListArray:contactListArray];
    }
}

- (void)recompileCollectionViewModelDataWithListArray:(NSArray *)contactListArray {
    [self.collectionViewModel _compileDataWithListArray:contactListArray];
    [self.collectionView reloadData];
}

- (void)initData {
    self.selectedItems = [[NSMutableArray alloc] init];
    [self buildCollectionViewWithListArray:self.selectedItems];
}

- (void)constraintData {
    [self.tableView setDelegate: self];
    [self.collectionView setDelegate: self];
    [self.searchBar setDelegate: self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// UITableViewDelegate,UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NICellObject *object = [self.tableViewModel objectAtIndexPath:indexPath];
    ContactEntity *contact = object.userInfo;
    if (contact.checked) {
        [contact setChecked:!contact.checked];
        ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell shouldUpdateCellWithObject:object];
        NSUInteger index = [self indexInSelectedItemsOfContact:contact];
        [self.selectedItems removeObjectAtIndex:index];
        [self recompileCollectionViewModelDataWithListArray:self.selectedItems];
        //        [self.selectedItems addObject:contact]; ### remove item from collection view
        if ([self.selectedItems count] <= 0) {
            [UIView animateWithDuration:0.3 animations:^{
                [self.collectionView setHidden:YES];
            }];
        }
    } else {
        if ([self.selectedItems count] >= 5) {
            // Out of range
            NSLog(@"Chon qua 5 nguoi");
        } else {
            [contact setChecked:!contact.checked];
            ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell shouldUpdateCellWithObject:object];
            NICollectionViewCellObject *cellObject = [[NICollectionViewCellObject alloc] initWithCellClass:[ZACollectionViewCell class] userInfo:contact];
            [self.selectedItems addObject:cellObject];
            [self recompileCollectionViewModelDataWithListArray:self.selectedItems];
            // add item to collection view
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar setText:@""];
    [self.searchBar endEditing:YES];
    [self recompileTableViewModelDataWithSectionArray:self.contactSectionArray];
    NICollectionViewCellObject *cellObject = [_selectedItems objectAtIndex:indexPath.row];
    NSIndexPath *index = [self indexInContacSectionArrayOfContact:cellObject.userInfo];
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
    [self.searchBar setText:@""];
    [self.searchBar endEditing:YES];
    [self recompileTableViewModelDataWithSectionArray:self.contactSectionArray];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
    if ([searchText isEqualToString:@""]) {
        // normal searching is NO
        NSLog(@"no searcing");
        [self.tableView reloadData];
    } else {
        // searching is YES
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userInfo.firstName contains[c] %@ OR SELF.userInfo.lastName contains[c] %@", searchText, searchText];
        self.searchedContactList = [self.contactListArray filteredArrayUsingPredicate:predicate];
        NSLog(@"%lu: ", (unsigned long)[_searchedContactList count]);
        [self recompileTableViewModelDataWithListArray:self.searchedContactList];
    }
    
    
}

// Done and Cancel

- (void)cancelSelection {
    
    for (NICollectionViewCellObject *object in self.selectedItems) {
        ContactEntity *contact = object.userInfo;
        [contact setChecked:NO];
    }
    [self.selectedItems removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneSelection {
    [self.searchBar setText:@""];
    [self.searchBar endEditing:YES];
    [self recompileTableViewModelDataWithSectionArray:self.contactSectionArray];
}


// Utils

- (NSUInteger)indexInSelectedItemsOfContact:(ContactEntity *)contact {
    for (NSInteger i=0; i<[self.selectedItems count]; i++) {
        NICollectionViewCellObject *object = [self.selectedItems objectAtIndex:i];
        if (contact == object.userInfo) {
            return i;
        }
    }
    return -1;
}

- (NSIndexPath *)indexInContacSectionArrayOfContact:(ContactEntity *)contact {
    for (NSInteger section=0; section<[self.tableView numberOfSections]; section++) {
        for (NSInteger row=0; row<[self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            NICellObject *object = [self.tableViewModel objectAtIndexPath:indexPath];
            if (contact == object.userInfo) {
                return indexPath;
            }
        }
    }
    return nil;
}

@end
