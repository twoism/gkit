//
//  GDirection.m
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GDirection.h"
#import "GDirectionStep.h"

#define GMAPS_KEY @"ABQIAAAAzRoZzKYM5qKOqJfF5rV9XBSdG0_H5fikhlv-IEqZhBC4z1KyBxQXs61Dpo8XUzt1tb1DA5qQ7sk6RQ"
#define GMAPS_SIG @"582c1116317355adf613a6a843f19ece"

@implementation GDirection

@synthesize distanceInMeters, durationInSeconds, routes;

- (void)dealloc
{
	[routes release];
	[distanceInMeters release];
	[durationInSeconds release];
	[super dealloc];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"dist: %@ dur: %@ :: %@",self.distanceInMeters,self.durationInSeconds,self.routes];
}

+ (void)initialize {
	[self setDelegate:self];
	[self setBaseURL:[NSURL URLWithString:@"http://maps.google.com/maps"]];
	[self setDefaultParams:[NSDictionary dictionaryWithObjectsAndKeys:
													GMAPS_KEY,@"key",
													@"jsapi",@"mapclient",
													@"d",@"dirflag",
													@"pt",@"doflag",
													@"json",@"output",
													nil]];
	
	/* Spoofing for Access */
	[self setHeaders:[NSDictionary dictionaryWithObject:@"http://iphone.local" forKey:@"Referer"]];
}


+ (id)getDirectionsFromLocation:(CLLocationCoordinate2D)from
										 toLocation:(CLLocationCoordinate2D)to
									 withDelegate:(id)delegate 
{
	NSString *query			= [NSString stringWithFormat:@"from: %f,%f to: %f,%f",from.latitude,from.longitude,to.latitude,to.longitude];
	NSDictionary *d			= [NSDictionary dictionaryWithObjectsAndKeys:query,@"q",nil];
	NSDictionary *opts	= [NSDictionary dictionaryWithObject:d forKey:@"params"];
	[self getPath:@"/nav" withOptions:opts object:delegate];
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
	NSDictionary *directions = [resource valueForKey:@"Directions"];
	GDirection *d = [[GDirection alloc] initWithDictionary:directions];
	[object performSelector:@selector(directionsLoaded:) withObject:d];
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	if(self = [super init]) {
		self.distanceInMeters = [NSNumber numberWithInt:[[[dictionary valueForKey:@"Distance"] valueForKey:@"meters"] intValue]];
		self.durationInSeconds = [NSNumber numberWithInt:[[[dictionary valueForKey:@"Duration"] valueForKey:@"seconds"] intValue] ];
		NSMutableArray *steps = [[[NSMutableArray alloc] init] autorelease];
		NSArray *stepAr = [[dictionary valueForKey:@"Routes"] valueForKey:@"Steps"];
		for (id route in [stepAr objectAtIndex:0]) {
			GDirectionStep *s = [[GDirectionStep alloc] initWithDictionary:route];
			[steps addObject:s];
		}
		self.routes = steps;
	}
	return self;
}




@end
