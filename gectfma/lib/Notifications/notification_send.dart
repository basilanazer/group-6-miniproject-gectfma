import 'package:googleapis_auth/auth_io.dart' as auth;

// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "Private Key and Other Details"
  };
  final List<String> scopes = [
    'https://www.googleapis.com/auth/firebase.messaging',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/userinfo.email'
  ];
  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
  );
  final auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);

  client.close();
  return credentials.accessToken.data;
}

void sendPushMessage(String token, String notiftitle, String notifbody) async {
  final String accessKey = await getAccessToken();
  const String fcmUrl =
      'https://fcm.googleapis.com/v1/projects/gectfma/messages:send';

  final Map<String, dynamic> notification = {
    'message': {
      'token': token,
      'notification': {'title': notiftitle, 'body': notifbody},
      'data': {'current_user_fcm_token': token}
    }
  };
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessKey',
  };
  final http.Response response = await http.post(
    Uri.parse(fcmUrl),
    headers: headers,
    body: jsonEncode(notification),
  );
  if (response.statusCode == 200) {
    // print('Notification sent successfully.');
  } else {
    // print('Failed to send notification: ${response.body}');
  }
}
