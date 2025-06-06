import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000';
  final String baseUrl;

  ApiService({this.baseUrl = _baseUrl});

  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final sessionId = await getSessionId();
    
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (sessionId != null) 'Cookie': 'connect.sid=$sessionId',
      },
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final sessionId = await getSessionId();
    
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (sessionId != null) 'Cookie': 'connect.sid=$sessionId',
      },
      body: json.encode(data),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final sessionId = await getSessionId();
    
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (sessionId != null) 'Cookie': 'connect.sid=$sessionId',
      },
      body: json.encode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final sessionId = await getSessionId();
    
    return await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (sessionId != null) 'Cookie': 'connect.sid=$sessionId',
      },
    );
  }
}