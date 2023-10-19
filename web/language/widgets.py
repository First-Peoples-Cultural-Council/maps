import json

from django import forms
from django.contrib.gis.geos import (
    Point as GEOSPoint,
    LineString as GEOSLineString,
    Polygon as GEOSPolygon,
)
from geojson import Feature, FeatureCollection, Point, LineString, Polygon


class LatLongWidget(forms.MultiWidget):
    """
    A Widget that splits Point input into latitude/longitude text inputs.
    """

    def __init__(self, attrs=None, date_format=None, time_format=None):
        widgets = (forms.TextInput(attrs=attrs), forms.TextInput(attrs=attrs))
        super(LatLongWidget, self).__init__(widgets, attrs)

    def decompress(self, value):
        if value:
            return tuple(value.coords)
        return (None, None)

    def value_from_datadict(self, data, files, name):
        mylat = data[name + "_0"]
        mylong = data[name + "_1"]

        try:
            point = GEOSPoint(float(mylat), float(mylong))
        except ValueError:
            return ""

        return point


class GeoJSONFeatureCollectionWidget(forms.Textarea):
    def format_value(self, geom):
        # Allow null values to pass through unmodified
        if not geom:
            return None

        # Convert the GEOSGeometry to GeoJSON
        if geom.geom_type == "Point":
            geojson_geometry = Point(geom.coords)
        elif geom.geom_type == "LineString":
            geojson_geometry = LineString(geom.coords)
        elif geom.geom_type == "Polygon":
            geojson_geometry = Polygon(geom.coords)
        else:
            raise ValueError("Unsupported geometry type")

        # Create a Feature with the detected geometry
        feature = Feature(geometry=geojson_geometry)

        # Create a FeatureCollection with the single Feature
        feature_collection = FeatureCollection([feature])

        # Serialize the FeatureCollection to JSON
        return json.dumps(
            {
                "type": "FeatureCollection",
                "features": feature_collection.__geo_interface__.get("features"),
            }
        )

    def value_from_datadict(self, data, files, name):
        property_data = data.get(name) or None

        # Allow null values to pass through unmodified
        if not property_data:
            return None

        # Parse the JSON data and convert it into a geojson Feature
        geom = json.loads(property_data)["features"][0]
        feature = Feature(**geom)

        # Convert the geojson Feature into a GEOSGeometry
        if feature.geometry.type == "Point":
            value = GEOSPoint(feature.geometry.coordinates)
        elif feature.geometry.type == "LineString":
            value = GEOSLineString(feature.geometry.coordinates)
        elif feature.geometry.type == "Polygon":
            value = GEOSPolygon(feature.geometry.coordinates[0])
        else:
            raise ValueError("Unsupported geometry type")

        return value
