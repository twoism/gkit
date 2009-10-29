//
//  PhoneNumber.h
//  GKit
//
//  Created by Christopher Burnett on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumber : NSObject {
	NSString *number;
}
@property(nonatomic,retain) NSString *number;

- (id)initWithString:(NSString*)num;
- (void)call;

@end
