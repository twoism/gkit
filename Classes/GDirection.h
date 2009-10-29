//
//  GDirection.h
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <HTTPRiot/HTTPRiot.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GDirection : HRRestModel {
	NSNumber *distanceInMeters;
	NSNumber *durationInSeconds;
	NSArray  *routes;
}

@property (nonatomic, retain) NSNumber *distanceInMeters;
@property (nonatomic, retain) NSNumber *durationInSeconds;
@property (nonatomic, retain) NSArray  *routes;

+ (id)getDirectionsFromLocation:(CLLocationCoordinate2D)from
										 toLocation:(CLLocationCoordinate2D)to
									 withDelegate:(id)delegate;

- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
