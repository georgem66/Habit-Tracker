import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_tracker/models/user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  User? get currentUser => _auth.currentUser;
  
  // Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }
  
  // Sign up with email and password
  Future<UserModel?> signUp(String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await result.user?.updateDisplayName(displayName);
      
      // Create user document in Firestore
      final newUser = UserModel(
        id: result.user!.uid,
        email: email,
        displayName: displayName,
      );
      
      await _db.collection('users').doc(result.user!.uid).set(newUser.toMap());
      
      notifyListeners();
      return newUser;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing up: $e');
      }
      return null;
    }
  }
  
  // Sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user data from Firestore
      DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();
      
      if (doc.exists) {
        final userData = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
        return userData;
      }
      
      notifyListeners();
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return null;
    }
  }
  
  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      UserCredential result = await _auth.signInWithCredential(credential);
      
      // Check if user exists in Firestore, if not create a new document
      DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();
      
      if (!doc.exists) {
        final newUser = UserModel(
          id: result.user!.uid,
          email: result.user!.email!,
          displayName: result.user!.displayName ?? 'User',
        );
        
        await _db.collection('users').doc(result.user!.uid).set(newUser.toMap());
        
        notifyListeners();
        return newUser;
      } else {
        final userData = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
        return userData;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      return null;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }
  
  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (_auth.currentUser == null) return null;
      
      DocumentSnapshot doc = await _db.collection('users').doc(_auth.currentUser!.uid).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }
  
  // Update user data
  Future<void> updateUserData(UserModel userData) async {
    try {
      await _db.collection('users').doc(userData.id).update(userData.toMap());
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
    }
  }
  
  // Update user points
  Future<void> updatePoints(int points) async {
    try {
      if (_auth.currentUser == null) return;
      
      DocumentSnapshot doc = await _db.collection('users').doc(_auth.currentUser!.uid).get();
      
      if (doc.exists) {
        UserModel userData = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        int newPoints = userData.points + points;
        
        await _db.collection('users').doc(_auth.currentUser!.uid).update({
          'points': newPoints,
        });
        
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating points: $e');
      }
    }
  }
  
  // Update premium status
  Future<void> updatePremiumStatus(bool isPremium) async {
    try {
      if (_auth.currentUser == null) return;
      
      await _db.collection('users').doc(_auth.currentUser!.uid).update({
        'isPremium': isPremium,
        'maxHabits': isPremium ? 10 : 3, // Premium users can have more habits
      });
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating premium status: $e');
      }
    }
  }
}