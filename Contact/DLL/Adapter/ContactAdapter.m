//
//  ContactPicker.m
//  ContactPicker
//
//  Created by Hiên on 7/31/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactAdapter.h"

NSString * const kErrorDomain = @"vng.contact";

@interface ContactAdapter ()
@property (nonatomic) CNContactStore *store;
@end

typedef NS_ENUM(NSInteger, ZAAuthorizationStatus) {
    ZAAuthorizationStatusAuthorized,
    ZAAuthorizationStatusDenied
};

typedef NS_ENUM(NSInteger, ZALoadImageStatus) {
    ZALoadImageStatusInvalidIdentifier,
    ZALoadImageStatusFailed
};

@implementation ContactAdapter

+ (instancetype)sharedInstance {
    static ContactAdapter *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.store = [[CNContactStore alloc] init];
    }
    return self;
}

- (void)requestPermission:(void (^)(BOOL granted, NSError *error))completion {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (authorizationStatus) {
        case CNAuthorizationStatusAuthorized:
        {
            completion ? completion(YES, nil) : nil;
            break;
        }
        case CNAuthorizationStatusDenied:
        {
            NSError* error = [NSError errorWithDomain:kErrorDomain code:ZAAuthorizationStatusDenied userInfo:@{@"message": @"Contact access denied, please open preferences and allow application access contact"}];
            completion ? completion(NO, error) : nil;
            break;
        }
        case CNAuthorizationStatusRestricted:
        {
            NSError* error = [NSError errorWithDomain:kErrorDomain code:ZAAuthorizationStatusDenied userInfo:@{@"message": @"Restricted access to contact"}];
            completion ? completion(NO, error) : nil;
            break;
        }
        case CNAuthorizationStatusNotDetermined:
        {
            [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) {
                if (granted) {
                    completion ? completion(granted, nil) : nil;
                } else {
                    NSError* error = [NSError errorWithDomain:kErrorDomain code:ZAAuthorizationStatusDenied userInfo:@{@"message": @"No permission to access contact"}];
                    completion ? completion(NO, error) : nil;
                }
            }];        
            break;
        }
        default:
            completion ? completion(NO, nil) : nil;
            break;
    }
}

- (void)fetchAllContactsHandler:(void(^)(BOOL granted, NSArray *contacts, NSError *error))completion {
    if (!completion) {
        return;
    }
    [self requestPermission:^(BOOL granted, NSError *error) {
        if (granted) {
            NSMutableArray *contacts = [[NSMutableArray alloc] init];
            NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey,
                              CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactEmailAddressesKey];
            NSString *containerID = self.store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerID];
            NSError *error;
            NSArray *cnContacts = [self.store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            
            for (CNContact *contact in cnContacts) {
                NSMutableArray *phones = [[NSMutableArray alloc] init];
                for (CNLabeledValue *phone in contact.phoneNumbers) {
                    [phones addObject:[phone.value stringValue]];
                }
                ContactEntity *newContact = [[ContactEntity alloc] initWithIdentifier:contact.identifier
                                                                            firstName:contact.givenName
                                                                           middleName:contact.middleName
                                                                             lastName:contact.familyName
                                                                               phones:phones
                                                                     isAvailableImage:contact.imageDataAvailable];
                [contacts addObject:newContact];
            }
            completion(YES, contacts, error);
        } else {
            completion (NO, nil, error);
        }
    }];
}

- (void)getThumbnailImageDataWithIdentifier:(NSString *)identifier completion:(void (^)(NSData *thumbnailData, NSError * error))completion {
    if (!completion) {
        return;
    }
    if (!identifier) {
        NSError* error = [NSError errorWithDomain:kErrorDomain code:ZALoadImageStatusInvalidIdentifier userInfo:@{@"message": @"Invald indentifier"}];
        completion(nil, error);
    }
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
