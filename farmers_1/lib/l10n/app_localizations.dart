import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_en.dart';
import 'app_localizations_st.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('af'),
    Locale('en'),
    Locale('st'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Farmers App'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Favorite tab label
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Tasks tab label
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// AI tab label
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get ai;

  /// Weather Updates tab label
  ///
  /// In en, this message translates to:
  /// **'Weather Updates'**
  String get weatherUpdates;

  /// Order menu item
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// Payment Method menu item
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Notifications menu item
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// About Us menu item
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// Log Out menu item
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language selection dropdown title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Sesotho language option
  ///
  /// In en, this message translates to:
  /// **'Sesotho'**
  String get sesotho;

  /// Afrikaans language option
  ///
  /// In en, this message translates to:
  /// **'Afrikaans'**
  String get afrikaans;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Confirm Password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Select Role dropdown label
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// Admin role option
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// User role option
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Signup button text
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// Don't have account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Signup here link text
  ///
  /// In en, this message translates to:
  /// **'Signup here'**
  String get signupHere;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Login here link text
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validEmail;

  /// Password required validation message
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password minimum length validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Name required validation message
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Confirm password required validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// Passwords do not match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Account role mismatch message
  ///
  /// In en, this message translates to:
  /// **'Your account is not {role}'**
  String accountNotRole(String role);

  /// Signup successful message
  ///
  /// In en, this message translates to:
  /// **'Signup Successful! Now Login'**
  String get signupSuccessful;

  /// Signup failed message
  ///
  /// In en, this message translates to:
  /// **'Signup Failed: {error}'**
  String signupFailed(String error);

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// AI Features page title
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get aiFeatures;

  /// Text to Image feature title
  ///
  /// In en, this message translates to:
  /// **'Text ➝ Image'**
  String get textToImage;

  /// Text to Image feature subtitle
  ///
  /// In en, this message translates to:
  /// **'Generate image from text prompts'**
  String get generateImageFromText;

  /// AI Chatbot feature title
  ///
  /// In en, this message translates to:
  /// **'AI Chatbot'**
  String get aiChatbot;

  /// AI Chatbot feature subtitle
  ///
  /// In en, this message translates to:
  /// **'Converse with Gemini AI'**
  String get converseWithGemini;

  /// Image + Prompt feature title
  ///
  /// In en, this message translates to:
  /// **'Image + Prompt'**
  String get imagePrompt;

  /// Image + Prompt feature subtitle
  ///
  /// In en, this message translates to:
  /// **'Ask AI about your images'**
  String get askAiAboutImages;

  /// Chatbot screen title
  ///
  /// In en, this message translates to:
  /// **'Chatbot Screen'**
  String get chatbotScreen;

  /// Text to Image screen title
  ///
  /// In en, this message translates to:
  /// **'Text to Image'**
  String get textToImageTitle;

  /// Enter query placeholder text
  ///
  /// In en, this message translates to:
  /// **'Enter your query'**
  String get enterYourQuery;

  /// Generate button text
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// Most asked questions section title
  ///
  /// In en, this message translates to:
  /// **'Most Asked Questions'**
  String get mostAskedQuestions;

  /// Best crops season question
  ///
  /// In en, this message translates to:
  /// **'What are the best crops to grow this season?'**
  String get bestCropsSeason;

  /// Prevent pests question
  ///
  /// In en, this message translates to:
  /// **'How do I prevent pests from damaging my crops?'**
  String get preventPests;

  /// Store maize question
  ///
  /// In en, this message translates to:
  /// **'What is the best way to store harvested maize?'**
  String get storeMaize;

  /// Improve soil question
  ///
  /// In en, this message translates to:
  /// **'How can I improve soil fertility naturally?'**
  String get improveSoil;

  /// Fertilizers vegetables question
  ///
  /// In en, this message translates to:
  /// **'Which fertilizers are recommended for vegetables?'**
  String get fertilizersVegetables;

  /// Livestock winter question
  ///
  /// In en, this message translates to:
  /// **'How do I take care of livestock during winter?'**
  String get livestockWinter;

  /// Plant tomatoes question
  ///
  /// In en, this message translates to:
  /// **'When is the best time to plant tomatoes?'**
  String get plantTomatoes;

  /// Water crops question
  ///
  /// In en, this message translates to:
  /// **'How often should I water my crops?'**
  String get waterCrops;

  /// AI couldn't understand message
  ///
  /// In en, this message translates to:
  /// **'I couldn\'t understand that.'**
  String get couldNotUnderstand;

  /// Enter question placeholder text
  ///
  /// In en, this message translates to:
  /// **'Enter a question here'**
  String get enterQuestion;

  /// Farm Profile page title
  ///
  /// In en, this message translates to:
  /// **'Farm Profile'**
  String get farmProfile;

  /// My Farm Profile page title
  ///
  /// In en, this message translates to:
  /// **'My Farm Profile'**
  String get myFarmProfile;

  /// Farm Details section title
  ///
  /// In en, this message translates to:
  /// **'Farm Details'**
  String get farmDetails;

  /// Contact Information section title
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Farm Name field label
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Size field label
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Crops field label
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// Livestock field label
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get livestock;

  /// Owner Name field label
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Add Farm Profile button text
  ///
  /// In en, this message translates to:
  /// **'Add Farm Profile'**
  String get addFarmProfile;

  /// Edit Farm Profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit Farm Profile'**
  String get editFarmProfile;

  /// Save Farm Profile button text
  ///
  /// In en, this message translates to:
  /// **'Save Farm Profile'**
  String get saveFarmProfile;

  /// Delete Farm Profile button text
  ///
  /// In en, this message translates to:
  /// **'Delete Farm Profile'**
  String get deleteFarmProfile;

  /// Farm name required validation message
  ///
  /// In en, this message translates to:
  /// **'Farm name is required'**
  String get farmNameRequired;

  /// Location required validation message
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationRequired;

  /// Farm size required validation message
  ///
  /// In en, this message translates to:
  /// **'Farm size is required'**
  String get sizeRequired;

  /// Owner name required validation message
  ///
  /// In en, this message translates to:
  /// **'Owner name is required'**
  String get ownerNameRequired;

  /// Phone number required validation message
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Valid email required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmailRequired;

  /// Valid phone number required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validPhoneRequired;

  /// Farm profile created success message
  ///
  /// In en, this message translates to:
  /// **'Farm profile created successfully'**
  String get farmProfileCreated;

  /// Farm profile updated success message
  ///
  /// In en, this message translates to:
  /// **'Farm profile updated successfully'**
  String get farmProfileUpdated;

  /// Farm profile deleted success message
  ///
  /// In en, this message translates to:
  /// **'Farm profile deleted successfully'**
  String get farmProfileDeleted;

  /// Farm profile error message
  ///
  /// In en, this message translates to:
  /// **'Error managing farm profile'**
  String get farmProfileError;

  /// Confirm delete farm profile message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this farm profile?'**
  String get confirmDelete;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Add Crop button text
  ///
  /// In en, this message translates to:
  /// **'Add Crop'**
  String get addCrop;

  /// Add Livestock button text
  ///
  /// In en, this message translates to:
  /// **'Add Livestock'**
  String get addLivestock;

  /// Enter crop name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter crop name'**
  String get enterCropName;

  /// Enter livestock name placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter livestock name'**
  String get enterLivestockName;

  /// Remove button text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Getting location message
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get gettingLocation;

  /// Location detected success message
  ///
  /// In en, this message translates to:
  /// **'Location detected successfully!'**
  String get locationDetected;

  /// Location detection error message
  ///
  /// In en, this message translates to:
  /// **'Could not detect location. Please enter manually.'**
  String get locationError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['af', 'en', 'st'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'en':
      return AppLocalizationsEn();
    case 'st':
      return AppLocalizationsSt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
