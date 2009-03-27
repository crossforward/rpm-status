//
//  main.m
//  rpm_menubar
//
//  Created by David Smith on 2/27/09.
//  Copyright Cross Forward Consulting, LLC 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RpmMenu.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];
	
    RpmMenu *menu = [[RpmMenu alloc] init];
    [NSApp setDelegate:menu];
    [NSApp run];
	
    [pool release];
    return EXIT_SUCCESS;
}
