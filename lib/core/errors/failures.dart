import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ กรุณาตรวจสอบอินเทอร์เน็ต']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'กรุณาเข้าสู่ระบบใหม่อีกครั้ง']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'เกิดข้อผิดพลาดในการโหลดข้อมูลแคช']);
}
