//
//  ZATableViewCell2.h
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellFactory.h"
#import "ContactEntity.h"

@interface ZATableViewCell : UITableViewCell <NICell>

@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *avatar;
@property (nonatomic) UIImageView *thumbnail;
@property (nonatomic) UIImageView *tickBox;

/**
 * Generate a color base on 
 *
 *
 */

- (void)setAvatarColorWithTitle:(NSString *)title;
- (void)setThumbnailWithImage:(UIImage *)image;

@end
