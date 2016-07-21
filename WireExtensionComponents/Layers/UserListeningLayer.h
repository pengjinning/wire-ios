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


#import <QuartzCore/QuartzCore.h>

#import "AnimatedLayer.h"



@interface UserListeningLayer : CALayer <AnimatedLayer>

/// Default is 1.05
@property (nonatomic, assign) CGFloat cicleContentScale;
@property (nonatomic, strong) id value;

#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIColor *circleColor;
#else
@property (nonatomic, strong) NSColor *circleColor;
#endif

#if TARGET_OS_IPHONE
+ (instancetype)userListeningLayerWithCircleColor:(UIColor *)ringColor;
#else
+ (instancetype)userListeningLayerWithCircleColor:(NSColor *)ringColor;
#endif

@end

@interface UserListeningLayer (VoiceGain)

- (void)setVoiceGain:(CGFloat)gain;

@end
