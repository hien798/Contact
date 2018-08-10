//
//  ContactPicker.m
//  ContactPicker
//
//  Created by Hiên on 7/31/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactPicker.h"

@implementation ContactPicker

+ (instancetype)sharedInstance {
    static ContactPicker *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)fetchAllContactsHandler:(void(^)(BOOL granted, NSArray *contacts, NSError * _Nullable error))completion {
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (authorizationStatus) {
        case CNAuthorizationStatusAuthorized:
        {
            NSArray *contacts;
            NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey,
                              CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerID = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerID];
            NSError *error;
            contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            completion(YES, contacts, error);
        }
            break;
            
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusNotDetermined:
        {
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSArray *contacts;
                    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey,
                                      CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
                    NSString *containerID = store.defaultContainerIdentifier;
                    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerID];
                    NSError *error;
                    contacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
                    completion(granted, contacts, error);
                } else {
                    NSLog(@"No Permission");
                    completion(NO, nil, nil);
                }
            }];
        }
            break;
        default:
            completion(NO, nil, nil);
            break;
    }
}

- (void)getAllContacts:(void(^)(BOOL granted, NSArray *contacts, NSError * _Nullable error))completion {
    
    [self fetchAllContactsHandler:^(BOOL granted, NSArray *contacts, NSError * _Nullable error) {
        NSMutableArray *allContacts = nil;
        if (granted) {
            allContacts = [[NSMutableArray alloc] init];
            if (error) {
                NSLog(@"Error: %@", error.description);
            } else {
                for (CNContact *contact in contacts) {
                    @try
                    {
                        NSMutableArray *phones = [[NSMutableArray alloc] init];
                        for (CNLabeledValue *phone in contact.phoneNumbers) {
                            [phones addObject: [phone.value stringValue]];
                        }
                        Contact *newContact = [[Contact alloc] initWithFirstName:contact.givenName middleName:contact.middleName lastName:contact.familyName phones: phones];
                        
                        NSMutableArray *emails = [[NSMutableArray alloc] init];
                        for (CNLabeledValue *email in contact.emailAddresses) {
                            [emails addObject:email.value];
                        }
                        [newContact.contactList setObject:emails forKey:@"emails"];
                        [allContacts addObject:newContact];
                    }
                    @catch (NSException *exception)
                    {
                        NSLog(@"EXCEPTION IN CONTACTS : %@", exception.description);
                    }                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(granted, allContacts, error);
        });
    }];
}

- (void)getAllContactsWithSection:(void(^)(BOOL granted, NSDictionary *contacts, NSError * _Nullable error))completion {
    
    [self fetchAllContactsHandler:^(BOOL granted, NSArray *contacts, NSError * _Nullable error) {
        NSMutableDictionary *allContacts = nil;
        if (granted) {
            allContacts = [[NSMutableDictionary alloc] init];
            if (error) {
                NSLog(@"Error: %@", error.description);
            } else {
                for (CNContact *contact in contacts) {
                    @try
                    {
                        NSMutableArray *phones = [[NSMutableArray alloc] init];
                        for (CNLabeledValue *phone in contact.phoneNumbers) {
                            [phones addObject: [phone.value stringValue]];
                        }
                        
                        Contact *newContact = [[Contact alloc] initWithFirstName:contact.givenName middleName:contact.middleName lastName:contact.familyName phones:phones];
                        
                        NSMutableArray *emails = [[NSMutableArray alloc] init];
                        for (CNLabeledValue *email in contact.emailAddresses) {
                            [emails addObject:email.value];
                        }
                        [newContact.contactList setObject:emails forKey:@"emails"];
                        
                        NSString *category;
                        if (contact.givenName && ![contact.givenName isEqualToString:@""]) {
                            category = [[contact.givenName substringToIndex:1] uppercaseString];
                        } else {
                            category = @"";
                        }
                                                
                        NSMutableArray *listContact = [allContacts objectForKey:category];
                        
                        if (!listContact) {
                            listContact = [[NSMutableArray alloc] init];
                            [listContact addObject:newContact];
                            [allContacts setObject:listContact forKey:category];
                        } else {
                            [listContact addObject:newContact];
                            [allContacts setValue:listContact forKey:category];
                        }
                    }
                    @catch (NSException *exception)
                    {
                        NSLog(@"EXCEPTION IN CONTACTS : %@", exception.description);
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(granted, allContacts, error);
        });
    }];
}

@end
