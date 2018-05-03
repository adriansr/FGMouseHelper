//
//  AppDelegate.m
//  FGMouseHelper
//
//  Created by Adrian Serrano on 03/05/2018.
//  Copyright © 2018 Elastic. All rights reserved.
//

#import "AppDelegate.h"
#include <ApplicationServices/ApplicationServices.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

CGPoint getCursor() {
    CGEventRef event = CGEventCreate(NULL);
    CGPoint location = CGEventGetLocation(event);
    return location;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self->mouseMonitor = nil;
    self->keysMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged handler: ^void(NSEvent*ev){
        [self onKeyboardEvent:ev];
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [NSEvent removeMonitor:self->keysMonitor];
}

- (void)onKeyboardEvent:(NSEvent*)ev {
    bool isCaps = ev.modifierFlags & NSAlphaShiftKeyMask;
    if (!isCaps) {
        if (self->mouseMonitor != nil) {
            [NSEvent removeMonitor:self->mouseMonitor];
            self->mouseMonitor = nil;
        }
    } else {
        if (self->mouseMonitor == nil) {
            fixedY = getCursor().y;
            minY = fixedY - 5.0;
            maxY = fixedY + 5.0;
            self->mouseMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskMouseMoved handler: ^void(NSEvent*ev){
                [self onMouseEvent:ev];
            }];
        }
    }
}

- (void)onMouseEvent:(NSEvent *)ev {
    CGPoint location = getCursor();
    bool limit = false;
    if (location.y < self->minY) {
        location.y = self->fixedY;
        limit = true;
    } else if (location.y > maxY) {
        location.y = self->fixedY;
        limit = true;
    }
    if (limit) {
        CGError err = CGWarpMouseCursorPosition(location);
        if (err) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            NSString *msg =[NSString stringWithFormat:@"error code %d", err];
            [alert setMessageText:msg];
            [alert setInformativeText:msg];
            [alert runModal];
        }
    }
}
@end
