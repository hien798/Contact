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
        _firstName = @"";
        _middleName = @"";
        _lastName = @"";
        _contactList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithIdentifier:(NSString *)identifier
               firstName:(NSString *)firstName
              middleName:(NSString *)middleName
                lastName:(NSString *)lastName
                  phones:(NSArray *)phones
        isAvailableImage:(BOOL)isAvailableImage {
    
    self = [super init];
    
    if (self) {
        _identifier = identifier;
        _firstName = firstName;
        _middleName = @"";
        _lastName = lastName;
        _isAvailableImage = isAvailableImage;
        _checked = NO;
        _contactList = [[NSMutableDictionary alloc] initWithObjectsAndKeys:phones, @"phones", nil];
        [self setAvatar];
    }
    
    return self;
}

- (void)setAvatar {
    NSString *avatar = [_contactList objectForKey:@"avatar"];
    if (avatar == nil || [avatar isEqualToString:@""]) {
        avatar = @"";
        if (_firstName != nil && ![_firstName isEqualToString:@""]) {
            avatar = [avatar stringByAppendingString:[_firstName substringToIndex:1]];
        }
        if (_lastName != nil && ![_lastName isEqualToString:@""]) {
            avatar = [avatar stringByAppendingString:[_lastName substringToIndex:1]];
        }
    }
    avatar = [avatar uppercaseString];
    [self.contactList setObject:avatar forKey:@"avatar"];
}

@end
