import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_true_date/core/local/shared_pref.dart';
import 'package:real_true_date/core/network/InternetDialog.dart';
import 'package:real_true_date/core/network/api_functions/api_request.dart';
import 'package:real_true_date/core/network/apis_end_points.dart';
import 'package:real_true_date/data/message_tab/model/message_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController extends GetxController with WidgetsBindingObserver {
  // Arguments passed from Navigation
  late String conversationId;
  late String currentUserId;

  // Observable States
  var messages = <MessageObject>[].obs;
  var status = 'pending'.obs; // 'accepted', 'pending', 'declined'
  var isInitiator = false.obs;
  var isInputEnabled = false.obs;
  var bannerText = ''.obs;
  var isLoading = false.obs;

  var otherUserStatus = 'offline'.obs;
  var isOtherUserTyping = false.obs;

  WebSocketChannel? _channel;
  StreamSubscription? _socketSubscription;

  final sharedPref = SharedPrefHelper();
  var conversationData = ConversationData().obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    getUserData();
    // Read route arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    conversationId = args['conversation_id'] ?? '';
    getChatConversationsApiCall();
    connectWebSocket();
  }

  /// Get saved local user data
  void getUserData() async {
    try {
      // Fetch from API or storage
      currentUserId = await sharedPref.getUserId;
    } finally {
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Requirement: Re-call GET messages API every time screen resumes from background
    if (state == AppLifecycleState.resumed) {
      // fetchChatMessagesAndEvaluateRules();
      getChatConversationsApiCall();
    }
  }

  /// Step 3 API: GET /conversations/<id>/messages
  /*Future<void> fetchChatMessagesAndEvaluateRules() async {
    try {
      // Replace with your API client / repository call
      // final response = await http.get('/conversations/$conversationId/messages');
      // Simulated response mapping:
      final Map<String, dynamic> responseData = {
        "status": "pending",
        "is_initiator": false,
        "messages": []
      };

      status.value = responseData['status'] ?? 'pending';
      isInitiator.value = responseData['is_initiator'] ?? false;

      // Evaluate Decision Table rules
      evaluateInputRules();

      // Parse existing messages
      final List rawMsgs = responseData['messages'] ?? [];
      messages.value = rawMsgs
          .map((m) => MessageObject.fromJson(m,))
          .toList();
    } catch (e) {
      debugPrint("Error fetching chat messages: $e");
    }
  }*/

  /// Decision Table Rules Evaluation
  void evaluateInputRules() {
    if (status.value == 'accepted') {
      isInputEnabled.value = true;
      bannerText.value = '';
    } else if (status.value == 'pending' && isInitiator.value == true) {
      isInputEnabled.value = true;
      bannerText.value = 'Request sent';
    } else if (status.value == 'pending' && isInitiator.value == false) {
      isInputEnabled.value = false;
      bannerText.value = 'Waiting for their response';
    } else if (status.value == 'declined') {
      isInputEnabled.value = false;
      bannerText.value = 'Request declined';
    }
  }

  /// Step 4: WebSocket Connection
  Future<void> connectWebSocket() async {
    final authToken = await sharedPref.getAuthToken;

    if (conversationId.isEmpty || authToken.isEmpty) return;

    final wsUri = Uri.parse(
      'ws://airealconnect.com/ws/chat/$conversationId/?token=$authToken',
    );

    try {
      _channel = IOWebSocketChannel.connect(wsUri);
      _socketSubscription = _channel!.stream.listen(
            (rawData) {
          final data = jsonDecode(rawData as String);
          final type = data['type'];

          if (type == 'status') {
            otherUserStatus.value = data['data']?['status'] ?? 'offline';
          } else if (type == 'typing') {
            isOtherUserTyping.value = data['data']?['is_typing'] ?? false;
          } else if (type == 'message') {
            // final newMsg = MessageObject.fromJson(data['data'], currentUserId);
            final newMsg = MessageObject.fromJson(data['data']);
            messages.insert(0, newMsg);
          } else if (type == 'error') {
            Get.snackbar('Notice', data['message'] ?? 'An error occurred');
          }
        },
        onError: (err) => debugPrint("WS Error: $err"),
        onDone: () => debugPrint("WS Closed"),
      );
    } catch (e) {
      debugPrint("WS Connection Exception: $e");
    }
  }

  void sendTextMessage(String content) {
    if (!isInputEnabled.value || content.trim().isEmpty) return;

    final payload = {
      "type": "text_message",
      "content": content,
    };

    _channel?.sink.add(jsonEncode(payload));
    sendTypingIndicator(false);
  }

  void sendTypingIndicator(bool isTyping) {
    if (!isInputEnabled.value) return;
    final payload = {
      "type": "typing",
      "is_typing": isTyping,
    };
    _channel?.sink.add(jsonEncode(payload));
  }

  //TODO: Get User chat List API Call
  Future<void> getChatConversationsApiCall() async {
    isLoading.value = true;
    final authToken = await sharedPref.getAuthToken;
    final header = {
      'Content-Type': 'application/json',
      "Authorization": 'Bearer $authToken',
    };

    final response = await BaseApiService().getMethod<MessageListModel>(
      endpoint: '${Endpoints.notificationsAcceptOrDecline}/$conversationId/messages?page=1&page_size=50',
      headers: header,
      fromJson: (json) => MessageListModel.fromJson(json),
      showLoader: false
    );

    if (response.isSuccess && response.statusCode == 200) {
      isLoading.value = false;
      conversationData.value = response.data?.data ?? ConversationData();

      status.value = response.data?.data?.status ?? 'pending';
      isInitiator.value = response.data?.data?.isInitiator ?? false;

      // Evaluate Decision Table rules
      evaluateInputRules();

      // Parse existing messages
      /*final List rawMsgs = conversationData.value.messages ?? [];
      messages.value = rawMsgs
          .map((m) => MessageObject.fromJson(m, currentUserId))
          .toList();*/

      final rawMsgs = conversationData.value.messages ?? [];

      rawMsgs.sort((a, b) {
        final dateA = DateTime.parse(a.createdAt ?? '');
        final dateB = DateTime.parse(b.createdAt ?? '');

        // return dateA.compareTo(dateB); // Oldest → Latest
        return dateB.compareTo(dateA); // Latest → Oldest
      });

      messages.value = rawMsgs;
      // messages.value = rawMsgs
      //     .map((m) => MessageObject.fromJson(m))
      //     .toList();

    } else if (response.statusCode == 0) {
      isLoading.value = false;
      InternetDialog.showNoInternetDialog();
    } else {
      isLoading.value = false;
      if (response.tokenExpired == true) {
        final result = await BaseApiService().refreshToken();
        if (result.isSuccess) {
          getChatConversationsApiCall();
        }
      } else {
        Get.snackbar('Failed', response.message ?? 'Something went wrong');
      }
    }
    update();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _socketSubscription?.cancel();
    _channel?.sink.close();
    super.onClose();
  }
}