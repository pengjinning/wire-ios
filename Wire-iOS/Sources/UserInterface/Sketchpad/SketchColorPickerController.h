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


#import <UIKit/UIKit.h>

@protocol SketchColorPickerControllerDelegate;



/// The color picker for the sketching
@interface SketchColorPickerController : UIViewController

@property (nonatomic, weak) id <SketchColorPickerControllerDelegate> delegate;
/// Contains @c UIColor objects
@property (nonatomic, copy) NSArray *sketchColors;
/// Constains @c NSNumber objects. Default is @6, @12, @18 as @c NSUInteger
@property (nonatomic, copy) NSArray *brushWidths;
@property (nonatomic, assign) NSUInteger selectedColorIndex;
/// Read only: Use the @c selectedColorIndex to change the selected color
@property (nonatomic, strong, readonly) UIColor *selectedColor;

/// Returns the current brush width for the given color
- (NSUInteger)brushWidthForColor:(UIColor *)color;

@end



@protocol SketchColorPickerControllerDelegate <NSObject>

- (void)sketchColorPickerController:(SketchColorPickerController *)controller changedSelectedColor:(UIColor *)color;

@end
