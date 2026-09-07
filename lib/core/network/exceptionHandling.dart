import 'package:stu/Core/Network/responseException.dart';

class ErrorHandling implements Exception{

  static void  httpException(int code){

    print("code value is Printed here-----------$code");
    switch (code){

      case 200 ||201:
        return;

      case 404:
        throw ResponseException(
          message: "Not Found",
          code: code,
        );
      case 500:
        throw ResponseException(
          message: "Server Issue",
          code: code,
        );

        default:
          throw ResponseException(
            message: "Something Went Wrong",
            code: code,
          );
    }

  }

}