// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


@import WireExtensionComponents;
#import <zmessaging/zmessaging.h>


typedef NS_ENUM(NSUInteger, UserImageViewSize) {
    UserImageViewSizeFirst,
    UserImageViewSizeTiny = UserImageViewSizeFirst,
    UserImageViewSizeSmall,
    UserImageViewSizeNormal,
    UserImageViewSizeBig,
    UserImageViewSizeLast = UserImageViewSizeBig
};

@class UserImageView;

@protocol UserImageViewDelegate <NSObject>

@optional
- (void)userImageViewTouchUpInside:(UserImageView *)userImageView;

@end



@interface UserImageView : AvatarImageView <ZMUserObserver>

@property (nonatomic) id<ZMBareUser, ZMSearchableUser> user;
@property (nonatomic) BOOL shouldDesaturate;
@property (nonatomic) BOOL indicatorEnabled;
@property (nonatomic) BOOL borderColorMatchesAccentColor;

@property (nonatomic) UserImageViewSize suggestedImageSize;
@property (nonatomic, weak) id<UserImageViewDelegate> delegate;

- (instancetype)initWithMagicPrefix:(NSString *)magicPrefix;

@end

@interface UserImageView (Magic)
- (void)setupWithMagicPrefix:(NSString *)magicPrefix;
@end
