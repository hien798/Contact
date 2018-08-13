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
    _avatar = [[UILabel alloc] init];
    [_avatar setBackgroundColor:[UIColor grayColor]];
    [_avatar setTextAlignment: NSTextAlignmentCenter];
    [_avatar setTextColor: [UIColor whiteColor]];
    [_avatar setFont: [UIFont systemFontOfSize: 20.0]];
    [_avatar.layer setCornerRadius: 0.5*50];
    [_avatar.layer setMasksToBounds: YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initAvatar];
    [self initThumbnail];
    [self.contentView addSubview: _avatar];
    [self.contentView addSubview:_thumbnail];
    [_avatar setFrame: CGRectMake(10, 0, 50, 50)]; // cell frame height = 70
    [_thumbnail setFrame:_avatar.frame];
    [self setBackgroundColor: [UIColor clearColor]];
    return self;
}

- (void)initThumbnail {
    _thumbnail = [[UIImageView alloc] init];
    [_thumbnail.layer setCornerRadius: 0.5*50]; // table row height = 70;
    [_thumbnail.layer setMasksToBounds:YES];
}

- (void)setThumbnailWithImage:(UIImage *)image {
    [_thumbnail setImage:image];
}

- (void)setAvatarColorWithTitle:(NSString *)title {
    UIColor *color = [self getColorWithTitle:title];
    [_avatar setBackgroundColor:color];
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

- (BOOL)shouldUpdateCellWithObject:(id)object {
    NSLog(@"Collection View Update");
    NICollectionViewCellObject *cellObject = object;
    ContactEntity *contact = cellObject.userInfo;
    [self.avatar setText:[contact.contactList objectForKey:@"avatar"]];
    [self setAvatarColorWithTitle:self.avatar.text];
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
