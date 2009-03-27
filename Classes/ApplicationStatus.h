//
//  ApplicationStatus.h
//  rpm_menubar
//
//  Created by David Smith on 2/27/09.
//  Copyright 2009 Cross Forward Consulting, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ApplicationStatus : NSObject {
	IBOutlet NSTextField *ui_name;
	IBOutlet NSTextField *cpu_field;	
	IBOutlet NSTextField *memory_field;
	IBOutlet NSTextField *response_time_field;
	IBOutlet NSTextField *throughput_field;
	IBOutlet NSTextField *db_field;
	
	IBOutlet NSView *view;
	
	NSInteger application_id;
	NSString* name;
	NSString* overview_url;
	NSString* license_key;
	
	NSString* cpu;
	NSInteger cpu_status;
	
	NSString* memory;
	NSInteger memory_status;
	
	NSString* response_time;
	NSInteger response_time_status;
	
	NSString* throughput;
	NSInteger throughput_status;
	
	NSString* db;
	NSInteger db_status;

}

- (IBAction)click:(id)sender;


-(void)set_threshold:(NSInteger)threshold for_field:(NSTextField*)field;
-(int)worst_value;

@property (nonatomic) NSInteger application_id;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* overview_url;
@property (nonatomic, retain) NSString* license_key;
@property (nonatomic, retain) NSString* cpu;
@property (nonatomic) NSInteger cpu_status;
@property (nonatomic, retain) NSString* memory;
@property (nonatomic) NSInteger memory_status;
@property (nonatomic, retain) NSString* response_time;
@property (nonatomic) NSInteger response_time_status;
@property (nonatomic, retain) NSString* throughput;
@property (nonatomic) NSInteger throughput_status;
@property (nonatomic, retain) NSString* db;
@property (nonatomic) NSInteger db_status;

-(NSView*)custom_view;

@end
