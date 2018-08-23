//
//  ContactPicker.m
//  Contact
//
//  Created by Hiên on 8/13/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactPicker.h"
#import "ContactAdapter.h"
#import "ContactEntity.h"

@implementation ContactPicker

static NSCache *imageCache;

+ (instancetype)sharedInstance {
    static ContactPicker *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)getAllContactsWithList:(void(^)(NSArray *contacts, NSError *error))completion {
    ContactAdapter *contactAdapter = [ContactAdapter sharedInstance];
    [contactAdapter fetchAllContactsHandler:^(BOOL granted, NSArray *contacts, NSError *error) {
        if (!completion) {
            return;
        }
        if (granted) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(contacts, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }];
}

- (void)getAllContactsWithSection:(void(^)(NSDictionary *contacts, NSError *error))completion {
    ContactAdapter *contactAdapter = [ContactAdapter sharedInstance];
    [contactAdapter fetchAllContactsHandler:^(BOOL granted, NSArray *contacts, NSError *error) {
        if (!completion) {
            return;
        }
        NSMutableDictionary *allContacts = nil;
        if (granted) {
            allContacts = [[NSMutableDictionary alloc] init];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            } else {
                for (ContactEntity *contact in contacts) {
                    NSString *category;
                    if (contact.firstName && ![contact.firstName isEqualToString:@""]) {
                        category = [[contact.firstName substringToIndex:1] uppercaseString];
                    } else {
                        category = @"";
                    }
                    NSMutableArray *listContact = [allContacts objectForKey:category];
                    if (!listContact) {
                        listContact = [[NSMutableArray alloc] init];
                        [listContact addObject:contact];
                        [allContacts setObject:listContact forKey:category];
                    } else {
                        [listContact addObject:contact];
                        [allContacts setValue:listContact forKey:category];
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(allContacts, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }];
}

- (void)getThumbnailImageWithIdentifier:(NSString *)identifier completion:(void (^)(UIImage *thumbnailImage, NSError * error))completion {
    if (!imageCache) {
        imageCache = [[NSCache alloc] init];
    }
    if ([imageCache objectForKey:identifier]) {
        completion ? completion([imageCache objectForKey:identifier], nil) : nil;
    } else {
        [[ContactAdapter sharedInstance] getThumbnailImageDataWithIdentifier:identifier completion:^(NSData *thumbnailData, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion ? completion(nil, error) : nil;
                });
            } else {
                UIImage *image = [UIImage imageWithData:thumbnailData];
                [imageCache setObject:image forKey:identifier];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion ? completion(image, nil) : nil;
                });
            }
        }];
    }
}

@end
