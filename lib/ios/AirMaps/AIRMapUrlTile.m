//
//  AIRUrlTileOverlay.m
//  AirMaps
//
//  Created by cascadian on 3/19/16.
//  Copyright © 2016. All rights reserved.
//

#import "AIRMapUrlTile.h"
#import "AIRMapUrlTileOverlay.h"
#import <React/UIView+React.h>

@implementation AIRMapUrlTile {
    BOOL _urlTemplateSet;
    BOOL _tileSizeSet;
}

- (void)setShouldReplaceMapContent:(BOOL)shouldReplaceMapContent
{
  _shouldReplaceMapContent = shouldReplaceMapContent;
  if(self.tileOverlay) {
    self.tileOverlay.canReplaceMapContent = _shouldReplaceMapContent;
  }
  [self update];
}

- (void)setMaximumZ:(NSUInteger)maximumZ
{
  _maximumZ = maximumZ;
  if(self.tileOverlay) {
    self.tileOverlay.maximumZ = _maximumZ;
  }
  [self update];
}

- (void)setMinimumZ:(NSUInteger)minimumZ
{
  _minimumZ = minimumZ;
  if(self.tileOverlay) {
    self.tileOverlay.minimumZ = _minimumZ;
  }
  [self update];
}

- (void)setFlipY:(BOOL)flipY
{
  _flipY = flipY;
  if (self.tileOverlay) {
    self.tileOverlay.geometryFlipped = _flipY;
  }
}

- (void)setUrlTemplate:(NSString *)urlTemplate{
    _urlTemplate = urlTemplate;
    _urlTemplateSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    [self update];
}

- (void)setTileSize:(CGFloat)tileSize{
    _tileSize = tileSize;
    _tileSizeSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    [self update];
}

- (void)setMaximumZ:(NSInteger)maximumZ
{
    _maximumZ = maximumZ;
    if(self.tileOverlay) {
        self.tileOverlay.maximumZ = maximumZ;
    }
    [self update];
}

- (void)setOverzoomEnabled:(BOOL)overzoomEnabled
{
    _overzoomEnabled = overzoomEnabled;
    if(self.tileOverlay) {
        self.tileOverlay.overzoomEnabled = _overzoomEnabled;
    }
    [self update];
}

- (void)setOverzoomThreshold:(NSInteger)overzoomThreshold
{
    _overzoomThreshold = overzoomThreshold;
    if(self.tileOverlay) {
        self.tileOverlay.overzoomThreshold = overzoomThreshold;
    }
    [self update];
}


- (void) createTileOverlayAndRendererIfPossible
{
    if (!_urlTemplateSet) return;
    self.tileOverlay = [[AIRMapUrlTileOverlay alloc] initWithURLTemplate:self.urlTemplate];
    self.tileOverlay.canReplaceMapContent = self.shouldReplaceMapContent;
    
    if (self.overzoomEnabled) {
        self.tileOverlay.overzoomEnabled = self.overzoomEnabled;
    }
    
    if (self.overzoomThreshold) {
        self.tileOverlay.overzoomThreshold = self.overzoomThreshold;
    }
    
    if(self.minimumZ) {
        self.tileOverlay.minimumZ = self.minimumZ;
    }
    
    if (self.maximumZ) {
        self.tileOverlay.maximumZ = self.maximumZ;
    }
    if (self.flipY) {
        self.tileOverlay.geometryFlipped = self.flipY;
    }
    if (_tileSizeSet) {
        self.tileOverlay.tileSize = CGSizeMake(self.tileSize, self.tileSize);
    }
    if (self.overzoomEnabled) {
        self.tileOverlay.overzoomEnabled = self.overzoomEnabled;
    }
    if (self.overzoomThreshold) {
        self.tileOverlay.overzoomThreshold = self.overzoomThreshold;
    }
    self.renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:self.tileOverlay];
}

- (void) update
{
    if (!_renderer) return;
    
    if (_map == nil) return;
    [_map removeOverlay:self];
    [_map addOverlay:self level:MKOverlayLevelAboveLabels];
    for (id<MKOverlay> overlay in _map.overlays) {
        if ([overlay isKindOfClass:[AIRMapUrlTile class]]) {
            continue;
        }
        [_map removeOverlay:overlay];
        [_map addOverlay:overlay];
    }
}

#pragma mark MKOverlay implementation

- (CLLocationCoordinate2D) coordinate
{
    return self.tileOverlay.coordinate;
}

- (MKMapRect) boundingMapRect
{
    return self.tileOverlay.boundingMapRect;
}

- (BOOL)canReplaceMapContent
{
    return self.tileOverlay.canReplaceMapContent;
}

@end
