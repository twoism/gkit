//
//  PhoneNumber.m
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GPhoneNumber.h"

@implementation GPhoneNumber

@synthesize number;

- (void)dealloc
{
	[number release];
	[super	dealloc];
}

- (id)initWithString:(NSString*)num
{
	if(self = [super init]) {
		self.number = num;
	}
	return self;
}
- (void)call
{
	NSString *url = [[NSString stringWithFormat: @"tel:%@", self.number] autorelease]; 
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
}

- (NSString*)description
{
	return self.number;
}

@end
