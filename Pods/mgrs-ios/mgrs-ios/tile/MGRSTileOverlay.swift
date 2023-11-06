//
//  MGRSTileOverlay.swift
//  mgrs-ios
//
//  Created by Brian Osborn on 9/2/22.
//

import MapKit
import grid_ios

/**
 * MGRS Tile Overlay
 */
public class MGRSTileOverlay: MKTileOverlay {
    
    /**
     * Tile width
     */
    public var tileWidth: Int
    
    /**
     * Tile height
     */
    public var tileHeight: Int
    
    /**
     * Grids
     */
    public var grids: Grids
    
    /**
     * Create a tile provider with Grid Zone Designator grids
     *
     * @return tile provider
     */
    public static func createGZD() -> MGRSTileOverlay {
        return createGZD(TileUtils.tileLength())
    }

    /**
     * Create a tile provider with Grid Zone Designator grids
     *
     * @param tileLength tile length
     * @return tile provider
     */
    public static func createGZD(_ tileLength: Int) -> MGRSTileOverlay {
        return createGZD(tileLength, tileLength)
    }

    /**
     * Create a tile provider with Grid Zone Designator grids
     *
     * @param tileWidth  tile width
     * @param tileHeight tile height
     * @return tile provider
     */
    public static func createGZD(_ tileWidth: Int, _ tileHeight: Int) -> MGRSTileOverlay {
        return MGRSTileOverlay(tileWidth, tileHeight, Grids.createGZD())
    }
    
    /**
     * Initialize
     *
     * @param context app context
     */
    public init() {
        let tileLength = TileUtils.tileLength()
        self.tileWidth = tileLength
        self.tileHeight = tileLength
        self.grids = Grids()
        super.init(urlTemplate: nil)
    }

    /**
     * Initialize
     *
     * @param types   grids types to enable
     */
    public init(_ types: [GridType]) {
        let tileLength = TileUtils.tileLength()
        self.tileWidth = tileLength
        self.tileHeight = tileLength
        self.grids = Grids(types)
        super.init(urlTemplate: nil)
    }

    /**
     * Initialize
     *
     * @param grids   grids
     */
    public init(_ grids: Grids) {
        let tileLength = TileUtils.tileLength()
        self.tileWidth = tileLength
        self.tileHeight = tileLength
        self.grids = grids
        super.init(urlTemplate: nil)
    }

    /**
     * Initialize
     *
     * @param tileLength tile width and height
     */
    public init(_ tileLength: Int) {
        self.tileWidth = tileLength
        self.tileHeight = tileLength
        self.grids = Grids()
        super.init(urlTemplate: nil)
    }
    
    /**
     * Initialize
     *
     * @param tileLength tile width and height
     * @param types      grids types to enable
     */
    public init(_ tileLength: Int, _ types: [GridType]) {
        self.tileWidth = tileLength
        self.tileHeight = tileLength
        self.grids = Grids(types)
        super.init(urlTemplate: nil)
    }
    
    /**
     * Initialize
     *
     * @param tileLength tile width and height
     * @param grids      grids
     */
    public init(_ tileLength: Int, _ grids: Grids) {
        self.tileWidth = tileLength
        self.tileHeight = tileLength
        self.grids = grids
        super.init(urlTemplate: nil)
    }
    
    /**
     * Initialize
     *
     * @param tileWidth  tile width
     * @param tileHeight tile height
     */
    public init(_ tileWidth: Int, _ tileHeight: Int) {
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
        self.grids = Grids()
        super.init(urlTemplate: nil)
    }
    
    /**
     * Initialize
     *
     * @param tileWidth  tile width
     * @param tileHeight tile height
     * @param types      grids types to enable
     */
    public init(_ tileWidth: Int, _ tileHeight: Int, _ types: [GridType]) {
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
        self.grids = Grids(types)
        super.init(urlTemplate: nil)
    }
    
    /**
     * Initialize
     *
     * @param tileWidth  tile width
     * @param tileHeight tile height
     * @param grids      grids
     */
    public init(_ tileWidth: Int, _ tileHeight: Int, _ grids: Grids) {
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
        self.grids = grids
        super.init(urlTemplate: nil)
    }
    
    public override func url(forTilePath path: MKTileOverlayPath) -> URL {
        return URL(fileURLWithPath: "")
    }
    
    public override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in

            var tileData: Data? = tile(path.x, path.y, path.z)
            
