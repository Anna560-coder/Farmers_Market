// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Farmers App';

  @override
  String get home => 'Home';

  @override
  String get favorite => 'Favorite';

  @override
  String get profile => 'Profile';

  @override
  String get tasks => 'Tasks';

  @override
  String get ai => 'AI';

  @override
  String get weatherUpdates => 'Weather Updates';

  @override
  String get order => 'Order';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutUs => 'About Us';

  @override
  String get logOut => 'Log Out';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get sesotho => 'Sesotho';

  @override
  String get afrikaans => 'Afrikaans';

  @override
  String get settings => 'Settings';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get selectRole => 'Select Role';

  @override
  String get admin => 'Admin';

  @override
  String get user => 'User';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signupHere => 'Signup here';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginHere => 'Login here';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String accountNotRole(String role) {
    return 'Your account is not $role';
  }

  @override
  String get signupSuccessful => 'Signup Successful! Now Login';

  @override
  String signupFailed(String error) {
    return 'Signup Failed: $error';
  }

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get aiFeatures => 'AI Features';

  @override
  String get textToImage => 'Text ➝ Image';

  @override
  String get generateImageFromText => 'Generate image from text prompts';

  @override
  String get aiChatbot => 'AI Chatbot';

  @override
  String get converseWithGemini => 'Converse with Gemini AI';

  @override
  String get imagePrompt => 'Image + Prompt';

  @override
  String get askAiAboutImages => 'Ask AI about your images';

  @override
  String get chatbotScreen => 'Chatbot Screen';

  @override
  String get textToImageTitle => 'Text to Image';

  @override
  String get enterYourQuery => 'Enter your query';

  @override
  String get generate => 'Generate';

  @override
  String get mostAskedQuestions => 'Most Asked Questions';

  @override
  String get bestCropsSeason => 'What are the best crops to grow this season?';

  @override
  String get preventPests => 'How do I prevent pests from damaging my crops?';

  @override
  String get storeMaize => 'What is the best way to store harvested maize?';

  @override
  String get improveSoil => 'How can I improve soil fertility naturally?';

  @override
  String get fertilizersVegetables =>
      'Which fertilizers are recommended for vegetables?';

  @override
  String get livestockWinter =>
      'How do I take care of livestock during winter?';

  @override
  String get plantTomatoes => 'When is the best time to plant tomatoes?';

  @override
  String get waterCrops => 'How often should I water my crops?';

  @override
  String get couldNotUnderstand => 'I couldn\'t understand that.';

  @override
  String get enterQuestion => 'Enter a question here';

  @override
  String get farmProfile => 'Farm Profile';

  @override
  String get myFarmProfile => 'My Farm Profile';

  @override
  String get farmDetails => 'Farm Details';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get farmName => 'Farm Name';

  @override
  String get location => 'Location';

  @override
  String get size => 'Size';

  @override
  String get crops => 'Crops';

  @override
  String get livestock => 'Livestock';

  @override
  String get ownerName => 'Owner Name';

  @override
  String get phone => 'Phone';

  @override
  String get addFarmProfile => 'Add Farm Profile';

  @override
  String get editFarmProfile => 'Edit Farm Profile';

  @override
  String get saveFarmProfile => 'Save Farm Profile';

  @override
  String get deleteFarmProfile => 'Delete Farm Profile';

  @override
  String get farmNameRequired => 'Farm name is required';

  @override
  String get locationRequired => 'Location is required';

  @override
  String get sizeRequired => 'Farm size is required';

  @override
  String get ownerNameRequired => 'Owner name is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get validEmailRequired => 'Please enter a valid email address';

  @override
  String get validPhoneRequired => 'Please enter a valid phone number';

  @override
  String get farmProfileCreated => 'Farm profile created successfully';

  @override
  String get farmProfileUpdated => 'Farm profile updated successfully';

  @override
  String get farmProfileDeleted => 'Farm profile deleted successfully';

  @override
  String get farmProfileError => 'Error managing farm profile';

  @override
  String get confirmDelete =>
      'Are you sure you want to delete this farm profile?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get addCrop => 'Add Crop';

  @override
  String get addLivestock => 'Add Livestock';

  @override
  String get enterCropName => 'Enter crop name';

  @override
  String get enterLivestockName => 'Enter livestock name';

  @override
  String get remove => 'Remove';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String get locationDetected => 'Location detected successfully!';

  @override
  String get locationError =>
      'Could not detect location. Please enter manually.';
}
