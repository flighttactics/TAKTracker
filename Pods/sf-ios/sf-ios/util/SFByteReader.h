//
//  SFByteReader.h
//  sf-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Default read byte order
 */
static CFByteOrder DEFAULT_READ_BYTE_ORDER = CFByteOrderBigEndian;

/**
 *  Read through byte data
 */
@interface SFByteReader : NSObject

/**
 *  Next byte index to read
 */
@property int nextByte;

/**
 *  Bytes to read
 */
@property (nonatomic, strong) NSData *bytes;

/**
 *  Byte order used to read, little or big endian
 */
@property (nonatomic) CFByteOrder byteOrder;

/**
 *  Initialize
 *
 *  @param bytes byte data
 *
 *  @return new byte reader
 */
-(instancetype) initWithData: (NSData *) bytes;

/**
 *  Initialize
 *
 *  @param bytes byte data
 *  @param byteOrder byte order
 *
 *  @return new byte reader
 */
-(instancetype) initWithData: (NSData *) bytes andByteOrder: (CFByteOrder) byteOrder;

/**
 *  Read a String from the provided number of bytes
 *
 *  @param num number of bytes to read
 *
 *  @return string value
 */
-(NSString *) readString: (int) num;

/**
 *  Read a single byte
 *
 *  @return byte
 */
-(NSNumber *) readByte;

/**
 *  Read Data with the provided number of bytes
 *
 *  @param num number of bytes to read
 *
 *  @return data value
 */
-(NSData *) readData: (int) num;

/**
 *  Read an integer (4 bytes)
 *
 *  @return integer
 */
-(NSNumber *) readInt;

/**
 *  Read a double (8 bytes)
 *
 *  @return double
 */
-(NSDecimalNumber *) readDouble;

@end
