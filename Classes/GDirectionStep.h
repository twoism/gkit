//
//  GDirectionStep.h
//  GKit
//
//  Created by Christopher Burnett on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GDirectionStep : NSObject {
	NSNumber		*distanceInMeters;
	NSNumber		*durationInSeconds;
	CLLocationCoordinate2D	coordinate;
	NSString		*stepDescription;
}

@property(nonatomic,retain) NSNumber		*distanceInMeters;
@property(nonatomic,retain) NSNumber		*durationInSeconds;
@property(nonatomic,readwrite) CLLocationCoordinate2D	coordinate;
@property(nonatomic,retain) NSString		*stepDescription;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
