//
//  GLocation.h
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class PhoneNumber;

@interface GLocation : HRRestModel<MKAnnotation> {
	NSString		*name;
	NSString		*city;
	NSString		*country;
	PhoneNumber *phone;
	NSString		*region;
	NSString		*address;
	CLLocationCoordinate2D coordinate;
}

@property(nonatomic,retain)			NSString *name;
@property(nonatomic,retain)			NSString *city;
@property(nonatomic,retain)			NSString *country;
@property(nonatomic,retain)			NSString *region;
@property(nonatomic,retain)			NSString *address;
@property(nonatomic,retain)			PhoneNumber *phone;
@property(nonatomic,readwrite)	CLLocationCoordinate2D coordinate;

+ (id)getLocalResultsForLocation:(CLLocationCoordinate2D)loc 
											 withQuery:(NSString*)query 
										withDelegate:(id)delegate;

@end
