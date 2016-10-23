//
//  DataRetriever.m
//  which
//
//  Created by Eduardo Ramos on 6/25/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface DataRetriever : NSObject 

@property (strong, nonatomic) EKEventStore *store;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *cardText;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) NSString *payperiodText;
@property (strong, nonatomic) NSString *dateText;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *shortText;


- (void)updateData;

+(DataRetriever*)sharedDataRetrieverSingleton;

-(void) accessToCalendarGrantedWithCalendar:(NSCalendar*)cal;

@end


