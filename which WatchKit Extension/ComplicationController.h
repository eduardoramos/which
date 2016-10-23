//
//  ComplicationController.h
//  WatchTest2 WatchKit Extension
//
//  Created by Eduardo on 10/13/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import <ClockKit/ClockKit.h>
#import "DataRetriever.h"


@interface ComplicationController : NSObject <CLKComplicationDataSource>

@property (retain, nonatomic) DataRetriever *retriever;

@end
