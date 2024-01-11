enum NetworkErrors implements Comparable<NetworkErrors> {
  badRequest(400),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  gone(410),
  tooManyRequests(429),
  internalServerError(500),
  badGateway(502),
  serviceUnavailable(503);

  final int code;

  const NetworkErrors(this.code);

  @override
  int compareTo(NetworkErrors other) {
    return code.compareTo(other.code);
  }

  @override
  String toString() => 'NetworkErrors(code: $code)';
}
