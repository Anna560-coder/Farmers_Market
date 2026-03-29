// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get appTitle => 'Boere App';

  @override
  String get home => 'Tuis';

  @override
  String get favorite => 'Gunsteling';

  @override
  String get profile => 'Profiel';

  @override
  String get tasks => 'Take';

  @override
  String get ai => 'AI';

  @override
  String get weatherUpdates => 'Weer Opdaterings';

  @override
  String get order => 'Bestelling';

  @override
  String get paymentMethod => 'Betaalmetode';

  @override
  String get notifications => 'Kennisgewings';

  @override
  String get aboutUs => 'Oor Ons';

  @override
  String get logOut => 'Teken Uit';

  @override
  String get language => 'Taal';

  @override
  String get selectLanguage => 'Kies Taal';

  @override
  String get english => 'Engels';

  @override
  String get sesotho => 'Sesotho';

  @override
  String get afrikaans => 'Afrikaans';

  @override
  String get settings => 'Instellings';

  @override
  String get email => 'E-pos';

  @override
  String get password => 'Wagwoord';

  @override
  String get name => 'Naam';

  @override
  String get confirmPassword => 'Bevestig Wagwoord';

  @override
  String get selectRole => 'Kies Rol';

  @override
  String get admin => 'Admin';

  @override
  String get user => 'Gebruiker';

  @override
  String get login => 'Teken In';

  @override
  String get signup => 'Registreer';

  @override
  String get dontHaveAccount => 'Het jy nie \'n rekening nie? ';

  @override
  String get signupHere => 'Registreer hier';

  @override
  String get alreadyHaveAccount => 'Het jy reeds \'n rekening? ';

  @override
  String get loginHere => 'Teken hier in';

  @override
  String get emailRequired => 'E-pos word vereis';

  @override
  String get validEmail => 'Voer \'n geldige e-pos in';

  @override
  String get passwordRequired => 'Wagwoord word vereis';

  @override
  String get passwordMinLength => 'Wagwoord moet ten minste 6 karakters wees';

  @override
  String get nameRequired => 'Naam word vereis';

  @override
  String get confirmPasswordRequired => 'Bevestig asseblief jou wagwoord';

  @override
  String get passwordsDoNotMatch => 'Wagwoorde stem nie ooreen nie';

  @override
  String accountNotRole(String role) {
    return 'Jou rekening is nie $role nie';
  }

  @override
  String get signupSuccessful => 'Registrasie suksesvol! Teken nou in';

  @override
  String signupFailed(String error) {
    return 'Registrasie het misluk: $error';
  }

  @override
  String error(String message) {
    return 'Fout: $message';
  }

  @override
  String get aiFeatures => 'AI Kenmerke';

  @override
  String get textToImage => 'Teks ➝ Beeld';

  @override
  String get generateImageFromText => 'Genereer beeld van teks instruksies';

  @override
  String get aiChatbot => 'AI Chatbot';

  @override
  String get converseWithGemini => 'Praat met Gemini AI';

  @override
  String get imagePrompt => 'Beeld + Instruksie';

  @override
  String get askAiAboutImages => 'Vra AI oor jou beelde';

  @override
  String get chatbotScreen => 'Chatbot Skerm';

  @override
  String get textToImageTitle => 'Teks na Beeld';

  @override
  String get enterYourQuery => 'Voer jou navraag in';

  @override
  String get generate => 'Genereer';

  @override
  String get mostAskedQuestions => 'Meest Gevraagde Vrae';

  @override
  String get bestCropsSeason =>
      'Wat is die beste gewasse om hierdie seisoen te plant?';

  @override
  String get preventPests => 'Hoe voorkom ek dat plae my gewasse beskadig?';

  @override
  String get storeMaize =>
      'Wat is die beste manier om geoesde mielies te stoor?';

  @override
  String get improveSoil => 'Hoe kan ek grondvrugbaarheid natuurlik verbeter?';

  @override
  String get fertilizersVegetables =>
      'Watter kunsmis word aanbeveel vir groente?';

  @override
  String get livestockWinter => 'Hoe sorg ek vir vee gedurende die winter?';

  @override
  String get plantTomatoes => 'Wanneer is die beste tyd om tamaties te plant?';

  @override
  String get waterCrops => 'Hoe gereeld moet ek my gewasse water?';

  @override
  String get couldNotUnderstand => 'Ek kon dit nie verstaan nie.';

  @override
  String get enterQuestion => 'Voer \'n vraag hier in';

  @override
  String get farmProfile => 'Plaas Profiel';

  @override
  String get myFarmProfile => 'My Plaas Profiel';

  @override
  String get farmDetails => 'Plaas Besonderhede';

  @override
  String get contactInformation => 'Kontak Inligting';

  @override
  String get farmName => 'Plaas Naam';

  @override
  String get location => 'Ligging';

  @override
  String get size => 'Grootte';

  @override
  String get crops => 'Gewasse';

  @override
  String get livestock => 'Vee';

  @override
  String get ownerName => 'Eienaar Naam';

  @override
  String get phone => 'Telefoon';

  @override
  String get addFarmProfile => 'Voeg Plaas Profiel By';

  @override
  String get editFarmProfile => 'Wysig Plaas Profiel';

  @override
  String get saveFarmProfile => 'Stoor Plaas Profiel';

  @override
  String get deleteFarmProfile => 'Skrap Plaas Profiel';

  @override
  String get farmNameRequired => 'Plaas naam word vereis';

  @override
  String get locationRequired => 'Ligging word vereis';

  @override
  String get sizeRequired => 'Plaas grootte word vereis';

  @override
  String get ownerNameRequired => 'Eienaar naam word vereis';

  @override
  String get phoneRequired => 'Telefoon nommer word vereis';

  @override
  String get validEmailRequired => 'Voer asseblief \'n geldige e-pos adres in';

  @override
  String get validPhoneRequired =>
      'Voer asseblief \'n geldige telefoon nommer in';

  @override
  String get farmProfileCreated => 'Plaas profiel suksesvol geskep';

  @override
  String get farmProfileUpdated => 'Plaas profiel suksesvol opgedateer';

  @override
  String get farmProfileDeleted => 'Plaas profiel suksesvol geskrap';

  @override
  String get farmProfileError => 'Fout met plaas profiel bestuur';

  @override
  String get confirmDelete => 'Is jy seker jy wil hierdie plaas profiel skrap?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get addCrop => 'Voeg Gewas By';

  @override
  String get addLivestock => 'Voeg Vee By';

  @override
  String get enterCropName => 'Voer gewas naam in';

  @override
  String get enterLivestockName => 'Voer vee naam in';

  @override
  String get remove => 'Verwyder';

  @override
  String get gettingLocation => 'Kry jou ligging...';

  @override
  String get locationDetected => 'Ligging suksesvol bespeur!';

  @override
  String get locationError =>
      'Kon nie ligging bespeur nie. Voer asseblief handmatig in.';
}
