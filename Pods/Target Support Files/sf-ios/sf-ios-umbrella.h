#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SFExtendedGeometryCollection.h"
#import "sf-ios-Bridging-Header.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFCurve.h"
#import "SFCurvePolygon.h"
#import "SFGeometry.h"
#import "SFGeometryCollection.h"
#import "SFGeometryEnvelope.h"
#import "SFGeometryTypes.h"
#import "SFLine.h"
#import "SFLinearRing.h"
#import "SFLineString.h"
#import "SFMultiCurve.h"
#import "SFMultiLineString.h"
#import "SFMultiPoint.h"
#import "SFMultiPolygon.h"
#import "SFMultiSurface.h"
#import "SFPoint.h"
#import "SFPolygon.h"
#import "SFPolyhedralSurface.h"
#import "SFSurface.h"
#import "SFTIN.h"
#import "SFTriangle.h"
#import "sf_ios.h"
#import "SFCentroidCurve.h"
#import "SFCentroidPoint.h"
#import "SFCentroidSurface.h"
#import "SFDegreesCentroid.h"
#import "SFFiniteFilterTypes.h"
#import "SFGeometryFilter.h"
#import "SFPointFiniteFilter.h"
#import "SFByteReader.h"
#import "SFByteWriter.h"
#import "SFGeometryConstants.h"
#import "SFGeometryEnvelopeBuilder.h"
#import "SFGeometryPrinter.h"
#import "SFGeometryUtils.h"
#import "SFTextReader.h"
#import "SFEvent.h"
#import "SFEventQueue.h"
#import "SFEventTypes.h"
#import "SFSegment.h"
#import "SFShamosHoey.h"
#import "SFSweepLine.h"

FOUNDATION_EXPORT double sf_iosVersionNumber;
FOUNDATION_EXPORT const unsigned char sf_iosVersionString[];

