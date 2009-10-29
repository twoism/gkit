//
//  GLocation.m
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "GLocation.h"
#include <HTTPRiot/HTTPRiot.h>
#import <CoreLocation/CoreLocation.h>
#import "PhoneNumber.h"

#define GMAPS_KEY @"ABQIAAAAzRoZzKYM5qKOqJfF5rV9XBSdG0_H5fikhlv-IEqZhBC4z1KyBxQXs61Dpo8XUzt1tb1DA5qQ7sk6RQ"
#define GMAPS_SIG @"582c1116317355adf613a6a843f19ece"

@implementation GLocation

@synthesize name, city, country, coordinate, region, address, phone;

- (void)dealloc
{
	[name			release];
	[city			release];
	[country	release];
	[region		release];
	[address	release];
	[phone		release];
	[super		dealloc];
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	if(self = [super init]) {
		self.name			= [dictionary valueForKey:@"titleNoFormatting"];
		self.city			= [dictionary valueForKey:@"city"];
		self.country	= [dictionary valueForKey:@"country"];
		self.region		= [dictionary valueForKey:@"region"];
		self.address	= [dictionary valueForKey:@"streetAddress"];
		self.phone		= [[PhoneNumber alloc] initWithString:[[[dictionary valueForKey:@"phoneNumbers"] objectAtIndex:0] valueForKey:@"number"]];
		
		CLLocationCoordinate2D c;
		c.latitude			= [[dictionary valueForKey:@"lat"] floatValue];
		c.longitude			= [[dictionary valueForKey:@"lng"] floatValue];
		self.coordinate	= c;
		
	}
	return self;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<%@ %@ %@ %@ %f %f>",self.name,self.address, self.city, self.region, self.coordinate.latitude, self.coordinate.longitude];
}

+ (void)initialize {
	[self setDelegate:self];
	[self setBaseURL:[NSURL URLWithString:@"http://www.google.com/uds"]];
	[self setDefaultParams:[NSDictionary dictionaryWithObjectsAndKeys:
													 @"0",@"context",
													 @"0",@"lstkp",
													 @"large",@"rsz",
													 @"en",@"hl",
													 @".com",@"gss",
													 @"0",@"start",
													 @"1.0",@"v",
													GMAPS_KEY,@"key",
													GMAPS_SIG,@"sig",
													@"20",@"num",
													@"1",@"radius",
													 nil]];
	/* Spoofing for Access */
	[self setHeaders:[NSDictionary dictionaryWithObject:@"http://iphone.local" forKey:@"Referer"]];
}

+ (id)getLocalResultsForLocation:(CLLocationCoordinate2D)loc 
											 withQuery:(NSString*)query 
										withDelegate:(id)delegate 
{
	NSDictionary *d			= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f,%f",loc.latitude,loc.longitude],@"sll",query,@"q",nil];
	NSDictionary *opts	= [NSDictionary dictionaryWithObject:d forKey:@"params"];
	[self getPath:@"/GlocalSearch" withOptions:opts object:delegate];
	return self;
}


#pragma mark - HRRequestOperation Delegates
+ (void)restConnection:(NSURLConnection *)connection 
			didFailWithError:(NSError *)error 
								object:(id)object 
{
	NSLog(@"%@",[error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
			 didReceiveError:(NSError *)error 
							response:(NSHTTPURLResponse *)response 
								object:(id)object 
{
	NSLog(@"%@",[error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
	didReceiveParseError:(NSError *)error 
					responseBody:(NSString *)string 
{
	NSLog(@"%@",[error localizedDescription]);
}

+ (void)restConnection:(NSURLConnection *)connection 
		 didReturnResource:(id)resource 
								object:(id)object 
{
	NSMutableArray *locations = [[[NSMutableArray alloc] init] autorelease];
	for(id item in [[resource valueForKey:@"responseData"] valueForKey:@"results"]) {
		[locations addObject:[[GLocation alloc] initWithDictionary:item]];
	}
	[object performSelector:@selector(locationsLoaded:) withObject:locations];
}


@end
