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

- (void)getAllContactsWithList:(void(^)(NSArray *contacts, NSError * _Nullable error))completion;

- (void)getAllContactsWithSection:(void(^)(NSDictionary *contacts, NSError * _Nullable error))completion;

- (void)getThumbnailImageWithIdentifier:(NSString *)identifier completion:(void (^)(UIImage *thumbnailImage, NSError * error))completion;

@end
