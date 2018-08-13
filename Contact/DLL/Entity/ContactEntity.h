//
//  Contact.h
//  Contact
//
//  Created by Hiên on 8/7/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactEntity : NSObject

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *middleName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) BOOL isAvailableImage;
@property (nonatomic) BOOL checked;

@property (nonatomic) NSMutableDictionary *contactList;

- (id)init;
- (id)initWithIdentifier:(NSString *)identifier firstName:(NSString *)firstName middleName:(NSString *)middleName lastName:(NSString *)lastName phones:(NSArray *)phones isAvailableImage:(BOOL)isAvailableImage;

@end
