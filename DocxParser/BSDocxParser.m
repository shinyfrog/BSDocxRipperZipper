//
//  BSDocxParser.m
//  DocxParser
//
//  Created by Brad Slayter on 11/5/13.
//  Copyright (c) 2013 Brad Slayter. All rights reserved.
//

#import "BSDocxParser.h"

@implementation BSDocxParser

-(id) initWithFileURL:(NSURL *)fileURL {
    if ((self = [super init])) {
        self.fileURL = fileURL;
    }
    return self;
}

-(void) loadDocument {
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:self.fileURL];
    NSError *error;
    _xmlDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    if (!self.xmlDoc) {
        NSLog(@"Couldn't open");
        return;
    }
    
    //NSLog(@"%@", self.xmlDoc.rootElement);
    finalString = @"";
    [self loadString];
}

-(void) loadString {
    GDataXMLElement *body = [[self.xmlDoc.rootElement elementsForName:@"w:body"] objectAtIndex:0];
    NSArray *paragraphs = [body elementsForName:@"w:p"];
    for (GDataXMLElement *paragraph in paragraphs) {
        NSLog(@"Found a paragraph!");
        
        NSArray *runs = [paragraph elementsForName:@"w:r"];
        for (GDataXMLElement *run in runs) {
            NSLog(@"Found a run!");
            GDataXMLElement *runTextElem = [[run elementsForName:@"w:t"] objectAtIndex:0];
            if (runTextElem)
                finalString = [finalString stringByAppendingString:runTextElem.stringValue];
        }
        
        finalString = [finalString stringByAppendingString:@"\n"];
    }
    
    NSLog(@"%@", finalString);
}

-(NSString *) getFinalString {
    return finalString;
}

@end
