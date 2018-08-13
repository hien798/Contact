//
//  ZACollectionViewCell.h
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICollectionViewCellFactory.h"
#import "ContactEntity.h"

@interface ZACollectionViewCell : UICollectionViewCell <NICollectionViewCell>

@property (nonatomic) UILabel *avatar;
@property (nonatomic) UIImageView *thumbnail;

- (void)setAvatarColorWithTitle:(NSString *)title;
- (void)setThumbnailWithImage:(UIImage *)image;

@end
