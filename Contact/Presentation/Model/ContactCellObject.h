//
//  ContactModel.h
//  Contact
//
//  Created by Hiên on 8/16/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "NICellFactory.h"
#import "ContactEntity.h"

@interface ContactCellObject : NICellObject

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *thumbnailLabel;
@property (nonatomic) BOOL checked;

@end
