//
//  ZATableViewCell2.m
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZATableViewCell.h"
#import "ContactPicker.h"

@implementation ZATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initTitle {
    _title = [[UILabel alloc] init];
    _title.font = [UIFont systemFontOfSize:18.0];
}

- (void)initAvatar {
    _avatarLabel = [[UILabel alloc] init];
    _avatarLabel.backgroundColor = [UIColor grayColor];
    _avatarLabel.textAlignment = NSTextAlignmentCenter;
    _avatarLabel.textColor = [UIColor whiteColor];
    _avatarLabel.font = [UIFont systemFontOfSize:20.0];
    _avatarLabel.layer.cornerRadius = 0.5*50;
    _avatarLabel.layer.masksToBounds = YES;
}

- (void)initThumbnail {
    _thumbnailImage = [[UIImageView alloc] init];
    _thumbnailImage.layer.cornerRadius = 0.5*50;
    _thumbnailImage.layer.masksToBounds = YES;
}

- (void)initTickBox {
    _tickBox = [[UIImageView alloc] init];
    _tickBox.contentMode = UIViewContentModeScaleAspectFill;
    _tickBox.clipsToBounds = YES;
    _tickBox.layer.cornerRadius = 0.5*30;
    _tickBox.layer.masksToBounds = YES;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initTitle];
    [self initAvatar];
    [self initTickBox];
    [self initThumbnail];
    [self.contentView addSubview:_tickBox];
    [self.contentView addSubview:_title];
    [self.contentView addSubview:_avatarLabel];
    [self.contentView addSubview:_thumbnailImage];
    
    _tickBox.frame = CGRectMake(10, 20, 30, 30);
    _avatarLabel.frame = CGRectMake(_tickBox.frame.origin.x + _tickBox.frame.size.width + 10, 10, 50, 50);
    _title.frame = CGRectMake(_avatarLabel.frame.origin.x + _avatarLabel.frame.size.width + 10, _avatarLabel.frame.origin.y, self.bounds.size.width - _avatarLabel.frame.origin.x + _avatarLabel.frame.size.width + 10, _avatarLabel.frame.size.height);
    _thumbnailImage.frame = _avatarLabel.frame;
    
    return self;
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


# pragma mark - NICell

- (BOOL)shouldUpdateCellWithObject:(id)object {
    NICellObject *cellObject = object;
    ContactEntity *contact = cellObject.userInfo;
    _title.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    _avatarLabel.text = [contact.contactList objectForKey:@"avatar"];
    [self setAvatarColorWithTitle:self.avatarLabel.text];
    if (contact.isAvailableImage) {
        [[ContactPicker sharedInstance] getThumbnailImageWithIdentifier:contact.identifier completion:^(UIImage *thumbnailImage, NSError *error) {
            [self setThumbnailWithImage:thumbnailImage];
        }];
    } else {
        [self setThumbnailWithImage:nil];
    }
    if (contact.checked) {
        _tickBox.image = [UIImage imageNamed:@"ic-tick"];
    } else {
        _tickBox.image = [UIImage imageNamed:@"ic-none"];
    }
    return YES;
}

@end
