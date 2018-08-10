//
//  ZABaseViewController.m
//  Contact
//
//  Created by Hiên on 8/10/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZABaseViewController.h"

@interface ZABaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation ZABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initStackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    _tableView = [[UITableView alloc] init];
}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    [_searchBar setTranslatesAutoresizingMaskIntoConstraints: NO];
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setSectionInset: UIEdgeInsetsMake(0, 0, 0, 0)];
    [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing: 5];
    [layout setMinimumInteritemSpacing: 0];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView setHidden:YES];
    [_collectionView setBackgroundColor: [UIColor lightGrayColor]];
}

- (void)initStackView {
    [self initTableView];
    [self initSearchBar];
    [self initCollectionView];
    _stackView = [[UIStackView alloc] initWithArrangedSubviews: @[_collectionView, _searchBar, _tableView]];
    [_stackView setAxis: UILayoutConstraintAxisVertical];
    [_stackView setDistribution: UIStackViewDistributionFill];
    [_stackView setAlignment: UIStackViewAlignmentFill];
    [_stackView setSpacing: 0];
    [_stackView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self.view addSubview: _stackView];
    
    NSDictionary *viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: _stackView, @"stackView", _collectionView, @"collectionView", nil];
    
    CGFloat statusBarHeight = UIApplication.sharedApplication.isStatusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat top = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.x + statusBarHeight;
    NSArray *stackViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[stackView]-0-|", top] options:0 metrics:nil views:viewsDictionary];
    
    [[_collectionView.topAnchor constraintEqualToAnchor: _stackView.topAnchor constant: 0] setActive: YES];
    [[_collectionView.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 0] setActive: YES];
    [[_collectionView.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: 0] setActive: YES];
    [[_collectionView.heightAnchor constraintEqualToConstant: 70] setActive: YES];
    
    [[_collectionView.leftAnchor constraintEqualToAnchor: self.view.leftAnchor constant: 0] setActive: YES];
    [[_collectionView.rightAnchor constraintEqualToAnchor: self.view.rightAnchor constant: 0] setActive: YES];
    [[_searchBar.heightAnchor constraintEqualToConstant: 50] setActive: YES];
    
    [self.view addConstraints: stackViewConstraints];
}

- (void)initNavigationBar {
    [self setTitle:@"Select Friends"];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(touchCancelBtn:)];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDonelBtn:)];
    [self.navigationItem setLeftBarButtonItem:leftBarBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
}

- (void)touchCancelBtn:(UIBarButtonItem *)sender {
    [self cancelSelection];
}

- (void)touchDonelBtn:(UIBarButtonItem *)sender {
    [self doneSelection];
}

- (void)cancelSelection {
    NSLog(@"Cancel");
}

- (void)doneSelection {
    NSLog(@"Done");
}

- (void)initGestureRecognize {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipe setDirection: UISwipeGestureRecognizerDirectionUp];
    [swipe setDelegate:self];
    [self.view addGestureRecognizer:swipe];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

// Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
