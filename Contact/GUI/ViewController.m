//
//  ViewController.m
//  Contact
//
//  Created by Hiên on 8/10/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ViewController.h"
#import "ContactViewController.h"
#import "NimbusContactViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    UIButton *nativeSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 - 50, 140, 40)];
    UIButton *nimbusSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 70, self.view.frame.size.height/2 + 10, 140, 40)];
    [nativeSelectBtn setTitle:@"Native" forState:UIControlStateNormal];
    [nimbusSelectBtn setTitle:@"Nimbus" forState:UIControlStateNormal];
    [nativeSelectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [nimbusSelectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [nativeSelectBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [nimbusSelectBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [nativeSelectBtn addTarget:self action:@selector(nativeSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nimbusSelectBtn addTarget:self action:@selector(nimbusSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nativeSelectBtn];
    [self.view addSubview:nimbusSelectBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nativeSelectBtnClicked:(UIButton *)sender {
    ContactViewController *contactsViewController = [[ContactViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)nimbusSelectBtnClicked:(UIButton *)sender {
    NimbusContactViewController *contactsViewController = [[NimbusContactViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    [self presentViewController:navController animated:YES completion:nil];
}


@end
