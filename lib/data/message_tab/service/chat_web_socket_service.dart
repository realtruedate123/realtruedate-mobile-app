import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum MessageType { text, image, typing, readReceipt, status, error, unknown }

class ChatWebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  // Controller to expose parsed incoming events to the UI/Bloc/Notifier
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  /// Connects to the WebSocket server using conversation ID and JWT token
  void connect({
    required String host,
    required String conversationId,
    required String accessToken,
    bool useSsl = false,
  }) {
    final scheme = useSsl ? 'wss' : 'ws';
    final uri = Uri.parse(
      '$scheme://$host/ws/chat/$conversationId/?token=$accessToken',
    );

    try {
      _channel = IOWebSocketChannel.connect(uri);
      _isConnected = true;

      _subscription = _channel!.stream.listen(
            (dynamic rawData) {
          try {
            final Map<String, dynamic> data = jsonDecode(rawData as String);
            _messageController.add(data);
          } catch (e) {
            _messageController.add({
              'type': 'error',
              'message': 'Failed to parse incoming payload: $e',
            });
          }
        },
        onError: (error) {
          _isConnected = false;
          _messageController.add({
            'type': 'error',
            'message': 'WebSocket error: $error',
          });
        },
        onDone: () {
          _isConnected = false;
        },
      );
    } catch (e) {
      _isConnected = false;
      _messageController.add({
        'type': 'error',
        'message': 'Connection exception: $e',
      });
    }
  }

  /// Sends raw JSON payload safely
  void _send(Map<String, dynamic> data) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  /// Send Text Message
  void sendTextMessage(String content) {
    if (content.trim().isEmpty) return;
    _send({
      "type": "text_message",
      "content": content,
    });
  }

  /// Send Base64 Image Message
  Future<void> sendImageMessage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final fileName = imageFile.path.split('/').last;

    _send({
      "type": "image_message",
      "image_b64": base64Image,
      "filename": fileName,
    });
  }

  /// Send Typing Indicator
  void sendTypingIndicator(bool isTyping) {
    _send({
      "type": "typing",
      "is_typing": isTyping,
    });
  }

  /// Send Read Receipt
  void sendReadReceipt(String messageId) {
    _send({
      "type": "read_receipt",
      "message_id": messageId,
    });
  }

  /// Close connection clean-up
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }
}