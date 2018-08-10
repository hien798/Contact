//
//  ZACollectionViewCell.h
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICollectionViewCellFactory.h"
#import "Contact.h"

@interface ZACollectionViewCell : UICollectionViewCell <NICollectionViewCell>

@property (nonatomic) UILabel *avatar;

- (void)setAvatarColorWithTitle:(NSString *)title;

@end
