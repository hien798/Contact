//
//  ZACollectionViewCell.m
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZACollectionViewCell.h"
#import "ContactPicker.h"

@implementation ZACollectionViewCell

- (void)initAvatar {
    _avatarLabel = [[UILabel alloc] init];
    _avatarLabel.backgroundColor = [UIColor grayColor];
    _avatarLabel.textAlignment = NSTextAlignmentCenter;
    _avatarLabel.textColor = [UIColor whiteColor];
    _avatarLabel.font = [UIFont systemFontOfSize:20.0];
    _avatarLabel.layer.cornerRadius = 0.5*50;
    _avatarLabel.layer.masksToBounds = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initAvatar];
    [self initThumbnail];
    [self.contentView addSubview:_avatarLabel];
    [self.contentView addSubview:_thumbnailImage];
    _avatarLabel.frame = CGRectMake(10, 0, 50, 50); // cell frame height = 70
    _thumbnailImage.frame = _avatarLabel.frame;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)initThumbnail {
    _thumbnailImage = [[UIImageView alloc] init];
    _thumbnailImage.layer.cornerRadius = 0.5*50;
    _thumbnailImage.layer.masksToBounds = YES;
}

- (void)setThumbnailWithImage:(UIImage *)image {
    _thumbnailImage.image = image;
}

- (void)setAvatarColorWithTitle:(NSString *)title {
    UIColor *color = [self getColorWithTitle:title];
    _avatarLabel.backgroundColor = color;
}

- (UIColor *)getColorWithTitle:(NSString *)title {
    if (!title || [title isEqualToString:@""]) {
        return [UIColor grayColor];
    } else {
        int rand = 0;
        for (int i=0; i<[title length]; i++) {
            rand += [title characterAtIndex:i]*[title characterAtIndex:i];
        }
        double colorPoint = (rand%255)/255.0f;
        return [UIColor colorWithRed:colorPoint green:colorPoint*0.8f blue:0.5f alpha:0.8];
    }
}


# pragma mark - NICollectionViewCell

- (BOOL)shouldUpdateCellWithObject:(id)object {
    NICollectionViewCellObject *cellObject = object;
    ContactEntity *contact = cellObject.userInfo;
    _avatarLabel.text = [contact.contactList objectForKey:@"avatar"];
    [self setAvatarColorWithTitle:self.avatarLabel.text];
    if (contact.isAvailableImage) {
        [[ContactPicker sharedInstance] getThumbnailImageWithIdentifier:contact.identifier completion:^(UIImage *thumbnailImage, NSError *error) {
            [self setThumbnailWithImage:thumbnailImage];
        }];
    } else {
        [self setThumbnailWithImage:nil];
    }
    return YES;
}

@end
