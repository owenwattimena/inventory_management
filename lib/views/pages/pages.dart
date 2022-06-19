import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


// COMPONENTS
import '../../config/colors.dart';
import '../../controllers/backup_controller.dart';
import '../../controllers/chart_controller.dart';
import '../../controllers/division_controller.dart';
import '../../controllers/passcode_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/pc_manager_controller.dart';
import '../../controllers/product_transaction_controller.dart';
import '../components/components.dart';

part 'home_page.dart';
part 'transaction_detail_page.dart';
part 'product_page.dart';
part 'product_detail_page.dart';
part 'division_page.dart';
part 'division_transaction_page.dart';
part 'more_page.dart';
part 'backup_page.dart';
part 'chart_page.dart';
part 'pc_manager_page.dart';