//
//  ContactModel.m
//  Contact
//
//  Created by Hiên on 8/16/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ContactCellObject.h"

@implementation ContactCellObject

- (instancetype)initWithCellClass:(Class)cellClass contact:(ContactEntity *)contact {
    self = [super initWithCellClass:cellClass];
    if (self) {
        _identifier = contact.identifier;
        _displayName = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
        _thumbnailLabel = @"ha";
        _checked = NO;
    }
    return self;
}

@end
