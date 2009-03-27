//
//  ApplicationStatus.m
//  rpm_menubar
//
//  Created by David Smith on 2/27/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import "ApplicationStatus.h"


@implementation ApplicationStatus

@synthesize application_id, name, overview_url, license_key, cpu, cpu_status, memory, memory_status, response_time, response_time_status, throughput, throughput_status, db, db_status;

-(NSView*)custom_view {
	[NSBundle loadNibNamed:@"Application" owner:self];
	
	[ui_name setStringValue:name];
	
	[self set_threshold:cpu_status for_field:cpu_field];
	[cpu_field setStringValue:cpu];
	
	[self set_threshold:memory_status for_field:memory_field];
	[memory_field setStringValue:memory];
	
	[self set_threshold:response_time_status for_field:response_time_field];
	[response_time_field setStringValue:response_time];
	
	[self set_threshold:throughput_status for_field:throughput_field];
	[throughput_field setStringValue:throughput];
	
	[self set_threshold:db_status for_field:db_field];
	[db_field setStringValue:db];
	
	return view;
}

-(int)worst_value{
	int worst = cpu_status;
	if(memory_status > worst) {
		worst = memory_status;
	}
	if(response_time_status > worst) {
		worst = response_time_status;
	}
	if(throughput_status > worst) {
		worst = throughput_status;
	}
	if(db_status > worst) {
		worst = db_status;
	}
	return worst;
}

- (IBAction)click:(id)sender {
	NSURL *url = [NSURL URLWithString:overview_url];
	[[NSWorkspace sharedWorkspace] openURL:url];
}


-(void)set_threshold:(NSInteger)threshold for_field:(NSTextField*)field {
	if (threshold == 1) {
		[field setBackgroundColor:[NSColor greenColor]];
	} else if(threshold == 2) {
		[field setBackgroundColor:[NSColor yellowColor]];
	} else {
		[field setBackgroundColor:[NSColor redColor]];
	}
}


@end
