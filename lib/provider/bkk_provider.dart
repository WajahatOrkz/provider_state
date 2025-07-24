import 'dart:async';

import 'package:flutter/material.dart';

class BkkProvider extends ChangeNotifier {
  // Screen state variables
  String _screenSelected = 'Remote Advisory';
  String? _operatorSelected;
  bool _isSheetExpanded = false;
  bool _isOtpSent = false;
  String _phone = "";
  bool _isLoading = false;
  String? _errorMessage;
  int _resendTimeout = 60;
  Timer? _resendTimer;
  bool _canResendOtp = false;
  bool _showOtpField = false;
  String? _sentPhoneNumber;

  // Controllers
  final TextEditingController phoneController = TextEditingController();
  final DraggableScrollableController draggableController =
      DraggableScrollableController();

  final int otpLength = 4;
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;

  // Data lists
  final List<Map<String, String>> screenNames = [
    {
      'name': 'Remote Advisory',
      'image': 'assets/images/remote_advisory.png',
      'text': 'inc Tax/day',
    },
    {
      'name': 'On-ground Support',
      'image': 'assets/images/og.png',
      'text': 'inc Tax/day',
    },
    {
      'name': 'Agri Products',
      'image': 'assets/images/ap.png',
      'text': 'inc Tax/day',
    },
  ];

  final List advisoryList = [
    (
      name: 'Weather Alerts',
      image: 'assets/images/weather.png',
      text: "inc Tax/day",
    ),
    (
      name: 'Agri Advisory',
      image: 'assets/images/advisory.png',
      text: "inc Tax/day",
    ),
    (
      name: 'Crop Advisory',
      image: 'assets/images/crop_advisory.png',
      text: "inc Tax/day",
    ),
  ];

  final List operatorList = [
    (name: 'Rs. 5', image: 'assets/images/ufone.png', text: "inc Tax/day"),
    (name: 'RS. 3.5 ', image: 'assets/images/jazz1.jpg', text: "inc Tax/day"),
    (name: 'Rs. 2.5 ', image: 'assets/images/zong11.webp', text: "inc Tax/day"),
  ];

  final List<String> logos = [
    'assets/images/agri_products/rachna.jpeg',
    'assets/images/agri_products/ffc.png',
    'assets/images/agri_products/orange.png',
    'assets/images/agri_products/akora.jpeg',
    'assets/images/agri_products/fatima.jpg',
    'assets/images/agri_products/centrigo.webp',
    'assets/images/agri_products/evyol.jpeg',
    'assets/images/agri_products/syngenta.png',
    'assets/images/agri_products/fmc.png',
  ];

  // Getters
  String get screenSelected => _screenSelected;
  String? get operatorSelected => _operatorSelected;
  bool get isSheetExpanded => _isSheetExpanded;
  bool get isOtpSent => _isOtpSent;
  String get phone => _phone;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get resendTimeout => _resendTimeout;
  bool get canResendOtp => _canResendOtp;
  bool get showOtpField => _showOtpField;
  String? get sentPhoneNumber => _sentPhoneNumber;

  bool get isOtpValid =>
      otpControllers.every((controller) => controller.text.length == 1);

  BkkProvider() {
    _initializeControllers();
    _setupListeners();
  }

  void _initializeControllers() {
    otpControllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
    phoneController.addListener(_onPhoneChanged);

    draggableController.addListener(() {
      final extent = draggableController.size;
      if (extent >= 0.95 && !_isSheetExpanded) {
        _isSheetExpanded = true;
        notifyListeners();
      } else if (extent <= 0.06 && _isSheetExpanded) {
        _isSheetExpanded = false;
        notifyListeners();
      }
    });
  }

  void _setupListeners() {
    // Any additional setup can go here
  }

  // Screen selection
  void selectScreen(String screenName) {
    _screenSelected = screenName;
    notifyListeners();
  }

  // Operator selection
  void selectOperator(String operatorName) {
    _operatorSelected = operatorName;
    notifyListeners();
  }

  // Phone number change handler
  void _onPhoneChanged() {
    if (_sentPhoneNumber != null &&
        phoneController.text.trim() != _sentPhoneNumber) {
      _isOtpSent = false;
      _showOtpField = false;
      for (var controller in otpControllers) {
        controller.clear();
      }
      notifyListeners();
    }
  }

