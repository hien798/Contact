//
//  ContactUITests.m
//  ContactUITests
//
//  Created by Hiên on 8/7/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ContactUITests : XCTestCase

@end

@implementation ContactUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    
    
    
}

- (void)testPerformance {
    
    [self measureBlock:^{
        XCUIApplication *app = [[XCUIApplication alloc] init];
        [app.buttons[@"Nimbus"] tap];
        
        XCUIElementQuery *tableQuery = app.tables;
        [tableQuery.staticTexts[@"HH"] tap];
        [tableQuery.staticTexts[@"DT"] tap];
        [tableQuery.cells.staticTexts[@"K"] tap];
        [tableQuery.staticTexts[@"AH"] tap];
        [tableQuery.staticTexts[@"HH"] tap];
        [tableQuery.staticTexts[@"HH"] tap];
        [tableQuery.staticTexts[@"HH"] doubleTap];
        
        XCUIElementQuery *tablesQuery = [[XCUIApplication alloc] init].tables;
        [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Hank Zakroff"]/*[[".cells.staticTexts[@\"Hank Zakroff\"]",".staticTexts[@\"Hank Zakroff\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ swipeUp];
        
        [tableQuery.staticTexts[@"X"] tap];
        // DT, K, AH, HH, X
        

        
        
        XCUIElementQuery *collectionQuery = app.collectionViews;
        [collectionQuery.staticTexts[@"DT"] tap];
        [collectionQuery.staticTexts[@"HH"] tap];
        [collectionQuery.staticTexts[@"K"] tap];
        [collectionQuery.staticTexts[@"X"] tap];
        [collectionQuery.staticTexts[@"AH"] tap];
        
        
    }];
    
    
}

@end
