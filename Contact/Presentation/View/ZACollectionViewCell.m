//
//  ZACollectionViewCell.m
//  Contact
//
//  Created by Hiên on 8/8/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZACollectionViewCell.h"

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
    [self.contentView addSubview: _avatar];
    [_avatar setFrame: CGRectMake(10, 0, 50, 50)]; // cell frame height = 70
    [self setBackgroundColor: [UIColor clearColor]];
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
    NSLog(@"Collection View Update");
    NICollectionViewCellObject *cellObject = object;
    ContactEntity *contact = cellObject.userInfo;
    [self.avatar setText:[contact.contactList objectForKey:@"avatar"]];
    [self setAvatarColorWithTitle:self.avatar.text];
    return YES;
}

@end
