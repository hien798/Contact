//
//  ContactPicker.h
//  ContactPicker
//
//  Created by Hiên on 7/31/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "ContactEntity.h"

@interface ContactPicker : NSObject

+ (instancetype)sharedInstance;

- (void)fetchAllContactsHandler:(void(^)(BOOL granted, NSArray *contacts, NSError * _Nullable error))completion;

- (void)getAllContacts:(void(^)(BOOL granted, NSArray *contacts, NSError * _Nullable error))completion;

- (void)getAllContactsWithSection:(void(^)(BOOL granted, NSDictionary *contacts, NSError * _Nullable error))completion;

@end
