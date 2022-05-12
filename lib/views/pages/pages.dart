import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/config/text_style.dart';
import 'package:inventory_management/controllers/home_controller.dart';
import 'package:inventory_management/controllers/transaction_controller.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/models/transaction.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';

// COMPONENTS
import '../../controllers/product_controller.dart';
import '../../controllers/product_transaction_controller.dart';
import '../components/components.dart';

part 'home_page.dart';
part 'transaction_detail_page.dart';
part 'product_page.dart';
part 'product_detail_page.dart';