//
//  SFByteWriter.h
//  sf-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Default write byte order
 */
static CFByteOrder DEFAULT_WRITE_BYTE_ORDER = CFByteOrderBigEndian;

/**
 *  Write byte data
 */
@interface SFByteWriter : NSObject

/**
 *  Next byte index to write
 */
@property int nextByte;

/**
 *  Output stream to write bytes to
 */
@property (nonatomic, strong) NSOutputStream *os;

/**
 *  Byte order used to write, little or big endian
 */
@property (nonatomic) CFByteOrder byteOrder;

/**
 *  Initialize
 *
 *  @return new byte writer
 */
-(instancetype) init;

/**
 *  Initialize
 *
 *  @param byteOrder byte order
 *
 *  @return new byte writer
 */
-(instancetype) initWithByteOrder: (CFByteOrder) byteOrder;

/**
 *  Close the byte writer
 */
-(void) close;

/**
 *  Get the written byte data
 *
 *  @return byte data
 */
-(NSData *) data;

/**
 *  Get the current size in bytes written
 *
 *  @return bytes written
 */
-(int) size;

/**
 *  Write a string
 *
 *  @param value string
 */
-(void) writeString: (NSString *) value;

/**
 *  Write a byte
 *
 *  @param value byte
 */
-(void) writeByte: (NSNumber *) value;

/**
 *  Write data
 *
 *  @param data data
 */
-(void) writeData: (NSData *) data;

/**
 *  Write an integer
 *
 *  @param value integer
 */
-(void) writeInt: (NSNumber *) value;

/**
 *  Write a double
 *
 *  @param value double
 */
-(void) writeDouble: (NSDecimalNumber *) value;

@end
