class UserService {
  // Sign up
  Future<void> signUp(String email, String password, String name) async {}

  // Login
  Future<void> login(String email, String password) async {}

  // Logout
  Future<void> logout() async {}

  // Fetch profile
  Future<Map<String, dynamic>?> getProfile(String uid) async => {};

  // Update profile
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {}
}
