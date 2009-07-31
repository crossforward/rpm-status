//
//  ApplicationStatusView.m
//  rpm_menubar
//
//  Created by Kris Collins on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ApplicationStatusView.h"


@implementation ApplicationStatusView


- (void)drawRect:(NSRect)frameRect {
	[NSGraphicsContext saveGraphicsState];
	
	[[NSColor colorWithCalibratedRed:1.64 green:0.66 blue:0.71 alpha:1.0] set];
	NSRectFill([self bounds]);
}	

@end
