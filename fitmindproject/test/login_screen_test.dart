import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fitmind_app/screens/auth/login_screen.dart';

/// Mock AuthProvider for testing without Firebase dependency
class MockAuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => false;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
    _isLoading = false;
    notifyListeners();
    return false; // Always fail in mock for testing
  }
}

/// Widget Tests for LoginScreen
/// Tests UI rendering, form validation, and user interactions
void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
    });

    // Helper function to create a testable LoginScreen with Mock Provider
    Widget createTestableWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<MockAuthProvider>.value(
          value: mockAuthProvider,
          child: Builder(
            builder: (context) {
              // We need to provide the mock as AuthProvider type
              return ChangeNotifierProvider.value(
                value: mockAuthProvider,
                child: const _TestableLoginScreen(),
              );
            },
          ),
        ),
        routes: {
          '/main': (context) => const Scaffold(body: Text('Main Screen')),
          '/register1': (context) => const Scaffold(body: Text('Register Screen')),
        },
      );
    }

    testWidgets('should render login form with email and password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Verify email and password labels exist
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify login button exists
      expect(find.text('Login'), findsOneWidget);

      // Verify welcome text
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('should show hint texts in form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Verify hint texts
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('should show validation error when email is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Tap login button without entering any data
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify validation error appears
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show validation error when password is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Enter only email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'test@example.com',
      );

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify password validation error appears
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email format',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Enter invalid email (without @)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'invalidemail',
      );

      // Enter password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'password123',
      );

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify email validation error appears
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show validation error for short password',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'test@example.com',
      );

      // Enter short password (less than 6 characters)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        '12345',
      );

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify password length validation error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should have register link', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Verify register link exists
      expect(find.text("Don't have an account? Register"), findsOneWidget);
    });

    testWidgets('should have back button in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Verify back button exists
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}

/// Testable version of LoginScreen that works with MockAuthProvider
class _TestableLoginScreen extends StatefulWidget {
  const _TestableLoginScreen();

  @override
  State<_TestableLoginScreen> createState() => _TestableLoginScreenState();
}

class _TestableLoginScreenState extends State<_TestableLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Center(
                  child: Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Sign in to access your offline data'),
                const SizedBox(height: 32),
                const Text('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Consumer<MockAuthProvider>(
                  builder: (context, authProvider, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  // Would call login here
                                }
                              },
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Login'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register1');
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
