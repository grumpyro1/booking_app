import '../../data/models/user_model.dart';
// keeps the current status (loading, logged in, error, etc.)
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user,this.isLoading = false,this.error});

  bool get isLoggedIn => user != null; // isLoggedIn is true if user is not null, otherwise false.

  AuthState copyWith({UserModel? user,bool? isLoading,String? error}) {
    return AuthState(user: user ?? this.user,isLoading: isLoading ?? this.isLoading,error: error ?? this.error);
  }

  AuthState clearError() {
    return AuthState(user: user,isLoading: isLoading,error: null);
  }

  AuthState setLoading(bool loading) {
    return AuthState(user: user,isLoading: loading,error: error);
  }
}


// Scenario 1: Not logged in
// - user: null
// - isLoading: false
// - error: null

// Scenario 2: Logging in...
// - user: null
// - isLoading: true
// - error: null

// Scenario 3: Login failed
// - user: null
// - isLoading: false
// - error: "Invalid password"

// Scenario 4: Logged in!
// - user: John Doe (john@example.com)
// - isLoading: false
// - error: null
// ```

// It's like a status board showing the current authentication situation.