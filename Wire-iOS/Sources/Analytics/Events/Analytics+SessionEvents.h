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


#import <Foundation/Foundation.h>

#import "AnalyticsBase.h"
#import "ApplicationLaunchType.h"



@interface Analytics (SessionEvents)

- (void)tagAppLaunchWithType:(ApplicationLaunchType)type;

/// Tags manual sign in event
- (void)tagSignInTapped;

/// Tags manual sign in failure
- (void)tagSignInFailedWithReason:(NSString *)reason;

- (void)tagAuthenticationSucceeded;
- (void)tagAuthenticationFailedWithReason:(NSString *)reason;

- (void)tagApplicationError:(NSString *)error timeInSession:(NSTimeInterval)time;
- (void)tagAppException:(NSString *)error screen:(NSString *)screen timeInSession:(NSTimeInterval)time;

@end
