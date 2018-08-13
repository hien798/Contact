//
//  Contact.m
//  Contact
//
//  Created by Hiên on 8/7/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactEntity.h"

@implementation ContactEntity


- (id)init {
    self = [super init];
    if (self != nil) {
        [self setFirstName:@""];
        [self setMiddleName:@""];
        [self setLastName:@""];
        NSMutableDictionary *contactList = [[NSMutableDictionary alloc] init];
        [self setContactList:contactList];
    }
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier firstName:(NSString *)firstName middleName:(NSString *)middleName lastName:(NSString *)lastName phones:(NSArray *)phones isAvailableImage:(BOOL)isAvailableImage {
    [self setIdentifier:identifier];
    [self setFirstName:firstName];
    [self setMiddleName:@""];
    [self setLastName:lastName];
    [self setIsAvailableImage:isAvailableImage];
    [self setChecked:NO];
    NSMutableDictionary *contactList = [[NSMutableDictionary alloc] initWithObjectsAndKeys: phones, @"phones", nil];
    [self setContactList:contactList];
    [self setAvatar];
    return self;
}

- (void)setAvatar {
    NSString *avatar = [_contactList objectForKey:@"avatar"];
    if (avatar == nil || [avatar isEqualToString:@""]) {
        avatar = @"";
        if (_firstName != nil && ![_firstName isEqualToString:@""]) {
            avatar = [avatar stringByAppendingString: [_firstName substringToIndex:1]];
        }
        if (_lastName != nil && ![_lastName isEqualToString:@""]) {
            avatar = [avatar stringByAppendingString: [_lastName substringToIndex:1]];
        }
    }
    avatar = [avatar uppercaseString];
    [self.contactList setObject:avatar forKey:@"avatar"];
}

//- (void)addContactList:(NSString *)item value:(NSString *)value {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:_contactList];
//    [dic setObject:value forKey:item];
//    [self setContactList:[dic copy]];
//}

@end
