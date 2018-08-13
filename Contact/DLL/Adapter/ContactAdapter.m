//
//  ContactPicker.m
//  ContactPicker
//
//  Created by Hiên on 7/31/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactAdapter.h"

@implementation ContactAdapter

+ (instancetype)sharedInstance {
    static ContactAdapter *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];        
        instance.store = [[CNContactStore alloc] init];
    });
    return instance;
}

- (void)requestPermission:(void (^)(BOOL granted, NSError * _Nullable error))completion {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (authorizationStatus) {
        case CNAuthorizationStatusAuthorized:
        {
            completion(YES, nil);
        }
            break;
            
        case CNAuthorizationStatusDenied:
        {
            NSError* error = [NSError errorWithDomain:@"vng.contact" code:CNAuthorizationStatusDenied userInfo:@{@"message": @"Contact access denied, please open preferences and allow application access contact"}];
            completion(NO, error);
        }
            break;
        case CNAuthorizationStatusRestricted:
        {
            NSError* error = [NSError errorWithDomain:@"vng.contact" code:CNAuthorizationStatusDenied userInfo:@{@"message": @"Restricted access to contact"}];
            completion(NO, error);
        }
            break;
        case CNAuthorizationStatusNotDetermined:
        {
            [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    completion(granted, nil);
                } else {
                    NSError* error = [NSError errorWithDomain:@"vng.contact" code:CNAuthorizationStatusDenied userInfo:@{@"message": @"No permission to access contact"}];
                    completion(NO, error);
                }
            }];
        }
            break;
        default:
            completion(NO, nil);
            break;
    }
}

- (void)fetchAllContactsHandler:(void(^)(BOOL granted, NSArray *contacts, NSError * _Nullable error))completion {
    [self requestPermission:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSMutableArray *contacts = [[NSMutableArray alloc] init];
            NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey,
                              CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactEmailAddressesKey];
            NSString *containerID = self.store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerID];
            NSError *error;
            NSArray *cnContacts = [self.store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            
            for (CNContact *contact in cnContacts) {
                @try
                {
                    NSMutableArray *phones = [[NSMutableArray alloc] init];
                    for (CNLabeledValue *phone in contact.phoneNumbers) {
                        [phones addObject: [phone.value stringValue]];
                    }
                    ContactEntity *newContact = [[ContactEntity alloc] initWithIdentifier:contact.identifier firstName:contact.givenName middleName:contact.middleName lastName:contact.familyName phones: phones isAvailableImage:contact.imageDataAvailable];
                    [contacts addObject:newContact];
                }
                @catch (NSException *exception)
                {
                    NSLog(@"EXCEPTION IN CONTACTS : %@", exception.description);
                }
            }
            completion(YES, contacts, error);
        } else {
            completion (NO, nil, error);
        }
    }];
}

- (void)getThumbnailImageDataWithIdentifier:(NSString *)identifier completion:(void (^)(NSData *thumbnailData, NSError * error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
        [self.store containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers:@[self.store.defaultContainerIdentifier]] error:&error];
        if (error) {
            completion(nil, error);
        } else {
            CNContact *contact = [self.store unifiedContactWithIdentifier:identifier keysToFetch:@[CNContactThumbnailImageDataKey, CNContactImageDataKey] error:&error];
            if (error) {
                completion(nil, error);
            } else {
                if (contact.thumbnailImageData) {
                    completion(contact.thumbnailImageData, nil);
                } else {
                    completion(contact.imageData, nil);
                }                
            }
        }
    });
}

@end
