//
//  RpmMenu.h
//  rpm_menubar
//
//  Created by David Smith on 2/27/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesController.h"
#import "ApiHandler.h"

@class PreferencesController;
@class ApiHandler;

@interface RpmMenu : NSObject {
	IBOutlet NSView* view;
	
	IBOutlet NSTextField* updated_at;
	
	NSStatusItem *_statusItem;
	NSTimer *timer;
	
	///FDL
	PreferencesController *pref;
	ApiHandler *apiHandler;
	
}

-(void) updateStatus:(NSMutableArray*)applications;
-(void) setErrorStatus;
- (void) handleTimer: (NSTimer *) timer;
-(void)beginTimer;

@end
