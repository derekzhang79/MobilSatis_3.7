//
//  CSVFileParser.h
//  MobilSatis
//
//  Created by Ata Cengiz on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVParser:NSObject {
	int fileHandle;
	int bufferSize;
	char delimiter;
	NSStringEncoding encoding;
}

-(id)init;
-(BOOL)openFile:(NSString*)fileName;
-(void)closeFile;
-(char)autodetectDelimiter;
-(char)delimiter;
-(void)setDelimiter:(char)newDelimiter;
-(void)setBufferSize:(int)newBufferSize;
-(NSMutableArray*)parseFile;
-(void)setEncoding:(NSStringEncoding)newEncoding;
@end
