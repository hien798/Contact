//
//  ContactPicker.h
//  Contact
//
//  Created by Hiên on 8/13/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactPicker : NSObject

+ (instancetype)sharedInstance;

/**
 * Get all contacts from phonebook to a list array
 * @param completion A block will be callback after method execute, all contacts will be added to contacts array and an error will be returned if method failed.
 */
- (void)getAllContactsWithList:(void(^)(NSArray *contacts, NSError *error))completion;

/**
 * Get all conatacts from phonebook to a section array
 * @param completion A block will be callback after method execute, a dictionary will be return with key is the first character of first name of a contact, a array store all contacts with this key, an error will be returned if method failed.
 */
- (void)getAllContactsWithSection:(void(^)(NSDictionary *contacts, NSError *error))completion;

/**
 * Get thumbnail image from phonebook with identifier of contact
 * @param identifier Identifier of contact.
 * @param completion A block will be callback after method execute, an image will be stored to thumbnailImage and an error will be returned if method failed.
 */
- (void)getThumbnailImageWithIdentifier:(NSString *)identifier completion:(void (^)(UIImage *thumbnailImage, NSError * error))completion;

@end
