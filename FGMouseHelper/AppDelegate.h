//
//  AppDelegate.h
//  FGMouseHelper
//
//  Created by Adrian Serrano on 03/05/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    id keysMonitor;
    id mouseMonitor;
    CGFloat fixedY, minY, maxY;
}

- (void)onKeyboardEvent:(NSEvent*)ev;
- (void)onMouseEvent:(NSEvent*)ev;
@end

