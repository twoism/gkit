//
//  GRoute.m
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GRoute.h"
#import "RegexKitLite.h"

@implementation GRoute

@synthesize steps;

- (void)dealloc
{
	[steps release];
	[super dealloc];
}

// http://maps.google.com/maps?saddr=Atlanta,GA&daddr=Birmingham,AL&output=xml

+ (void)initialize {
	[self setDelegate:self];
	[self setBaseURL:[NSURL URLWithString:@"http://maps.google.com"]];
	[self setDefaultParams:[NSDictionary dictionaryWithObjectsAndKeys:
													@"kml",@"output",
													nil]];
	[self setFormat:HRDataFormatXML];
	/* Spoofing for Access */
	[self setHeaders:[NSDictionary dictionaryWithObject:@"http://iphone.local" forKey:@"Referer"]];
}

+ (id)getRouteFromLocation:(CLLocationCoordinate2D)from
								toLocation:(CLLocationCoordinate2D)to
							withDelegate:(id)delegate 
{
	NSString *toStr				= [NSString stringWithFormat:@"%f,%f",from.latitude,from.longitude];
	NSString *fromStr			= [NSString stringWithFormat:@"%f,%f",to.latitude,to.longitude];
	NSDictionary *d			= [NSDictionary dictionaryWithObjectsAndKeys:fromStr,@"saddr",toStr,@"daddr",nil];
	NSDictionary *opts	= [NSDictionary dictionaryWithObject:d forKey:@"params"];
	[self getPath:@"/maps" withOptions:opts object:delegate];
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
	NSString *coordinatesString = [[[resource valueForKeyPath:@"kml.Document.Placemark"] lastObject] valueForKeyPath:@"GeometryCollection.LineString.coordinates"];
	NSArray *coordsSplit = [coordinatesString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
	NSMutableArray *coordinates = [[NSMutableArray alloc] init];
	for (id item in coordsSplit) {
		[coordinates addObject:[item componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]];
	}
	GRoute *route = [[GRoute alloc] initWithArray:coordinates];
	[object performSelector:@selector(routeLoaded:) withObject:route];
	[route release];
}

- (id)initWithArray:(NSArray*)ar
{
	if(self = [super init]) {
		NSMutableArray *tmpSteps = [[NSMutableArray alloc] init];
		for (id item in ar) {
			if ([item count]>1) {
				CLLocation *c = [[CLLocation alloc] initWithLatitude:[[item objectAtIndex:0] floatValue] longitude:[[item objectAtIndex:1] floatValue]];
				NSLog(@"%@",c);
				[tmpSteps addObject:c];
			}
		}
		self.steps = [tmpSteps mutableCopy];
		[tmpSteps release];
	}
	return self;
}



@end
