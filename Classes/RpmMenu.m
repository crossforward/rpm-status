//
//  RpmMenu.m
//  rpm_menubar
//
//  Created by David Smith on 2/27/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import "RpmMenu.h"
#import "ApiHandler.h"
#import "ApplicationStatus.h"
#import "AGKeychain.h"
#import "PreferencesController.h"


@implementation RpmMenu
- (void) openWebsite:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://th30z.netsons.org"];
	[[NSWorkspace sharedWorkspace] openURL:url];
	[url release];
}

- (void) openFinder:(id)sender {
	[[NSWorkspace sharedWorkspace] launchApplication:@"Finder"];
}

- (void) actionQuit:(id)sender {
	[NSApp terminate:sender];
}

- (void) actionPreferences:(id)sender {
	PreferencesController* pref = [[PreferencesController alloc] init];
	[pref showWindow:self];
}

-(void) setErrorStatus {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	[updated_at setStringValue:@"Unable to connect/authenticate."];
	
	// Add To Items
	// Add Header
	menuItem = [[NSMenuItem alloc] init];
	[menuItem setView:view];
	[menuItem setTarget:self];
	[menu addItem:menuItem];
	
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	
	// Add Preferences Action
	menuItem = [menu addItemWithTitle:@"Preferences"
							   action:@selector(actionPreferences:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Set Credentials for RPM"];
	[menuItem setTarget:self];
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Click to Quit this App"];
	[menuItem setTarget:self];
	
	[_statusItem setMenu:menu];
	
	[_statusItem setImage:[NSImage imageNamed:@"loading"]];
	
}

-(void) updateStatus:(NSMutableArray*)applications {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	NSDate *date =[NSDate date];
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = kCFDateFormatterShortStyle;
	df.timeStyle = kCFDateFormatterMediumStyle;
	[updated_at setStringValue:[@"Updated: " stringByAppendingString:[df stringFromDate:date]]];
	[df release];
	
	
	// Add To Items
	// Add Header
	menuItem = [[NSMenuItem alloc] init];
	[menuItem setView:view];
	[menuItem setTarget:self];
	[menu addItem:menuItem];
	
	int worst_application = 1;
	for(int i = 0 ; i < [applications count]; i++ ){
		ApplicationStatus* as = ((ApplicationStatus*)[applications objectAtIndex:i]);
		menuItem = [[NSMenuItem alloc] init];
		[menuItem setView:[as custom_view]];
		[menuItem setTarget:self];
		[menu addItem:menuItem];
		if ([as worst_value] > worst_application) {
			worst_application = [as worst_value];			
		}
	}

	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	
	// Add Preferences Action
	menuItem = [menu addItemWithTitle:@"Preferences"
							   action:@selector(actionPreferences:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Set Credentials for RPM"];
	[menuItem setTarget:self];
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Click to Quit this App"];
	[menuItem setTarget:self];
	
	[_statusItem setMenu:menu];
	
	if(worst_application == 1) {
		[_statusItem setImage:[NSImage imageNamed:@"green"]];
	}
	if(worst_application == 2) {
		[_statusItem setImage:[NSImage imageNamed:@"yellow"]];
	}
	if(worst_application == 3) {
		[_statusItem setImage:[NSImage imageNamed:@"red"]];
	}
	
}

- (void) handleTimer: (NSTimer *) timer{
	[[[ApiHandler alloc] init] getData:self];
}


- (NSMenu *) createMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	// Add To Items
	menuItem = [menu addItemWithTitle:@"Loading..."
							   action:nil
						keyEquivalent:@""];
	[menuItem setTarget:self];
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];

	// Add Preferences Action
	menuItem = [menu addItemWithTitle:@"Preferences"
							   action:@selector(actionPreferences:)
						keyEquivalent:@"P"];
	[menuItem setToolTip:@"Set Credentials for RPM"];
	[menuItem setTarget:self];
	
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Click to Quit this App"];
	[menuItem setTarget:self];
	
	return menu;
}


- (void) applicationDidFinishLaunching:(NSNotification *)notification {
	
	timer = [NSTimer scheduledTimerWithTimeInterval: 60
											 target: self
										   selector: @selector(handleTimer:)
										   userInfo: nil
											repeats: YES];
	
	[NSBundle loadNibNamed:@"Header" owner:self];
	
	NSMenu *menu = [self createMenu];
	_statusItem = [[[NSStatusBar systemStatusBar]
					statusItemWithLength:NSSquareStatusItemLength] retain];
	[_statusItem setMenu:menu];
	[_statusItem setLength:23];
	[_statusItem setHighlightMode:YES];
	[_statusItem setToolTip:@"RPM Status"];
	[_statusItem setImage:[NSImage imageNamed:@"loading"]];
	[[[ApiHandler alloc] init] getData:self];
	
	
	if(![AGKeychain checkForExistanceOfKeychainItem:@"rpm_key"	withItemKind:@"rpm_key" forUsername:@"rpm_key"]) {
		PreferencesController* pref = [[PreferencesController alloc] init];
		[pref showWindow:self];
	}
}

@end
