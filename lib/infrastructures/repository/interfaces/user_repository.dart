import 'package:octopus/infrastructures/models/api_response.dart';
import 'package:octopus/infrastructures/models/user/user_response.dart';

abstract class IUserRepository {
  Future<APIListResponse<User>> fetchAllUser({
    String? nuxifyId,
    String? firstName,
    String? lastName,
    String? currentPosition,
    String? isAdmin,
    String? address,
    String? civilStatus,
    int? age,
    bool? isDeactive
  });

  Future<APIListResponse<User>> createUser({
    required String firstName,
    required String lastName,
    required String nuxifyId,
    required String birthDate,
    required String address,
    required String civilStatus,
    required String dateHired,
    required String imageSource,
    required String pagIbigNo,
    required String sssNo,
    required String tinNo,
    required String philHealtNo,
  });

  Future<APIListResponse<User>> updateUser({
    required String id,
    String? firstName,
    String? lastName,
    String? nuxifyId,
    String? birthDate,
    String? address,
    String? civilStatus,
    String? dateHired,
    String? imageSource,
    String? pagIbigNo,
    String? sssNo,
    String? tinNo,
    String? philHealtNo,
  });

  Future<APIListResponse<User>> deactivateUser({
    required String id,
  });
}
