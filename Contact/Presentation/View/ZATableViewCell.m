//
//  ZATableViewCell2.m
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZATableViewCell.h"

@implementation ZATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)initTitle {
    _title = [[UILabel alloc] init];
    [_title setFont: [UIFont systemFontOfSize: 18.0]];
}

- (void)initAvatar {
    _avatar = [[UILabel alloc] init];
    [_avatar setBackgroundColor: [UIColor grayColor]];
    [_avatar setTextAlignment: NSTextAlignmentCenter];
    [_avatar setTextColor: [UIColor whiteColor]];
    [_avatar setFont: [UIFont systemFontOfSize: 20.0]];
    
    [_avatar.layer setCornerRadius: 0.5*50]; // table row height = 70;
    [_avatar.layer setMasksToBounds:YES];
}

- (void)initTickBox {
    _tickBox = [[UIImageView alloc] init];
    [_tickBox setContentMode: UIViewContentModeScaleAspectFill];
    [_tickBox setClipsToBounds: YES];
//    [_tickBox setBackgroundColor: [UIColor lightGrayColor]];
    [_tickBox.layer setCornerRadius: 0.5*30];
    [_tickBox.layer setMasksToBounds: YES];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self initTitle];
    [self initAvatar];
    [self initTickBox];
    [self.contentView addSubview: _tickBox];
    [self.contentView addSubview: _title];
    [self.contentView addSubview: _avatar];
    
//    [_tickBox setImage: [UIImage imageNamed: @"ic-none"]];
    [_tickBox setFrame: CGRectMake(10, 20, 30, 30)];
    [_avatar setFrame: CGRectMake(_tickBox.frame.origin.x + _tickBox.frame.size.width + 10, 10, 50, 50)];
    [_title setFrame: CGRectMake(_avatar.frame.origin.x + _avatar.frame.size.width + 10, _avatar.frame.origin.y, self.bounds.size.width - _avatar.frame.origin.x + _avatar.frame.size.width + 10, _avatar.frame.size.height)];
    
    return self;
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
    NICellObject *cellObject = object;
    ContactEntity *contact = cellObject.userInfo;
    [self.title setText:[NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName]];
    [self.avatar setText:[contact.contactList objectForKey:@"avatar"]];
    [self setAvatarColorWithTitle:self.avatar.text];
    if (contact.checked) {
        [self.tickBox setImage:[UIImage imageNamed:@"ic-tick"]];
    } else {
        [self.tickBox setImage:[UIImage imageNamed:@"ic-none"]];
    }
    return YES;
}

@end
