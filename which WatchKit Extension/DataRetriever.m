//
//  DataRetriever.m
//  which
//
//  Created by Eduardo Ramos on 6/25/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>

#import "DataRetriever.h"

@implementation DataRetriever

static DataRetriever* _sharedDataRetriever = nil;

+(DataRetriever*)sharedDataRetrieverSingleton
{
    @synchronized([DataRetriever class])
    {
        if(_sharedDataRetriever == nil)
            _sharedDataRetriever = [[super allocWithZone:NULL] init];
    }
    return _sharedDataRetriever;
}

- (EKEventStore*)store {
    if (!_store) {
        _store = [[EKEventStore alloc] init];
    }
    return _store;
}

-(void) accessToCalendarGrantedWithCalendar:(NSCalendar*)cal {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EventsUpdated" object:self];
}

- (void)updateData {
    NSLog(@"updateData called");
    // This method is called when watch view controller is about to be visible to user
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:currentDate];
    NSInteger day = [components day];
    
    NSString * myString;
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self setTextColor:[UIColor whiteColor]];

    if ((day>10) && (day<=26))
    {
        self.text = @"Gold Card";
        self.shortText = @"Gold";
        myString = @"(11-26th)";
        [self setImageName:@"Gold.png"];
    }
    else
    {
        self.text = @"Blue Card";
        self.shortText = @"Blue";
        myString = @"(27-10th)";
        [self setImageName:@"Blue.png"];
    }
    
    myString = [NSString stringWithFormat:@"%@",myString];
    
    [self setCardText:myString];

    [self.store reset];
    
    [self accessToCalendarGrantedWithCalendar:cal];
    return;
    
}

@end
