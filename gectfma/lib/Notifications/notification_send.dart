import 'package:googleapis_auth/auth_io.dart' as auth;

// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "gectfma",
    "private_key_id": "7f18337fdd9f6b20b5c5f120a9ee4d39dac3a186",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC42F5Y86i7hvNX\ndPaJja5EtWhdXP++I/qHNOGlYxanyqkcAAP1e6awfe8lp04u62QkCtWRv+vP7191\nVZqJZMRWUXU3I8lYuEQ7VVmGSasD526pHLHHjbTJf3S8/VP4zkzWQL/9q3mVNS5K\n9kAom+63LV5I+1vegmzsqAkwXndRIYMt2jcFJUvnxBXN3GQlLrjgTNjJeDyy598+\nYXUfecMQbL6+PBr7u2ZFJ+UNEUIVHHLdpidBROyIY3yXRqSETfnIgPJUqlkI18vi\nC1oBq+hEHCscwJ+jZ5opAev5QYTaBrZcH7qkekcwrx4bTNRxlOg7vI3bpN6AToox\nufJYWqmZAgMBAAECggEAETqVnKvlW8lJ0CqGOi77Act41U7wRWw8EzMiHxS7zVrt\n5T65H73tPQEX88YC2wu0s0lRO7sMQz7YAms+srSyOitwhfmvcDYIohEj/YjLSFtf\nbKLQjT2PjsJzApSIKaYs8kFpw76iX/5reLA4LbDPEMLJSXsoRnaYqXxGEvyTGXwi\nAFsXZwQDK46fNGtSs2dlki2675CEo6AlEOTydaPxFepXwAZzJDUJXUWU3vEPY5L4\n0lDHjkAvfgUH814pmdHpqLoDNumVtQMaB6z39BCiHYH5jeyqhXcE979QZOYdvpAy\n6cWFlBu3I0bnuanSA7NgY4JFQQAd5hd2zuHzMhQJgQKBgQDqYPhjRP8Cw62v4XXE\nlGRBNQMkIA5qeyEwNUHYVvflS3PnvwPQh14n+WvjL6VvvVCA1dkIJP322GUfC/ja\nlaTX3TyHs0TqypYx8i5DYHl5JfKrvDAhve3bPHkpiig03F6ec4Z0r8ljHpz+uHFT\nSceeGA+s+tA69Gc2bCmPOyJKoQKBgQDJ5aAacj6gfzoX7e3rvw3bnlNRqSnxj0US\nm/4MsnJJphE5TLNu0yeOHoReCtptFev9NUShQcviYT74Fk+Hge18lTikgnnV0ReA\njK+81rCiiLYkFUQYIuQntK3NDIdmopH3bjTty5Ds1HEr9Lga5adGSd5XPQO06LIL\nXBbz/eIz+QKBgF6UDueQGg+1gsssged3shUWHVRgkzCoyzW26AEy5wniLr1fuVxW\no8ohvkWJHos+q9Oxd8jvlIQdwoCKxjr+k+x/3EMuNitA4Ob6wWxy69HVXF2srQeQ\nqwEDICmBFMRwAMaT+7fuj6et3NB1AVYIucK0Fu9Irup7YYL2lrazuBzBAoGAb275\n6x7bSiJuof6ErvWIZIsCWbQQnm8BJMBMfB2RzuyF3SZkcurAjkRxsqYy4LqUwfDA\nrHBwY8ZgxvUpeBVSSszhsosBS+5YFm+QH54vZ8YlIc1LBDddzjx/IQmlQhTAk9yU\nAhu1JcIrpKMxakcPCFCFE4ltnlBA1NxDHvAmBaECgYEAibaXpFOwYSzNI1kHp4Wu\ndJLzRvP3/gpZhz5Xoni6pYcjjTXSDKbbyxhS6wFdp/avpOfV/rMerE3yxMPaIDnh\nmKMVhdi0it7411VPB26StIc9CmzgvaKM0s0RtCy9OdGO8XtAy7Sm2MIYmWP0Bn2n\nogvRBAs4cGflSFhbdz8J7kQ=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-x1epk@gectfma.iam.gserviceaccount.com",
    "client_id": "105785108950807210673",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-x1epk%40gectfma.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
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