            if tileData == nil {
                tileData = Data()
            }
            result(tileData, nil)
            
        }
        
    }
    
    /**
     * Get the grid
     *
     * @param type grid type
     * @return grid
     */
    public func grid(_ type: GridType) -> Grid {
        return grids.grid(type)
    }

    /**
     * Get the Global Area Reference System coordinate for the location coordinate in five
     * minute precision
     *
     * @param coordinate location
     * @return MGRS coordinate
     */
    public func coordinate(_ coordinate: CLLocationCoordinate2D) -> String {
        return mgrs(coordinate).coordinate()
    }

    /**
     * Get the Global Area Reference System coordinate for the MapKit map point in five
     * minute precision
     *
     * @param point MapKit map point
     * @return MGRS coordinate
     */
    public func coordinate(_ point: MKMapPoint) -> String {
        return coordinate(TileUtils.toCoordinate(point))
    }
    
    /**
     * Get the Global Area Reference System coordinate for the location coordinate in the
     * zoom level precision
     *
     * @param coordinate location
     * @param zoom   zoom level precision
     * @return MGRS coordinate
     */
    public func coordinate(_ coordinate: CLLocationCoordinate2D, _ zoom: Int) -> String {
        return self.coordinate(coordinate, precision(zoom))
    }

    /**
     * Get the Global Area Reference System coordinate for the MapKit map point in the
     * zoom level precision
     *
     * @param point MapKit map point
     * @param zoom   zoom level precision
     * @return MGRS coordinate
     */
    public func coordinate(_ point: MKMapPoint, _ zoom: Int) -> String {
        return coordinate(TileUtils.toCoordinate(point), zoom)
    }
    
    /**
     * Get the Global Area Reference System coordinate for the location coordinate in the
     * grid type precision
     *
     * @param coordinate location
     * @param type   grid type precision
     * @return MGRS coordinate
     */
    public func coordinate(_ coordinate: CLLocationCoordinate2D, _ type: GridType?) -> String {
        return mgrs(coordinate).coordinate(type)
    }
    
    /**
     * Get the Global Area Reference System coordinate for the MapKit map point in the
     * grid type precision
     *
     * @param point MapKit map point
     * @param type   grid type precision
     * @return MGRS coordinate
     */
    public func coordinate(_ point: MKMapPoint, _ type: GridType?) -> String {
        return coordinate(TileUtils.toCoordinate(point), type)
    }

    /**
     * Get the Global Area Reference System for the location coordinate
     *
     * @param coordinate location
     * @return MGRS
     */
    public func mgrs(_ coordinate: CLLocationCoordinate2D) -> MGRS {
        return MGRS.from(coordinate)
    }
    
    /**
     * Get the Global Area Reference System for the MapKit map point
     *
     * @param point MapKit map point
     * @return MGRS
     */
    public func mgrs(_ point: MKMapPoint) -> MGRS {
        return mgrs(TileUtils.toCoordinate(point))
    }

    /**
     * Parse a MGRS string
     *
     * @param mgrs
     *            MGRS string
     * @return MGRS
     */
    public static func parse(_ mgrs: String) -> MGRS {
        return MGRS.parse(mgrs)
    }

    /**
     * Parse a MGRS string into a location coordinate
     *
     * @param mgrs
     *            MGRS string
     * @return coordinate
     */
    public static func parseToCoordinate(_ mgrs: String) -> CLLocationCoordinate2D {
        return MGRS.parseToCoordinate(mgrs)
    }
    
    /**
     * Get the grid precision for the zoom level
     *
     * @param zoom zoom level
     * @return grid type precision
     */
    public func precision(_ zoom: Int) -> GridType? {
        return grids.precision(zoom)
    }

    /**
     * Get the tile
     *
     * @param x    x coordinate
     * @param y    y coordinate
     * @param zoom zoom level
     * @return image
     */
    public func tile(_ x: Int, _ y: Int, _ zoom: Int) -> Data? {
        return TileUtils.toData(drawTile(x, y, zoom))
    }

    /**
     * Draw the tile
     *
     * @param x    x coordinate
     * @param y    y coordinate
     * @param zoom zoom level
     * @return image
     */
    public func drawTile(_ x: Int, _ y: Int, _ zoom: Int) -> UIImage? {
        return grids.drawTile(tileWidth, tileHeight, x, y, zoom)
    }
    
}
