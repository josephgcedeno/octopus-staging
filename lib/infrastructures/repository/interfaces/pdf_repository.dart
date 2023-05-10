import 'package:flutter/services.dart';
import 'package:octopus/infrastructures/models/api_response.dart';

abstract class IPDFRepository {
  Future<APIResponse<Uint8List>> generatePDF({
    required String name,
    required Map<String, List<String>> selectedTasks,
  });
}
