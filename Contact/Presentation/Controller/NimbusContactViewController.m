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
    
    [[ContactPicker sharedInstance] getAllContactsWithSection:^(NSDictionary *contacts, NSError *error) {
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
        self.tableView.dataSource = self.tableViewModel;
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
        self.tableView.dataSource = self.tableViewModel;
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
        self.collectionView.dataSource = self.collectionViewModel;
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
    self.tableView.delegate = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NICellObject *object = [self.tableViewModel objectAtIndexPath:indexPath];
    ContactEntity *contact = object.userInfo;
    if (contact.checked) {
        contact.checked = !contact.checked;
        ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell shouldUpdateCellWithObject:object];
        NSUInteger index = [self indexInSelectedItemsOfContact:contact];
        [self.selectedItems removeObjectAtIndex:index];
        [self recompileCollectionViewModelDataWithListArray:self.selectedItems];
        if ([self.selectedItems count] <= 0) {
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.hidden = YES;
            }];
        }
    } else {
        if ([self.selectedItems count] >= 5) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thông báo" message:@"Không được chọn quá 5 người" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            contact.checked = !contact.checked;
            ZATableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell shouldUpdateCellWithObject:object];
            NICollectionViewCellObject *cellObject = [[NICollectionViewCellObject alloc] initWithCellClass:[ZACollectionViewCell class] userInfo:contact];
            [self.selectedItems addObject:cellObject];
            [self recompileCollectionViewModelDataWithListArray:self.selectedItems];
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.hidden = NO;
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    [self recompileTableViewModelDataWithSectionArray:self.contactSectionArray];
    NICollectionViewCellObject *cellObject = [_selectedItems objectAtIndex:indexPath.row];
    NSIndexPath *index = [self indexInContacSectionArrayOfContact:cellObject.userInfo];
    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


# pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    [self recompileTableViewModelDataWithSectionArray:self.contactSectionArray];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self.tableView reloadData];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userInfo.firstName contains[c] %@ OR SELF.userInfo.lastName contains[c] %@", searchText, searchText];
        self.searchedContactList = [self.contactListArray filteredArrayUsingPredicate:predicate];
        [self recompileTableViewModelDataWithListArray:self.searchedContactList];
    }
}


/// Done and Cancel

- (void)cancelSelection {
    
    for (NICollectionViewCellObject *object in self.selectedItems) {
        ContactEntity *contact = object.userInfo;
         contact.checked = NO;
    }
    [self.selectedItems removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneSelection {
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
    [self recompileTableViewModelDataWithSectionArray:self.contactSectionArray];
}


/// Utils

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
