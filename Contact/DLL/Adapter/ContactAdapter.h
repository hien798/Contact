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

@interface ContactAdapter : NSObject

+ (instancetype)sharedInstance;

/**
 * Fetch all contacts in phonebook and return a callback block
 * @param completion A block will be callback after method execute, contacts will be fetched to contacts array and an error will be returned if method failed.
 */
- (void)fetchAllContactsHandler:(void(^)(BOOL granted, NSArray *contacts, NSError * _Nullable error))completion;

/**
 * Fetch image data of a contact with it's identifier
 * @param identifier Identifier of contact.
 * @param completion A block will be callback after method execute, image data will be fetched to thumbnailData and an error will be returned if method failed.
 */
- (void)getThumbnailImageDataWithIdentifier:(NSString *)identifier completion:(void (^)(NSData *thumbnailData, NSError * error))completion;

@end
