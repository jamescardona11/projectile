import 'package:flutter/material.dart';
import 'package:example/api_request/api_request_with_dio.dart';
import 'package:example/api_request/api_request_with_http.dart';

class OtherPage extends StatefulWidget {
  /// default constructor
  const OtherPage({
    super.key,
  });

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  ApiRequestWithHttp apiRequestHttp = ApiRequestWithHttp();
  ApiRequestWithDio apiRequestWithDio = ApiRequestWithDio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Results for console'),
            SizedBox(height: 30),
            Text('HTTP'),
            TextButton(
              onPressed: () {
                apiRequestHttp.testPut();
              },
              child: Text('Test put HttpClient'),
            ),
            TextButton(
              onPressed: () {
                apiRequestHttp.testDelete();
              },
              child: Text('Test delete HttpClient'),
            ),
            TextButton(
              onPressed: () {
                apiRequestHttp.testPatch();
              },
              child: Text('Test patch HttpClient'),
            ),
            SizedBox(height: 30),
            Text('DIO'),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                apiRequestWithDio.testPOST();
              },
              child: Text('Test post DIOClient'),
            ),
            TextButton(
              onPressed: () {
                apiRequestWithDio.testPut();
              },
              child: Text('Test put DIOClient'),
            ),
            TextButton(
              onPressed: () {
                apiRequestWithDio.testDelete();
              },
              child: Text('Test delete DIOClient'),
            ),
            TextButton(
              onPressed: () {
                apiRequestWithDio.testPatch();
              },
              child: Text('Test patch DIOClient'),
            ),
          ],
        ),
      ),
    );
  }
}
