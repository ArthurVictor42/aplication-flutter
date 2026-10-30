import 'dart:convert';
import 'package:shelf/shelf.dart';

Response jsonResponse(
  int statusCode,
  Object body, {
  Map<String, String> headers = const {},
}) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {
      'content-type': 'application/json; charset=utf-8',
      'access-control-allow-origin': '*',
      'access-control-allow-headers': 'Origin, Content-Type, Accept, Authorization',
      'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
      ...headers,
    },
  );
}

Response badRequest(String message) =>
    jsonResponse(400, {'erro': message});

Response notFound(String message) =>
    jsonResponse(404, {'erro': message});

Response serverError(String message) =>
    jsonResponse(500, {'erro': message});
