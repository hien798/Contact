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
    [self initGestureRecognize];
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
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchBar setShowsCancelButton:YES animated:YES];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.hidden = YES;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
}

- (void)initStackView {
    [self initTableView];
    [self initSearchBar];
    [self initCollectionView];
    _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_collectionView, _searchBar, _tableView]];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.distribution = UIStackViewDistributionFill;
    _stackView.alignment = UIStackViewAlignmentFill;
    _stackView.spacing = 0;
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_stackView];
    
    NSDictionary *viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:_stackView, @"stackView", _collectionView, @"collectionView", nil];
    
    CGFloat statusBarHeight = UIApplication.sharedApplication.isStatusBarHidden ? 0 :UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat top = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.x + statusBarHeight;
    NSArray *stackViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[stackView]-0-|", top] options:0 metrics:nil views:viewsDictionary];
    
    [[_collectionView.topAnchor constraintEqualToAnchor:_stackView.topAnchor constant:0] setActive:YES];
    [[_collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0] setActive:YES];
    [[_collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0] setActive:YES];
    [[_collectionView.heightAnchor constraintEqualToConstant:70] setActive:YES];
    
    [[_collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0] setActive:YES];
    [[_collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0] setActive:YES];
    [[_searchBar.heightAnchor constraintEqualToConstant:50] setActive:YES];
    
    [self.view addConstraints:stackViewConstraints];
}

- (void)initNavigationBar {
    [self setTitle:@"Select Friends"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(touchCancelBtn:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(touchDonelBtn:)];
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

# pragma mark - UIGestureRecognizer

- (void)initGestureRecognize {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    swipe.delegate = self;
    [self.view addGestureRecognizer:swipe];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


# pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
