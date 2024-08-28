import 'package:dio/dio.dart';

class Dioclient {
  final Dio _dio = Dio();
  Dioclient();

  Future<Response> get(String path) async {
    return _dio.get(path);
  }
}
