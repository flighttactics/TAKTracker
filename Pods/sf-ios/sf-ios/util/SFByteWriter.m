//
//  SFByteWriter.m
//  sf-ios
//
//  Created by Brian Osborn on 5/28/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "SFByteWriter.h"

@implementation SFByteWriter

-(instancetype) init{
    self = [self initWithByteOrder:DEFAULT_WRITE_BYTE_ORDER];
    return self;
}

-(instancetype) initWithByteOrder: (CFByteOrder) byteOrder{
    self = [super init];
    if(self != nil){
        self.nextByte = 0;
        self.os = [[NSOutputStream alloc] initToMemory];
        [self.os open];
        self.byteOrder = byteOrder;
    }
    return self;
}

-(void) close{
    [self.os close];
}

-(NSData *) data{
    return [self.os propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
}

-(int) size{
    return self.nextByte;
}

-(void) writeString: (NSString *) value{
    NSData *data = [[NSData alloc] initWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [self.os write:[data bytes] maxLength:[value length]];
    self.nextByte += (int)[value length];
}

-(void) writeByte: (NSNumber *) value{
    uint8_t byte = [value intValue];
    NSData *data = [NSData dataWithBytes:&byte length:1];
    [self.os write:[data bytes]  maxLength:1];
    self.nextByte++;
}

-(void) writeData: (NSData *) data{
    [self.os write:[data bytes]  maxLength:data.length];
    self.nextByte += (int)data.length;
}

-(void) writeInt: (NSNumber *) value{
    
    uint32_t v = [value intValue];
    
    if(self.byteOrder == CFByteOrderBigEndian){
        v = CFSwapInt32HostToBig(v);
    }else{
        v = CFSwapInt32HostToLittle(v);
    }
    
    NSData *data = [NSData dataWithBytes:&v length:4];
    [self.os write:[data bytes]  maxLength:4];
    self.nextByte += 4;
}

-(void) writeDouble: (NSDecimalNumber *) value{
    
    union DoubleSwap {
        double v;
        uint64_t sv;
    } result;
    result.v = [value doubleValue];
    
    if(self.byteOrder == CFByteOrderBigEndian){
        result.sv = CFSwapInt64HostToBig(result.sv);
    }else{
        result.sv = CFSwapInt64HostToLittle(result.sv);
    }

    NSData *data = [NSData dataWithBytes:&result.sv length:8];
    [self.os write:[data bytes]  maxLength:8];
    self.nextByte += 8;
}

@end
