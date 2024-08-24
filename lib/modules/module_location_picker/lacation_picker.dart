library location_picker;

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/services/location_service.dart';
import 'package:shimmer/shimmer.dart';

part 'location_picker_page.dart';
part 'prediction_location_model.dart';
