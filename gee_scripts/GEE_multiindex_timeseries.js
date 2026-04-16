// ======================================================
// MULTI-INDEX TIME SERIES PER PHENOLOGY CYCLE
// NDVI, EVI, NDRE, NDWI + CHARTS + SEPARATE EXPORTS
// ======================================================

// ------------------------------
// USER-DEFINED PHENOLOGY CYCLES
// ------------------------------
var phenology_cycles = [
  {
    cycle_name: 'Elgeyo_2024_2025',
    county: 'Elgeyo Marakwet',
    asset: 'projects/modular-edge-454010-d1/assets/EMC_polygons',
    start: '2024-04-01',
    end:   '2025-02-28'
  },
  {
    cycle_name: 'Embu_2024_2025',
    county: 'Embu',
    asset: 'projects/modular-edge-454010-d1/assets/EMB_polygons',
    start: '2024-07-01',
    end:   '2025-05-31'
  }
];

var scale = 30;

// ------------------------------
// MASK FUNCTION
// ------------------------------
function maskHLS(img) {
  var fmask = img.select('Fmask');
  var mask = fmask.neq(3).and(fmask.neq(4)); // remove clouds + shadows
  return img.updateMask(mask);
}

// ------------------------------
// ADD VEGETATION INDICES
// ------------------------------
function addIndices(img) {
  var sf = 0.0001;

  var red  = img.select('B4').multiply(sf);
  var nir  = img.select('B8A').multiply(sf);
  var blue = img.select('B2').multiply(sf);
  var re   = img.select('B5').multiply(sf);
  var swir = img.select('B11').multiply(sf);

  var ndvi = nir.subtract(red).divide(nir.add(red)).rename('NDVI');

  var evi = nir.subtract(red)
    .multiply(2.5)
    .divide(
      nir.add(red.multiply(6))
         .subtract(blue.multiply(7.5))
         .add(1)
    ).rename('EVI');

  var ndre = nir.subtract(re).divide(nir.add(re)).rename('NDRE');
  var ndwi = nir.subtract(swir).divide(nir.add(swir)).rename('NDWI');

  return img.addBands([ndvi, evi, ndre, ndwi]);
}

// ------------------------------
// CHART HELPER FUNCTION
// ------------------------------
function makeCharts(smoothed, polys, cycleName) {

  var indices = ['NDVI', 'EVI', 'NDRE', 'NDWI'];
  var polyList = polys.toList(polys.size());
  var n = polys.size().getInfo();

  for (var i = 0; i < n; i++) {

    var feature = ee.Feature(polyList.get(i));
    var geom = feature.geometry();

    for (var j = 0; j < indices.length; j++) {

      var indexName = indices[j];

      var chart = ui.Chart.image.series({
        imageCollection: smoothed.select(indexName),
        region: geom,
        reducer: ee.Reducer.mean(),
        scale: scale,
        xProperty: 'system:time_start'
      })
      .setOptions({
        title: cycleName + ' | Farm ' + i + ' | ' + indexName,
        hAxis: { title: 'Date', format: 'yyyy-MM' },
        vAxis: { title: indexName, viewWindow: { min: -1, max: 1 } },
        lineWidth: 2,
        pointSize: 3,
        interpolateNulls: true
      });

      print(chart);
    }
  }
}

// ======================================================
// MAIN FUNCTION FOR EACH PHENOLOGY CYCLE
// ======================================================
function runPhenologyCycle(cycle) {

  print('Running phenology cycle:', cycle.cycle_name);

  var startDate = ee.Date(cycle.start);
  var endDate   = ee.Date(cycle.end);
  var polys     = ee.FeatureCollection(cycle.asset);

  Map.addLayer(polys, {color: 'red'}, cycle.cycle_name);
  Map.centerObject(polys, 11);

  // Load HLS
  var hls = ee.ImageCollection('NASA/HLS/HLSS30/v002')
    .filterBounds(polys)
    .filterDate(startDate, endDate.advance(1, 'day'))
    .map(maskHLS)
    .map(addIndices);

  // Monthly composites
  var nMonths = endDate.difference(startDate, 'month');
  var months = ee.List.sequence(0, nMonths);

  var monthly = ee.ImageCollection(
    months.map(function(m) {
      var d0 = startDate.advance(m, 'month');
      var d1 = d0.advance(1, 'month');

      var img = hls.filterDate(d0, d1)
                   .median()
                   .select(['NDVI','EVI','NDRE','NDWI']);

      var validPixels = img.select('NDVI').reduceRegion({
        reducer: ee.Reducer.count(),
        geometry: polys.geometry(),
        scale: scale,
        maxPixels: 1e9
      }).get('NDVI');

      return img
        .set('system:time_start', d0.millis())
        .set('valid_pixels', validPixels);
    })
  ).filter(ee.Filter.gt('valid_pixels', 0));

  // 3‑month moving average
  var smoothed = ee.ImageCollection(
    monthly.map(function(img) {
      var t = ee.Date(img.get('system:time_start'));
      var window = monthly.filterDate(
        t.advance(-1, 'month'),
        t.advance(2, 'month')
      );
      return ee.ImageCollection(window)
        .mean()
        .set('system:time_start', t.millis());
    })
  );

  // Charts for visual inspection
  makeCharts(smoothed, polys, cycle.cycle_name);

  // Export table
  var table = smoothed.map(function(img) {
    var date = ee.Date(img.get('system:time_start'));

    return img.reduceRegions({
      collection: polys,
      reducer: ee.Reducer.mean(),
      scale: scale
    }).map(function(f) {
      return f
        .set('date', date.format('YYYY-MM-dd'))
        .set('phenology_cycle', cycle.cycle_name)
        .set('county', cycle.county);
    });
  }).flatten();

  Export.table.toDrive({
    collection: table,
    description: 'HLS_MultiIndex_' + cycle.cycle_name,
    fileFormat: 'CSV'
  });
}

// ======================================================
// RUN ALL PHENOLOGY CYCLES
// ======================================================
phenology_cycles.forEach(runPhenologyCycle);
