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
	

	

 
	NSImageView *whiteRoundedRect=[[NSImageView alloc] initWithFrame:NSMakeRect(8, 0, 161, 28)];
	[whiteRoundedRect setImage:[NSImage  imageNamed:@"whiteBox.png" ]];
	[view addSubview:whiteRoundedRect];
	
	 statusBubble=[[NSImageView alloc] initWithFrame:NSMakeRect(148, 6, 15, 15)];
	[statusBubble setImage:[NSImage  imageNamed:@"greenAlert.png" ]];
	[view addSubview:statusBubble];
	
	cpuStatus=[[NSImageView alloc] initWithFrame:NSMakeRect(166, 0, 76, 28)];
	[cpuStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
	[view addSubview:cpuStatus];
	
	memStatus=[[NSImageView alloc] initWithFrame:NSMakeRect(246, 0, 76, 28)];
	[memStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
	[view addSubview:memStatus];
	
	respStatus=[[NSImageView alloc] initWithFrame:NSMakeRect(326, 0, 76, 28)];
	[respStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
	[view addSubview:respStatus];
	
	throughStatus=[[NSImageView alloc] initWithFrame:NSMakeRect(406, 0, 76, 28)];
	[throughStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
	[view addSubview:throughStatus];
	
	dbStatus=[[NSImageView alloc] initWithFrame:NSMakeRect(486, 0, 76, 28)];
	[dbStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
	[view addSubview:dbStatus];
	
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
	
	[view addSubview:ui_name];
	[view addSubview:cpu_field];
	[view addSubview:memory_field];
	[view addSubview:response_time_field];
	[view addSubview:db_field];
	[view addSubview:throughput_field];
	

	
	//[view setBackgroundColor:[NSColor grayColor]];
	
	
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
	
	if(worst==3) 	[statusBubble setImage:[NSImage  imageNamed:@"redAlert.png" ]];
	else if(worst==2) 	[statusBubble setImage:[NSImage  imageNamed:@"yellowAlert.png" ]];
	else if(worst==1) 	[statusBubble setImage:[NSImage  imageNamed:@"greenAlert.png" ]];

	
	return worst;
}

- (IBAction)click:(id)sender {
	NSURL *url = [NSURL URLWithString:overview_url];
	[[NSWorkspace sharedWorkspace] openURL:url];
}


-(void)set_threshold:(NSInteger)threshold for_field:(NSTextField*)field {
	if (threshold == 1) 
	{
		if([field isEqualTo:cpu_field]) [cpuStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
		else if([field isEqualTo:memory_field]) [memStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
		else if([field isEqualTo:response_time_field]) [respStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
		else if([field isEqualTo:throughput_field]) [throughStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
		else if([field isEqualTo:db_field]) [dbStatus setImage:[NSImage  imageNamed:@"greenBox.png" ]];
		
		//[field setBackgroundColor:[NSColor greenColor]];
	} 
	else if(threshold == 2) 
	{
		if([field isEqualTo:cpu_field]) [cpuStatus setImage:[NSImage  imageNamed:@"yellowBox.png" ]];
		else if([field isEqualTo:memory_field]) [memStatus setImage:[NSImage  imageNamed:@"yellowBox.png" ]];
		else if([field isEqualTo:response_time_field]) [respStatus setImage:[NSImage  imageNamed:@"yellowBox.png" ]];
		else if([field isEqualTo:throughput_field]) [throughStatus setImage:[NSImage  imageNamed:@"yellowBox.png" ]];
		else if([field isEqualTo:db_field]) [dbStatus setImage:[NSImage  imageNamed:@"yellowBox.png" ]];
	} 
	else 
	{
		if([field isEqualTo:cpu_field]) [cpuStatus setImage:[NSImage  imageNamed:@"redBox.png" ]];
		else if([field isEqualTo:memory_field]) [memStatus setImage:[NSImage  imageNamed:@"redBox.png" ]];
		else if([field isEqualTo:response_time_field]) [respStatus setImage:[NSImage  imageNamed:@"redBox.png" ]];
		else if([field isEqualTo:throughput_field]) [throughStatus setImage:[NSImage  imageNamed:@"redBox.png" ]];
		else if([field isEqualTo:db_field]) [dbStatus setImage:[NSImage  imageNamed:@"redBox.png" ]];
	}
}


@end
