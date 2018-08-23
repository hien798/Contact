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
@property (nonatomic) UILabel *avatarLabel;
@property (nonatomic) UIImageView *thumbnailImage;
@property (nonatomic) UIImageView *tickBox;

/**
 * Generate a color base on a string and set thumbnail background color with it
 * If contact has no image, a label with this background color will be shown
 * @param title A string generate color
 */
- (void)setAvatarColorWithTitle:(NSString *)title;

/**
 * Set thumbnail image for contact
 * @param image The image has been loaded from phonebook
 */
- (void)setThumbnailWithImage:(UIImage *)image;

@end
