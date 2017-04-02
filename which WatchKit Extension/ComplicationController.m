//
//  ComplicationController.m
//  WatchTest2 WatchKit Extension
//
//  Created by Eduardo on 10/13/16.
//  Copyright © 2016 Eduardo Ramos. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

- (DataRetriever*)retriever {
    if (!_retriever) {
        _retriever = [DataRetriever sharedDataRetrieverSingleton];
    }
    return _retriever;
}

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionNone);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry

    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSLog(@"getCurrentTimelineEntryForComplication");

    [self.retriever updateData];
    
    if (complication.family == CLKComplicationFamilyUtilitarianSmall){
    CLKSimpleTextProvider* textProvider;
    textProvider = [[CLKSimpleTextProvider alloc] init];
    textProvider.text = self.retriever.text;
    textProvider.shortText = self.retriever.shortText;

    NSLog(@"text %@ shortText %@",self.retriever.text, self.retriever.shortText);

    CLKComplicationTemplateUtilitarianSmallFlat * template;
    template = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];

    template.textProvider = textProvider;
    
    CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:currentDate complicationTemplate:template];

    handler(entry);
    }
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getLocalizableSampleTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    
    if (complication.family == CLKComplicationFamilyUtilitarianSmall){
        // This method will be called once per supported complication, and the results will be cached
        CLKComplicationTemplateUtilitarianSmallFlat * template;
        template = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
        
        CLKSimpleTextProvider* textProvider;
        textProvider = [[CLKSimpleTextProvider alloc] init];
        textProvider.text = @"Which Card?";
        textProvider.shortText = @"Which?";
        
        template.textProvider = textProvider;
        handler(template);
    }
}

- (void)refreshComplications {
    CLKComplicationServer *server = [CLKComplicationServer sharedInstance];
    for(CLKComplication *complication in server.activeComplications) {
        [server reloadTimelineForComplication:complication];
    }
}

@end
