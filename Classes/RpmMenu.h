//
//  RpmMenu.h
//  rpm_menubar
//
//  Created by David Smith on 2/27/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RpmMenu : NSObject {
	IBOutlet NSView* view;
	
	IBOutlet NSTextField* updated_at;
	
	NSStatusItem *_statusItem;
	NSTimer *timer;
}

-(void) updateStatus:(NSMutableArray*)applications;
-(void) setErrorStatus;

@end