  // OTP handling
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      otpControllers[index].text = value.characters.last;
      if (index < otpLength - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    }
    notifyListeners();
  }

  void onBackspacePressed(int index) {
    if (otpControllers[index].text.isEmpty && index > 0) {
      otpControllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
    }
  }

  // Timer functions
  void _startResendTimer() {
    _resendTimeout = 60;
    _canResendOtp = false;
    notifyListeners();

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        _resendTimeout--;
        notifyListeners();
      } else {
        _canResendOtp = true;
        notifyListeners();
        timer.cancel();
      }
    });
  }

  void resendOtp(BuildContext context) {
    if (_canResendOtp) {
      handleGetOtp(context);
      _startResendTimer();
    }
  }

  // Format phone number
  String formatPhoneNumber(String input) {
    input = input.trim();
    if (input.startsWith('0')) {
      input = input.substring(1);
    }
    return input;
  }

  // Show error snackbar
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Main OTP request function
  Future<void> handleGetOtp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final phone = phoneController.text.trim();

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      // Validate phone number
      if (phone.isEmpty) {
        showErrorSnackbar(context, "Phone number cannot be empty.");
        return;
      }

      String digitsOnly = phone.replaceAll(RegExp(r'[^0-9]'), '');

      if (digitsOnly.isEmpty ||
          digitsOnly.length < 11 ||
          digitsOnly.length > 13) {
        showErrorSnackbar(
          context,
          "Phone number must be 11 digits or in correct format.",
        );
        return;
      }

      if (RegExp(r'^(1|44|91|7|81|61)').hasMatch(digitsOnly)) {
        showErrorSnackbar(
          context,
          "Only Pakistani numbers (+92) are supported.",
        );
        return;
      }

      String localNumber;
      if (digitsOnly.length == 11) {
        localNumber = digitsOnly;
      } else if (digitsOnly.startsWith("92")) {
        localNumber = "0${digitsOnly.substring(2)}";
      } else {
        showErrorSnackbar(context, "Invalid phone number format.");
        return;
      }

      if (!localNumber.startsWith("03") || localNumber.length != 11) {
        showErrorSnackbar(
          context,
          "Pakistani mobile numbers must be 11 digits and start with '03'.",
        );
        return;
      }

      if (RegExp(r'^(\d)\1{10}$').hasMatch(localNumber)) {
        showErrorSnackbar(
          context,
          "Invalid phone number. Please enter a real number.",
        );
        return;
      }

      final List<String> allowedPrefixes = [
        "0300",
        "0301",
        "0302",
        "0303",
        "0304",
        "0305",
        "0306",
        "0307",
        "0308",
        "0309",
        "0310",
        "0311",
        "0312",
        "0313",
        "0314",
        "0315",
        "0316",
        "0317",
        "0318",
        "0319",
        "0320",
        "0321",
        "0322",
        "0323",
        "0324",
        "0325",
        "0326",
        "0327",
        "0328",
        "0329",
        "0330",
        "0331",
        "0332",
        "0333",
        "0334",
        "0335",
        "0336",
        "0337",
        "0338",
        "0339",
        "0340",
        "0341",
        "0342",
        "0343",
        "0344",
        "0345",
        "0346",
        "0347",
        "0348",
        "0349",
        "0355",
        "0356",
        "0357",
        "0358",
        "0359",
        "0360",
        "0361",
        "0362",
        "0363",
        "0364",
        "0365",
        "0366",
        "0367",
        "0368",
        "0369",
      ];

      String prefix = localNumber.substring(0, 4);
      if (!allowedPrefixes.contains(prefix)) {
        showErrorSnackbar(context, "Invalid mobile network prefix.");
        return;
      }

      if (localNumber == "03123456789") {
        showErrorSnackbar(context, "Please enter a real phone number.");
        return;
      }

      final blockedTestNumbers = {
        "03001234567",
        "03000000000",
        "03123456789",
        "03451234567",
      };
      if (blockedTestNumbers.contains(localNumber)) {
        showErrorSnackbar(context, "This number is not allowed.");
        return;
      }

      if (RegExp(r'(\d)\1{6,}').hasMatch(localNumber)) {
        showErrorSnackbar(
          context,
          "Phone number contains too many repeated digits.",
        );
        return;
      }

      final blacklistedPrefixes = ["0355", "0360"];
      if (blacklistedPrefixes.contains(prefix)) {
        showErrorSnackbar(context, "Phone number from unsupported network.");
        return;
      }

      if (localNumber.contains("012345") ||
          localNumber.contains("123456") ||
          localNumber.contains("987654")) {
        showErrorSnackbar(context, "Phone number pattern is not allowed.");
        return;
      }

      if (_operatorSelected == null || _operatorSelected!.isEmpty) {
        showErrorSnackbar(context, "Please select a mobile operator.");
        return;
      }

      String msisdn = localNumber.substring(1);

      print("📱 Sending OTP to: $msisdn");
      print("📡 Selected operator: $_operatorSelected");
    } catch (e) {}

    // OTP verification
    Future<void> verifyOtp(BuildContext context) async {
      final otp = otpControllers.map((e) => e.text).join();
      final input = phoneController.text;
      final phoneNumber = formatPhoneNumber(input);

      if (otp.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter a valid 4-digit OTP")),
        );
        return;
      }

      _isLoading = true;
      notifyListeners();

      _isLoading = false;
      notifyListeners();
    }

    @override
    void dispose() {
      draggableController.dispose();
      phoneController.removeListener(_onPhoneChanged);
      phoneController.dispose();
      _resendTimer?.cancel();

      for (final controller in otpControllers) {
        controller.dispose();
      }
      for (final node in focusNodes) {
        node.dispose();
      }
      super.dispose();
    }
  }
}
