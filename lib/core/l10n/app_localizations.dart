import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @onboardTitle1.
  ///
  /// In id, this message translates to:
  /// **'Mengendalikan Keuangan Anda'**
  String get onboardTitle1;

  /// No description provided for @onboardDesc1.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang di Budget Intelli! Teman keuangan pribadi Anda. Mengendalikan uang Anda dengan mudah dan juga, obrolan berbasis kecerdasan buatan kami siap membantu Anda sepanjang jalan'**
  String get onboardDesc1;

  /// No description provided for @onboardTitle2.
  ///
  /// In id, this message translates to:
  /// **'Mengatur Anggaran dengan Lebih Pintar'**
  String get onboardTitle2;

  /// No description provided for @onboardDesc2.
  ///
  /// In id, this message translates to:
  /// **'Atur anggaran bulanan Anda, lacak pengeluaran, dan hemat dengan lebih efektif'**
  String get onboardDesc2;

  /// No description provided for @onboardTitle3.
  ///
  /// In id, this message translates to:
  /// **'Mempermudah Keuangan Anda'**
  String get onboardTitle3;

  /// No description provided for @onboardDesc3.
  ///
  /// In id, this message translates to:
  /// **'Hubungkan rekening bank, kartu kredit, dan lainnya untuk pelacakan yang lancar. Dapatkan pembaruan real-time dan tetap mengendalikan uang Anda.'**
  String get onboardDesc3;

  /// No description provided for @onboardSkipButton.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get onboardSkipButton;

  /// No description provided for @onboardContinueButton.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get onboardContinueButton;

  /// No description provided for @onboardGetStartedButton.
  ///
  /// In id, this message translates to:
  /// **'Ayo Mulai'**
  String get onboardGetStartedButton;

  /// No description provided for @welcomeScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Ayo Mulai'**
  String get welcomeScreenTitle;

  /// No description provided for @welcomeScreenDesc.
  ///
  /// In id, this message translates to:
  /// **'Mari kita mulai masuk ke akun Anda'**
  String get welcomeScreenDesc;

  /// No description provided for @googleButtonLabel.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan dengan Google'**
  String get googleButtonLabel;

  /// No description provided for @appleButtonLabel.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan dengan Apple'**
  String get appleButtonLabel;

  /// No description provided for @signUpLabel.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get signUpLabel;

  /// No description provided for @signInLabel.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signInLabel;

  /// No description provided for @privacyAndPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get privacyAndPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In id, this message translates to:
  /// **'Syarat Layanan'**
  String get termsOfService;

  /// No description provided for @signUpScreenDesc.
  ///
  /// In id, this message translates to:
  /// **'<Ganti>'**
  String get signUpScreenDesc;

  /// No description provided for @termConditionFirst.
  ///
  /// In id, this message translates to:
  /// **'Saya setuju dengan'**
  String get termConditionFirst;

  /// No description provided for @termConditionSecond.
  ///
  /// In id, this message translates to:
  /// **'Syarat & Ketentuan Budget Intelli'**
  String get termConditionSecond;

  /// No description provided for @signUpBody1.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun?'**
  String get signUpBody1;

  /// No description provided for @textDividerSignUpSignInScreen.
  ///
  /// In id, this message translates to:
  /// **'atau'**
  String get textDividerSignUpSignInScreen;

  /// No description provided for @signInForgotPasswordText.
  ///
  /// In id, this message translates to:
  /// **'Lupa Kata Sandi?'**
  String get signInForgotPasswordText;

  /// No description provided for @forgotPassTitle.
  ///
  /// In id, this message translates to:
  /// **'Lupa kata sandi?'**
  String get forgotPassTitle;

  /// No description provided for @forgotPassDesc.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email yang terkait dengan akun Serrap Anda, dan kami akan mengirimkan Anda kata sandi satu kali (OTP) untuk memulai.'**
  String get forgotPassDesc;

  /// No description provided for @forgotPassTextFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Email Terdaftar Anda'**
  String get forgotPassTextFieldLabel;

  /// No description provided for @otpTitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan Kode OTP'**
  String get otpTitle;

  /// No description provided for @otpDesc.
  ///
  /// In id, this message translates to:
  /// **'Silakan periksa kotak masuk email Anda dan masukkan kode OTP di bawah ini untuk memverifikasi identitas Anda.'**
  String get otpDesc;

  /// No description provided for @otpTextBodyFirst.
  ///
  /// In id, this message translates to:
  /// **'Anda dapat mengirim ulang kode dalam'**
  String get otpTextBodyFirst;

  /// No description provided for @otpTextBodySecond.
  ///
  /// In id, this message translates to:
  /// **'detik'**
  String get otpTextBodySecond;

  /// No description provided for @otpTextBodyThird.
  ///
  /// In id, this message translates to:
  /// **'Kirim Ulang Kode'**
  String get otpTextBodyThird;

  /// No description provided for @otpBottomSheetButtonLabel.
  ///
  /// In id, this message translates to:
  /// **'Kirim Kode OTP'**
  String get otpBottomSheetButtonLabel;

  /// No description provided for @newPassTitle.
  ///
  /// In id, this message translates to:
  /// **'Amanan Akun Anda'**
  String get newPassTitle;

  /// No description provided for @newPassDesc.
  ///
  /// In id, this message translates to:
  /// **'Pilih kata sandi yang kuat dan aman untuk akun Budget Intelli Anda. Ingat untuk menjaga kerahasiaannya.'**
  String get newPassDesc;

  /// No description provided for @newPassTextFieldLabelFirst.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi Baru'**
  String get newPassTextFieldLabelFirst;

  /// No description provided for @newPassTextFieldLabelSecond.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Kata Sandi Baru'**
  String get newPassTextFieldLabelSecond;

  /// No description provided for @newPassBottomSheetButtonLabel.
  ///
  /// In id, this message translates to:
  /// **'Simpan Kata Sandi Baru'**
  String get newPassBottomSheetButtonLabel;

  /// No description provided for @successChangePassTitle.
  ///
  /// In id, this message translates to:
  /// **'Semua Sudah Siap!'**
  String get successChangePassTitle;

  /// No description provided for @successChangePassDesc.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi Anda telah berhasil diubah'**
  String get successChangePassDesc;

  /// No description provided for @successChangePassBottomSheetButton.
  ///
  /// In id, this message translates to:
  /// **'Pergi ke Halaman Utama'**
  String get successChangePassBottomSheetButton;

  /// No description provided for @signUpScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Ayo Daftarkan Akun'**
  String get signUpScreenTitle;

  /// No description provided for @signInScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Ayo Masuk'**
  String get signInScreenTitle;

  /// No description provided for @signInFooter.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun?'**
  String get signInFooter;

  /// No description provided for @nameFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get nameFieldLabel;

  /// No description provided for @homeTitleAfternoon.
  ///
  /// In id, this message translates to:
  /// **'Selamat Siang'**
  String get homeTitleAfternoon;

  /// No description provided for @homeTitleEvening.
  ///
  /// In id, this message translates to:
  /// **'Selamat Malam'**
  String get homeTitleEvening;

  /// No description provided for @homeTitleMorning.
  ///
  /// In id, this message translates to:
  /// **'Selamat Pagi'**
  String get homeTitleMorning;

  /// No description provided for @homeTitleNight.
  ///
  /// In id, this message translates to:
  /// **'Selamat Malam'**
  String get homeTitleNight;

  /// No description provided for @homeTitleError.
  ///
  /// In id, this message translates to:
  /// **'Selamat Datang'**
  String get homeTitleError;

  /// No description provided for @transactionHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Transaksi'**
  String get transactionHistory;

  /// No description provided for @seeAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get seeAll;

  /// No description provided for @transactionHistoryEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada riwayat transaksi'**
  String get transactionHistoryEmpty;

  /// No description provided for @all.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get all;

  /// No description provided for @income.
  ///
  /// In id, this message translates to:
  /// **'Pemasukan'**
  String get income;

  /// No description provided for @spending.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran'**
  String get spending;

  /// No description provided for @schedulePayment.
  ///
  /// In id, this message translates to:
  /// **'Jadwalkan Pembayaran'**
  String get schedulePayment;

  /// No description provided for @schedulePayments.
  ///
  /// In id, this message translates to:
  /// **'Jadwal Pembayaran'**
  String get schedulePayments;

  /// No description provided for @balanceAccountsAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Saldo Akun'**
  String get balanceAccountsAppBarTitle;

  /// No description provided for @balanceAccountsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada saldo akun tersedia'**
  String get balanceAccountsEmpty;

  /// No description provided for @add.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get add;

  /// No description provided for @balanceAccountsAddAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Saldo Akun'**
  String get balanceAccountsAddAppBarTitle;

  /// No description provided for @amountFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get amountFieldLabel;

  /// No description provided for @accountNumberFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Nomor Akun'**
  String get accountNumberFieldLabel;

  /// No description provided for @optional.
  ///
  /// In id, this message translates to:
  /// **'Opsional'**
  String get optional;

  /// No description provided for @accountCategoryFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Kategori Akun'**
  String get accountCategoryFieldLabel;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @areRequired.
  ///
  /// In id, this message translates to:
  /// **'diperlukan'**
  String get areRequired;

  /// No description provided for @profileAccountType.
  ///
  /// In id, this message translates to:
  /// **'Jenis Akun'**
  String get profileAccountType;

  /// No description provided for @darkMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get darkMode;

  /// No description provided for @signOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get signOut;

  /// No description provided for @addSpendingAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Pengeluaran'**
  String get addSpendingAppBarTitle;

  /// No description provided for @addIncomeAppBarTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Pemasukan'**
  String get addIncomeAppBarTitle;

  /// No description provided for @categoryFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get categoryFieldLabel;

  /// No description provided for @addAccountFIeldLabel.
  ///
  /// In id, this message translates to:
  /// **'Tambah Akun'**
  String get addAccountFIeldLabel;

  /// No description provided for @dateFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get dateFieldLabel;

  /// No description provided for @uploadReceiptLabel.
  ///
  /// In id, this message translates to:
  /// **'Unggah Bukti'**
  String get uploadReceiptLabel;

  /// No description provided for @noteFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get noteFieldLabel;

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In id, this message translates to:
  /// **'Mohon isi semua kolom yang diperlukan'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @sourceFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Sumber'**
  String get sourceFieldLabel;

  /// No description provided for @periodFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Periode'**
  String get periodFieldLabel;

  /// No description provided for @totalAmountFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Total Pembayaran'**
  String get totalAmountFieldLabel;

  /// No description provided for @dueDateFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Jatuh Tempo'**
  String get dueDateFieldLabel;

  /// No description provided for @totalRepetitionFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Total Perulangan'**
  String get totalRepetitionFieldLabel;

  /// No description provided for @detail.
  ///
  /// In id, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @addAnother.
  ///
  /// In id, this message translates to:
  /// **'Tambah Lainnya'**
  String get addAnother;

  /// No description provided for @payment.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get payment;

  /// No description provided for @dueDateIn.
  ///
  /// In id, this message translates to:
  /// **'Jatuh tempo dalam'**
  String get dueDateIn;

  /// No description provided for @days.
  ///
  /// In id, this message translates to:
  /// **'hari'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In id, this message translates to:
  /// **'jam'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In id, this message translates to:
  /// **'menit'**
  String get minutes;

  /// No description provided for @aFewSeconds.
  ///
  /// In id, this message translates to:
  /// **'beberapa detik'**
  String get aFewSeconds;

  /// No description provided for @left.
  ///
  /// In id, this message translates to:
  /// **'tersisa'**
  String get left;

  /// No description provided for @remaining.
  ///
  /// In id, this message translates to:
  /// **'Sisa'**
  String get remaining;

  /// No description provided for @createdSuccessFully.
  ///
  /// In id, this message translates to:
  /// **'Berhasil dibuat'**
  String get createdSuccessFully;

  /// No description provided for @updatedSuccessFully.
  ///
  /// In id, this message translates to:
  /// **'Berhasil diperbarui'**
  String get updatedSuccessFully;

  /// No description provided for @history.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get history;

  /// No description provided for @noNote.
  ///
  /// In id, this message translates to:
  /// **'Tanpa catatan'**
  String get noNote;

  /// No description provided for @alreadyPassedDueDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal jatuh tempo sudah lewat'**
  String get alreadyPassedDueDate;

  /// No description provided for @justNow.
  ///
  /// In id, this message translates to:
  /// **'Baru saja'**
  String get justNow;

  /// No description provided for @dAgo.
  ///
  /// In id, this message translates to:
  /// **'hari lalu'**
  String get dAgo;

  /// No description provided for @hAgo.
  ///
  /// In id, this message translates to:
  /// **'jam lalu'**
  String get hAgo;

  /// No description provided for @mAgo.
  ///
  /// In id, this message translates to:
  /// **'menit lalu'**
  String get mAgo;

  /// No description provided for @am.
  ///
  /// In id, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In id, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @jan.
  ///
  /// In id, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In id, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In id, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In id, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In id, this message translates to:
  /// **'Mei'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In id, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In id, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In id, this message translates to:
  /// **'Agu'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In id, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In id, this message translates to:
  /// **'Okt'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In id, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In id, this message translates to:
  /// **'Des'**
  String get dec;

  /// No description provided for @explore.
  ///
  /// In id, this message translates to:
  /// **'Jelajahi'**
  String get explore;

  /// No description provided for @balance.
  ///
  /// In id, this message translates to:
  /// **'Saldo'**
  String get balance;

  /// No description provided for @profile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @chatWithAi.
  ///
  /// In id, this message translates to:
  /// **'Chat dengan AI'**
  String get chatWithAi;

  /// No description provided for @calendarView.
  ///
  /// In id, this message translates to:
  /// **'Tampilan Kalender'**
  String get calendarView;

  /// No description provided for @anErrorOccured.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan.'**
  String get anErrorOccured;

  /// No description provided for @transactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get transactions;

  /// No description provided for @balanceAccountDeleted.
  ///
  /// In id, this message translates to:
  /// **'Saldo akun dihapus'**
  String get balanceAccountDeleted;

  /// No description provided for @failedToLoadBalanceAccount.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat saldo akun'**
  String get failedToLoadBalanceAccount;

  /// No description provided for @noTransactions.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada transaksi'**
  String get noTransactions;

  /// No description provided for @editBalanceAccount.
  ///
  /// In id, this message translates to:
  /// **'Edit Saldo Akun'**
  String get editBalanceAccount;

  /// No description provided for @delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// No description provided for @account.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get account;

  /// No description provided for @failedToLoadAccount.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat account'**
  String get failedToLoadAccount;

  /// No description provided for @areYouSure.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin?'**
  String get areYouSure;

  /// No description provided for @yes.
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get no;

  /// No description provided for @receipt.
  ///
  /// In id, this message translates to:
  /// **'Struk'**
  String get receipt;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get back;

  /// No description provided for @emailIsRequired.
  ///
  /// In id, this message translates to:
  /// **'Email diperlukan'**
  String get emailIsRequired;

  /// No description provided for @passwordIsRequired.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi diperlukan'**
  String get passwordIsRequired;

  /// No description provided for @letsRegisterAccount.
  ///
  /// In id, this message translates to:
  /// **'Ayo Daftarkan Akun'**
  String get letsRegisterAccount;

  /// No description provided for @nameIsRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama diperlukan'**
  String get nameIsRequired;

  /// No description provided for @pleaseAcceptTermsAndConditions.
  ///
  /// In id, this message translates to:
  /// **'Mohon centang syarat dan ketentuan'**
  String get pleaseAcceptTermsAndConditions;

  /// No description provided for @noBalanceAccountFound.
  ///
  /// In id, this message translates to:
  /// **'Belum menambahkan saldo akun'**
  String get noBalanceAccountFound;

  /// No description provided for @noSchedulePaymentsFound.
  ///
  /// In id, this message translates to:
  /// **'Belum ada jadwal pembayaran'**
  String get noSchedulePaymentsFound;

  /// No description provided for @active.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @paid.
  ///
  /// In id, this message translates to:
  /// **'Dibayar'**
  String get paid;

  /// No description provided for @overdue.
  ///
  /// In id, this message translates to:
  /// **'Telat Bayar'**
  String get overdue;

  /// No description provided for @accountBalanceSuccessfullyDeducted.
  ///
  /// In id, this message translates to:
  /// **'Saldo akun berhasil terpotong'**
  String get accountBalanceSuccessfullyDeducted;

  /// No description provided for @currentlyDeducting.
  ///
  /// In id, this message translates to:
  /// **'Sedang memotong'**
  String get currentlyDeducting;

  /// No description provided for @from.
  ///
  /// In id, this message translates to:
  /// **'dari'**
  String get from;

  /// No description provided for @failedToDeduct.
  ///
  /// In id, this message translates to:
  /// **'Gagal memotong'**
  String get failedToDeduct;

  /// No description provided for @increased.
  ///
  /// In id, this message translates to:
  /// **'bertambah'**
  String get increased;

  /// No description provided for @addingBalanceOf.
  ///
  /// In id, this message translates to:
  /// **'Menambahkan saldo sebesar'**
  String get addingBalanceOf;

  /// No description provided for @to.
  ///
  /// In id, this message translates to:
  /// **'ke'**
  String get to;

  /// No description provided for @failed.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get failed;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus akun ini?'**
  String get confirmDeleteAccount;

  /// No description provided for @cencel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cencel;

  /// No description provided for @update.
  ///
  /// In id, this message translates to:
  /// **'Perbarui'**
  String get update;

  /// No description provided for @updatePreviousPaymentFirst.
  ///
  /// In id, this message translates to:
  /// **'Perbarui pembayaran sebelumnya dulu'**
  String get updatePreviousPaymentFirst;

  /// No description provided for @successfullyDeleted.
  ///
  /// In id, this message translates to:
  /// **'Berhasil dihapus'**
  String get successfullyDeleted;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In id, this message translates to:
  /// **'Mata Uang'**
  String get currency;

  /// No description provided for @lightMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Terang'**
  String get lightMode;

  /// No description provided for @todoList.
  ///
  /// In id, this message translates to:
  /// **'Daftar Tugas'**
  String get todoList;

  /// No description provided for @welcomeToBudgetIntelli.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang di Budget Intelli'**
  String get welcomeToBudgetIntelli;

  /// No description provided for @letsCreateBudget.
  ///
  /// In id, this message translates to:
  /// **'Ayo buat anggaran!'**
  String get letsCreateBudget;

  /// No description provided for @budgetPlan.
  ///
  /// In id, this message translates to:
  /// **'Rencana Anggaran'**
  String get budgetPlan;

  /// No description provided for @totalPlannedIncome.
  ///
  /// In id, this message translates to:
  /// **'Pendapatan Direncanakan'**
  String get totalPlannedIncome;

  /// No description provided for @planned.
  ///
  /// In id, this message translates to:
  /// **'Direncanakan'**
  String get planned;

  /// No description provided for @paycheck.
  ///
  /// In id, this message translates to:
  /// **'Gaji'**
  String get paycheck;

  /// No description provided for @leftToBudget.
  ///
  /// In id, this message translates to:
  /// **'tersisa untuk anggaran'**
  String get leftToBudget;

  /// No description provided for @yourName.
  ///
  /// In id, this message translates to:
  /// **'Nama kamu'**
  String get yourName;

  /// No description provided for @budgetName.
  ///
  /// In id, this message translates to:
  /// **'Nama Budget'**
  String get budgetName;

  /// No description provided for @failedToLoadDataFromDatabase.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data dari database'**
  String get failedToLoadDataFromDatabase;

  /// No description provided for @spent.
  ///
  /// In id, this message translates to:
  /// **'Dibelanjakan'**
  String get spent;

  /// No description provided for @expenses.
  ///
  /// In id, this message translates to:
  /// **'Pengeluaran'**
  String get expenses;

  /// No description provided for @budget.
  ///
  /// In id, this message translates to:
  /// **'Anggaran'**
  String get budget;

  /// No description provided for @addCategory.
  ///
  /// In id, this message translates to:
  /// **'Tambah Kategori'**
  String get addCategory;

  /// No description provided for @selectMonth.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bulan'**
  String get selectMonth;

  /// No description provided for @saveSuccessfully.
  ///
  /// In id, this message translates to:
  /// **'Berhasil disimpan'**
  String get saveSuccessfully;

  /// No description provided for @failedToSave.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan'**
  String get failedToSave;

  /// No description provided for @searchIcon.
  ///
  /// In id, this message translates to:
  /// **'Cari Icon'**
  String get searchIcon;

  /// No description provided for @spentOf.
  ///
  /// In id, this message translates to:
  /// **'dibelanjakan dari'**
  String get spentOf;

  /// No description provided for @pickAColor.
  ///
  /// In id, this message translates to:
  /// **'Pilih warna'**
  String get pickAColor;

  /// No description provided for @whereDidYouSpendThisMoney.
  ///
  /// In id, this message translates to:
  /// **'Di mana Anda menghabiskan uang ini?'**
  String get whereDidYouSpendThisMoney;

  /// No description provided for @chooseBudgetCategory.
  ///
  /// In id, this message translates to:
  /// **'Pilih Kategori Anggaran'**
  String get chooseBudgetCategory;

  /// No description provided for @category.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @deleteTransaction.
  ///
  /// In id, this message translates to:
  /// **'Hapus Transaksi'**
  String get deleteTransaction;

  /// No description provided for @confirmDeleteTransaction.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus transaksi ini?'**
  String get confirmDeleteTransaction;

  /// No description provided for @deleteCategory.
  ///
  /// In id, this message translates to:
  /// **'Hapus Kategori'**
  String get deleteCategory;

  /// No description provided for @confirmDelete.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus?'**
  String get confirmDelete;

  /// No description provided for @categoryDeletedSuccessfully.
  ///
  /// In id, this message translates to:
  /// **'Kategori berhasil dihapus'**
  String get categoryDeletedSuccessfully;

  /// No description provided for @deleteGroupCategory.
  ///
  /// In id, this message translates to:
  /// **'Hapus Kategori Grup'**
  String get deleteGroupCategory;

  /// No description provided for @confirmDeleteGroupCategory.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus kategori grup ini?'**
  String get confirmDeleteGroupCategory;

  /// No description provided for @groupCategoryDeleted.
  ///
  /// In id, this message translates to:
  /// **'Kategori Grup dihapus'**
  String get groupCategoryDeleted;

  /// No description provided for @addGroupCategory.
  ///
  /// In id, this message translates to:
  /// **'Tambah Kategori Grup'**
  String get addGroupCategory;

  /// No description provided for @groupNameCannotBeEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama grup tidak boleh kosong'**
  String get groupNameCannotBeEmpty;

  /// No description provided for @categoryNameAndAmountCannotBeEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama kategori dan jumlah tidak boleh kosong'**
  String get categoryNameAndAmountCannotBeEmpty;

  /// No description provided for @letsStart.
  ///
  /// In id, this message translates to:
  /// **'Ayo Mulai!'**
  String get letsStart;

  /// No description provided for @budgetNameCannotBeEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama anggaran tidak boleh kosong'**
  String get budgetNameCannotBeEmpty;

  /// No description provided for @pleaseSelectDateRange.
  ///
  /// In id, this message translates to:
  /// **'Silakan pilih rentang tanggal'**
  String get pleaseSelectDateRange;

  /// No description provided for @notAssignedYet.
  ///
  /// In id, this message translates to:
  /// **'Belum Ditugaskan'**
  String get notAssignedYet;

  /// No description provided for @allAssigned.
  ///
  /// In id, this message translates to:
  /// **'Semua Telah Ditugaskan'**
  String get allAssigned;

  /// No description provided for @noDataAvailable.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data yang tersedia'**
  String get noDataAvailable;

  /// No description provided for @overview.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan'**
  String get overview;

  /// No description provided for @tracking.
  ///
  /// In id, this message translates to:
  /// **'Pelacakan'**
  String get tracking;

  /// No description provided for @insight.
  ///
  /// In id, this message translates to:
  /// **'Wawasan'**
  String get insight;

  /// No description provided for @leftToReceive.
  ///
  /// In id, this message translates to:
  /// **'Sisa Penerimaan'**
  String get leftToReceive;

  /// No description provided for @received.
  ///
  /// In id, this message translates to:
  /// **'Diterima'**
  String get received;

  /// No description provided for @receiptMethod.
  ///
  /// In id, this message translates to:
  /// **'Metode Penerimaan'**
  String get receiptMethod;

  /// No description provided for @receivedOf.
  ///
  /// In id, this message translates to:
  /// **'diterima dari'**
  String get receivedOf;

  /// No description provided for @daily.
  ///
  /// In id, this message translates to:
  /// **'Harian'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In id, this message translates to:
  /// **'Mingguan'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In id, this message translates to:
  /// **'Bulanan'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In id, this message translates to:
  /// **'Tahunan'**
  String get yearly;

  /// No description provided for @searchTransactions.
  ///
  /// In id, this message translates to:
  /// **'Cari Transaksi'**
  String get searchTransactions;

  /// No description provided for @selectCategory.
  ///
  /// In id, this message translates to:
  /// **'Pilih Kategori'**
  String get selectCategory;

  /// No description provided for @selectBudget.
  ///
  /// In id, this message translates to:
  /// **'Pilih Anggaran'**
  String get selectBudget;

  /// No description provided for @selectFrequency.
  ///
  /// In id, this message translates to:
  /// **'Pilih Frekuensi'**
  String get selectFrequency;

  /// No description provided for @newBudget.
  ///
  /// In id, this message translates to:
  /// **'Anggaran Baru'**
  String get newBudget;

  /// No description provided for @newGroup.
  ///
  /// In id, this message translates to:
  /// **'Grup Baru'**
  String get newGroup;

  /// No description provided for @deleteBudget.
  ///
  /// In id, this message translates to:
  /// **'Hapus Anggaran'**
  String get deleteBudget;

  /// No description provided for @confirmDeleteBudget.
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin menghapus anggaran ini?'**
  String get confirmDeleteBudget;

  /// No description provided for @noBudgetCreatedYet.
  ///
  /// In id, this message translates to:
  /// **'Belum ada anggaran yang dibuat'**
  String get noBudgetCreatedYet;

  /// No description provided for @categoryName.
  ///
  /// In id, this message translates to:
  /// **'Nama Kategori'**
  String get categoryName;

  /// No description provided for @incomeCategoryTotals.
  ///
  /// In id, this message translates to:
  /// **'Total Kategori Pendapatan'**
  String get incomeCategoryTotals;

  /// No description provided for @spendingCategoryTotals.
  ///
  /// In id, this message translates to:
  /// **'Total Kategori Pengeluaran'**
  String get spendingCategoryTotals;

  /// No description provided for @select.
  ///
  /// In id, this message translates to:
  /// **'Pilih'**
  String get select;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @selectDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal'**
  String get selectDate;

  /// No description provided for @allBudgets.
  ///
  /// In id, this message translates to:
  /// **'Semua Anggaran'**
  String get allBudgets;

  /// No description provided for @netWorthTracker.
  ///
  /// In id, this message translates to:
  /// **'Pelacak Kekayaan Bersih'**
  String get netWorthTracker;

  /// No description provided for @addAsset.
  ///
  /// In id, this message translates to:
  /// **'Tambah Aset'**
  String get addAsset;

  /// No description provided for @addLiability.
  ///
  /// In id, this message translates to:
  /// **'Tambah Kewajiban'**
  String get addLiability;

  /// No description provided for @assetName.
  ///
  /// In id, this message translates to:
  /// **'Nama Aset'**
  String get assetName;

  /// No description provided for @value.
  ///
  /// In id, this message translates to:
  /// **'Nilai'**
  String get value;

  /// No description provided for @description.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get description;

  /// No description provided for @liability.
  ///
  /// In id, this message translates to:
  /// **'Kewajiban'**
  String get liability;

  /// No description provided for @categoryBreakdown.
  ///
  /// In id, this message translates to:
  /// **'Pembagian Kategori'**
  String get categoryBreakdown;

  /// No description provided for @incomeVsSpending.
  ///
  /// In id, this message translates to:
  /// **'Pendapatan vs Pengeluaran'**
  String get incomeVsSpending;

  /// No description provided for @exceedsBudget.
  ///
  /// In id, this message translates to:
  /// **'Melebihi Anggaran'**
  String get exceedsBudget;

  /// No description provided for @netWorth.
  ///
  /// In id, this message translates to:
  /// **'Kekayaan Bersih'**
  String get netWorth;

  /// No description provided for @totalAsset.
  ///
  /// In id, this message translates to:
  /// **'Total Aset'**
  String get totalAsset;

  /// No description provided for @totalLiability.
  ///
  /// In id, this message translates to:
  /// **'Total Kewajiban'**
  String get totalLiability;

  /// No description provided for @edit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get edit;

  /// No description provided for @editCategory.
  ///
  /// In id, this message translates to:
  /// **'Ubah Kategori'**
  String get editCategory;

  /// No description provided for @categoryNameExistsIn.
  ///
  /// In id, this message translates to:
  /// **'Nama kategori sudah ada di'**
  String get categoryNameExistsIn;

  /// No description provided for @enterUniqueCategoryName.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama kategori yang unik'**
  String get enterUniqueCategoryName;

  /// No description provided for @noExpensesCategoryAdded.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada kategori pengeluaran yang ditambahkan'**
  String get noExpensesCategoryAdded;

  /// No description provided for @typeCategoryName.
  ///
  /// In id, this message translates to:
  /// **'Ketik nama kategori'**
  String get typeCategoryName;

  /// No description provided for @selectCategory2.
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori'**
  String get selectCategory2;

  /// No description provided for @groupName.
  ///
  /// In id, this message translates to:
  /// **'Nama Grup'**
  String get groupName;

  /// No description provided for @selectGroup.
  ///
  /// In id, this message translates to:
  /// **'Pilih Grup'**
  String get selectGroup;

  /// No description provided for @alreadyExists.
  ///
  /// In id, this message translates to:
  /// **'Sudah ada'**
  String get alreadyExists;

  /// No description provided for @firstGroupMustBeIncome.
  ///
  /// In id, this message translates to:
  /// **'Grup pertama harus berupa pendapatan'**
  String get firstGroupMustBeIncome;

  /// No description provided for @selectCategoryWithSameType.
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori dengan tipe yang sama'**
  String get selectCategoryWithSameType;

  /// No description provided for @selectGroupWithSameType.
  ///
  /// In id, this message translates to:
  /// **'Pilih grup dengan tipe yang sama'**
  String get selectGroupWithSameType;

  /// No description provided for @failedToAddCategory.
  ///
  /// In id, this message translates to:
  /// **'Gagal menambahkan kategori, silakan coba lagi.'**
  String get failedToAddCategory;

  /// No description provided for @thisCategoryIs.
  ///
  /// In id, this message translates to:
  /// **'Kategori ini adalah'**
  String get thisCategoryIs;

  /// No description provided for @inPreviousBudget.
  ///
  /// In id, this message translates to:
  /// **'di budget sebelumnya'**
  String get inPreviousBudget;

  /// No description provided for @thisCategoryAlreadyUsedInBudget.
  ///
  /// In id, this message translates to:
  /// **'Kategori ini sudah digunakan di budget'**
  String get thisCategoryAlreadyUsedInBudget;

  /// No description provided for @selectDateRange.
  ///
  /// In id, this message translates to:
  /// **'Pilih rentang tanggal'**
  String get selectDateRange;

  /// No description provided for @accountBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo Akun'**
  String get accountBalance;

  /// No description provided for @selectAccount.
  ///
  /// In id, this message translates to:
  /// **'Pilih Akun'**
  String get selectAccount;

  /// No description provided for @accountTransaction.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Akun'**
  String get accountTransaction;

  /// No description provided for @method.
  ///
  /// In id, this message translates to:
  /// **'Metode'**
  String get method;

  /// No description provided for @accountTransfer.
  ///
  /// In id, this message translates to:
  /// **'Transfer Akun'**
  String get accountTransfer;

  /// No description provided for @transferTo.
  ///
  /// In id, this message translates to:
  /// **'Transfer ke'**
  String get transferTo;

  /// No description provided for @selectDifferentAccount.
  ///
  /// In id, this message translates to:
  /// **'Pilih akun yang berbeda'**
  String get selectDifferentAccount;

  /// No description provided for @categoryNameAlreadyExists.
  ///
  /// In id, this message translates to:
  /// **'Kategori dengan nama ini sudah ada'**
  String get categoryNameAlreadyExists;

  /// No description provided for @unlockPremiumFeatures.
  ///
  /// In id, this message translates to:
  /// **'Buka Fitur Premium'**
  String get unlockPremiumFeatures;

  /// No description provided for @unlimitedBudgets.
  ///
  /// In id, this message translates to:
  /// **'Anggaran Tak Terbatas'**
  String get unlimitedBudgets;

  /// No description provided for @unlimitedCategories.
  ///
  /// In id, this message translates to:
  /// **'Kategori Tak Terbatas'**
  String get unlimitedCategories;

  /// No description provided for @unlimitedTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Tak Terbatas'**
  String get unlimitedTransactions;

  /// No description provided for @adFreeExperience.
  ///
  /// In id, this message translates to:
  /// **'Pengalaman Tanpa Iklan'**
  String get adFreeExperience;

  /// No description provided for @uploadingReceipts.
  ///
  /// In id, this message translates to:
  /// **'Mengunggah Struk'**
  String get uploadingReceipts;

  /// No description provided for @exportingData.
  ///
  /// In id, this message translates to:
  /// **'Mengekspor Data'**
  String get exportingData;

  /// No description provided for @backupDataToCloud.
  ///
  /// In id, this message translates to:
  /// **'Cadangkan data ke cloud'**
  String get backupDataToCloud;

  /// No description provided for @getPremium.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan Premium'**
  String get getPremium;

  /// No description provided for @annual.
  ///
  /// In id, this message translates to:
  /// **'Tahunan'**
  String get annual;

  /// No description provided for @savings.
  ///
  /// In id, this message translates to:
  /// **'Lebih Hemat'**
  String get savings;

  /// No description provided for @buyPremium.
  ///
  /// In id, this message translates to:
  /// **'Beli Premium'**
  String get buyPremium;

  /// No description provided for @continueWithoutLogin.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan tanpa login'**
  String get continueWithoutLogin;

  /// No description provided for @requestFeature.
  ///
  /// In id, this message translates to:
  /// **'Minta Fitur atau kirim masukan'**
  String get requestFeature;

  /// No description provided for @successfullyChanged.
  ///
  /// In id, this message translates to:
  /// **'Berhasil diubah'**
  String get successfullyChanged;

  /// No description provided for @anErrorOccurred.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan'**
  String get anErrorOccurred;

  /// No description provided for @pleaseInputYourIncome.
  ///
  /// In id, this message translates to:
  /// **'Harap masukkan pendapatan Anda'**
  String get pleaseInputYourIncome;

  /// No description provided for @myIncomeIs.
  ///
  /// In id, this message translates to:
  /// **'Pendapatan saya adalah...'**
  String get myIncomeIs;

  /// No description provided for @pleaseInputAdditionalContext.
  ///
  /// In id, this message translates to:
  /// **'Harap masukkan konteks tambahan'**
  String get pleaseInputAdditionalContext;

  /// No description provided for @noMethodSelected.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada metode yang dipilih'**
  String get noMethodSelected;

  /// No description provided for @generateWithAI.
  ///
  /// In id, this message translates to:
  /// **'Buat dengan AI'**
  String get generateWithAI;

  /// No description provided for @budgetGeneratedSuccessfully.
  ///
  /// In id, this message translates to:
  /// **'Anggaran Berhasil Dibuat'**
  String get budgetGeneratedSuccessfully;

  /// No description provided for @pleaseInputYourBudgetName.
  ///
  /// In id, this message translates to:
  /// **'Harap masukkan nama anggaran Anda'**
  String get pleaseInputYourBudgetName;

  /// No description provided for @pleaseWait.
  ///
  /// In id, this message translates to:
  /// **'Harap tunggu...'**
  String get pleaseWait;

  /// No description provided for @generatingBudget.
  ///
  /// In id, this message translates to:
  /// **'Sedang membuat anggaran...'**
  String get generatingBudget;

  /// No description provided for @createBudgetPlan.
  ///
  /// In id, this message translates to:
  /// **'Buat Rencana Anggaran'**
  String get createBudgetPlan;

  /// No description provided for @youCanCreateYourBudgetWithAIOrManuallyWhichOneDoYouPrefer.
  ///
  /// In id, this message translates to:
  /// **'Anda dapat membuat anggaran dengan AI atau secara manual. Mana yang Anda pilih?'**
  String get youCanCreateYourBudgetWithAIOrManuallyWhichOneDoYouPrefer;

  /// No description provided for @manual.
  ///
  /// In id, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @failedToGenerateBudgetPleaseTryAgain.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat anggaran. Harap coba lagi.'**
  String get failedToGenerateBudgetPleaseTryAgain;

  /// No description provided for @analysisResult.
  ///
  /// In id, this message translates to:
  /// **'Hasil Analisis'**
  String get analysisResult;

  /// No description provided for @overSpendCategory.
  ///
  /// In id, this message translates to:
  /// **'Kategori Pengeluaran Berlebih'**
  String get overSpendCategory;

  /// No description provided for @actual.
  ///
  /// In id, this message translates to:
  /// **'Aktual'**
  String get actual;

  /// No description provided for @trend.
  ///
  /// In id, this message translates to:
  /// **'Tren'**
  String get trend;

  /// No description provided for @prediction.
  ///
  /// In id, this message translates to:
  /// **'Prediksi'**
  String get prediction;

  /// No description provided for @recommendation.
  ///
  /// In id, this message translates to:
  /// **'Rekomendasi'**
  String get recommendation;

  /// No description provided for @analyzeYourBudgetWithAI.
  ///
  /// In id, this message translates to:
  /// **'Analisis anggaran Anda dengan AI'**
  String get analyzeYourBudgetWithAI;

  /// No description provided for @aiIsNotAvailableYet.
  ///
  /// In id, this message translates to:
  /// **'AI belum tersedia'**
  String get aiIsNotAvailableYet;

  /// No description provided for @analysisError.
  ///
  /// In id, this message translates to:
  /// **'Kesalahan analisis'**
  String get analysisError;

  /// No description provided for @leftToBudget2.
  ///
  /// In id, this message translates to:
  /// **'Belum dianggarkan'**
  String get leftToBudget2;

  /// No description provided for @left2.
  ///
  /// In id, this message translates to:
  /// **'Sisa'**
  String get left2;

  /// No description provided for @summary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan'**
  String get summary;

  /// No description provided for @exportData.
  ///
  /// In id, this message translates to:
  /// **'Ekspor Data'**
  String get exportData;

  /// No description provided for @financialCalculator.
  ///
  /// In id, this message translates to:
  /// **'Kalkulator Keuangan'**
  String get financialCalculator;

  /// No description provided for @firstAnnualInterestRate.
  ///
  /// In id, this message translates to:
  /// **'Suku Bunga Tahunan Pertama*'**
  String get firstAnnualInterestRate;

  /// No description provided for @nextAnnualInterestRate.
  ///
  /// In id, this message translates to:
  /// **'Suku Bunga Tahunan Berikutnya*'**
  String get nextAnnualInterestRate;

  /// No description provided for @mortgageCalculator.
  ///
  /// In id, this message translates to:
  /// **'Kalkulator Hipotek'**
  String get mortgageCalculator;

  /// No description provided for @interestRate.
  ///
  /// In id, this message translates to:
  /// **'Suku bunga*'**
  String get interestRate;

  /// No description provided for @loanAmount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Pinjaman*'**
  String get loanAmount;

  /// No description provided for @loanTermYears.
  ///
  /// In id, this message translates to:
  /// **'Jangka Waktu Pinjaman (tahun)*'**
  String get loanTermYears;

  /// No description provided for @result.
  ///
  /// In id, this message translates to:
  /// **'Hasil'**
  String get result;

  /// No description provided for @monthlyInstallment.
  ///
  /// In id, this message translates to:
  /// **'Cicilan Bulanan'**
  String get monthlyInstallment;

  /// No description provided for @month.
  ///
  /// In id, this message translates to:
  /// **'Bulan'**
  String get month;

  /// No description provided for @calculate.
  ///
  /// In id, this message translates to:
  /// **'Hitung'**
  String get calculate;

  /// No description provided for @deleting.
  ///
  /// In id, this message translates to:
  /// **'Menghapus...'**
  String get deleting;

  /// No description provided for @viewImage.
  ///
  /// In id, this message translates to:
  /// **'Lihat Gambar'**
  String get viewImage;

  /// No description provided for @requestLimitExceeded.
  ///
  /// In id, this message translates to:
  /// **'Sudah melewati batas permintaan'**
  String get requestLimitExceeded;

  /// No description provided for @setPin.
  ///
  /// In id, this message translates to:
  /// **'Atur Pin'**
  String get setPin;

  /// No description provided for @biometricOrPatternLogin.
  ///
  /// In id, this message translates to:
  /// **'Login biometrik atau pola'**
  String get biometricOrPatternLogin;

  /// No description provided for @pleaseAuthenticateToShowBudget.
  ///
  /// In id, this message translates to:
  /// **'Silakan otentikasi untuk menampilkan anggaran Anda'**
  String get pleaseAuthenticateToShowBudget;

  /// No description provided for @oopsBiometricAuthenticationRequired.
  ///
  /// In id, this message translates to:
  /// **'Oops! Otentikasi biometrik diperlukan!'**
  String get oopsBiometricAuthenticationRequired;

  /// No description provided for @noThanks.
  ///
  /// In id, this message translates to:
  /// **'Tidak, terima kasih'**
  String get noThanks;

  /// No description provided for @biometricTemporarilyLockedOut.
  ///
  /// In id, this message translates to:
  /// **'Otentikasi biometrik terkunci sementara. Aplikasi akan ditutup sekarang.'**
  String get biometricTemporarilyLockedOut;

  /// No description provided for @biometricPermanentlyLockedOut.
  ///
  /// In id, this message translates to:
  /// **'Otentikasi biometrik terkunci secara permanen. Pertimbangkan untuk mengatur ulang biometrik Anda.'**
  String get biometricPermanentlyLockedOut;

  /// No description provided for @setUpBiometrics.
  ///
  /// In id, this message translates to:
  /// **'Atur Biometrik'**
  String get setUpBiometrics;

  /// No description provided for @biometricNotSetUp.
  ///
  /// In id, this message translates to:
  /// **'Otentikasi biometrik belum diatur pada perangkat Anda. Apakah Anda ingin mengaturnya sekarang?'**
  String get biometricNotSetUp;

  /// No description provided for @openSettings.
  ///
  /// In id, this message translates to:
  /// **'Buka Pengaturan'**
  String get openSettings;

  /// No description provided for @authenticate.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi'**
  String get authenticate;

  /// No description provided for @notification.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get notification;

  /// No description provided for @goodMorning.
  ///
  /// In id, this message translates to:
  /// **'Selamat pagi, pahlawan finansial!'**
  String get goodMorning;

  /// No description provided for @startYourDay.
  ///
  /// In id, this message translates to:
  /// **'Mulai harimu dengan mencatat pengeluaran di Budget Intelli. Setiap langkah kecil menuju keuangan yang lebih baik!'**
  String get startYourDay;

  /// No description provided for @helloHowAreYou.
  ///
  /// In id, this message translates to:
  /// **'Hai, bagaimana harimu?'**
  String get helloHowAreYou;

  /// No description provided for @timeToTakeABreak.
  ///
  /// In id, this message translates to:
  /// **'Saatnya istirahat sejenak dan cek transaksi harianmu di Budget Intelli. Tetap terorganisir untuk masa depan!'**
  String get timeToTakeABreak;

  /// No description provided for @goodNightWiseTracker.
  ///
  /// In id, this message translates to:
  /// **'Selamat malam, pelacak bijak!'**
  String get goodNightWiseTracker;

  /// No description provided for @beforeSleeping.
  ///
  /// In id, this message translates to:
  /// **'Sebelum tidur, jangan lupa catat pengeluaranmu di Budget Intelli. Pastikan semua tercatat dengan rapi!'**
  String get beforeSleeping;

  /// No description provided for @biometricNotSetUp2.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi biometrik belum diatur'**
  String get biometricNotSetUp2;

  /// No description provided for @authenticationFailed.
  ///
  /// In id, this message translates to:
  /// **'Autentikasi Gagal'**
  String get authenticationFailed;

  /// No description provided for @authenticationError.
  ///
  /// In id, this message translates to:
  /// **'Kesalahan Autentikasi'**
  String get authenticationError;

  /// No description provided for @setUp.
  ///
  /// In id, this message translates to:
  /// **'Atur'**
  String get setUp;

  /// No description provided for @groupNameAlreadyExists.
  ///
  /// In id, this message translates to:
  /// **'Nama grup sudah ada'**
  String get groupNameAlreadyExists;

  /// No description provided for @iconList.
  ///
  /// In id, this message translates to:
  /// **'Daftar Ikon'**
  String get iconList;

  /// No description provided for @accountName.
  ///
  /// In id, this message translates to:
  /// **'Nama Akun'**
  String get accountName;

  /// No description provided for @close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get close;

  /// No description provided for @addSchedulePayment.
  ///
  /// In id, this message translates to:
  /// **'Tambah Pembayaran Terjadwal'**
  String get addSchedulePayment;

  /// No description provided for @repetition.
  ///
  /// In id, this message translates to:
  /// **'Pengulangan'**
  String get repetition;

  /// No description provided for @goalAmount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Target'**
  String get goalAmount;

  /// No description provided for @startingBalance.
  ///
  /// In id, this message translates to:
  /// **'Saldo Awal'**
  String get startingBalance;

  /// No description provided for @goalDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Target'**
  String get goalDate;

  /// No description provided for @toHitYourGoalOn.
  ///
  /// In id, this message translates to:
  /// **'Untuk mencapai target pada tanggal ini, Anda perlu menabung'**
  String get toHitYourGoalOn;

  /// No description provided for @perMonth.
  ///
  /// In id, this message translates to:
  /// **'per bulan.'**
  String get perMonth;

  /// No description provided for @assignToCurrentBudget.
  ///
  /// In id, this message translates to:
  /// **'Tugaskan ke Anggaran Saat Ini'**
  String get assignToCurrentBudget;

  /// No description provided for @goal.
  ///
  /// In id, this message translates to:
  /// **'Target'**
  String get goal;

  /// No description provided for @goalName.
  ///
  /// In id, this message translates to:
  /// **'Nama Target'**
  String get goalName;

  /// No description provided for @year.
  ///
  /// In id, this message translates to:
  /// **'Tahun'**
  String get year;

  /// No description provided for @suggested.
  ///
  /// In id, this message translates to:
  /// **'Disarankan'**
  String get suggested;

  /// No description provided for @startDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Mulai'**
  String get startDate;

  /// No description provided for @addGoal.
  ///
  /// In id, this message translates to:
  /// **'Tambah Target'**
  String get addGoal;

  /// No description provided for @deleteGoal.
  ///
  /// In id, this message translates to:
  /// **'Hapus Target'**
  String get deleteGoal;

  /// No description provided for @editGoal.
  ///
  /// In id, this message translates to:
  /// **'Ubah Goal'**
  String get editGoal;

  /// No description provided for @notStarted.
  ///
  /// In id, this message translates to:
  /// **'Belum dimulai'**
  String get notStarted;

  /// No description provided for @daysToGo.
  ///
  /// In id, this message translates to:
  /// **'hari lagi'**
  String get daysToGo;

  /// No description provided for @ofLocalize.
  ///
  /// In id, this message translates to:
  /// **'dari'**
  String get ofLocalize;

  /// No description provided for @saved.
  ///
  /// In id, this message translates to:
  /// **'tersimpan'**
  String get saved;

  /// No description provided for @selectGoalPeriod.
  ///
  /// In id, this message translates to:
  /// **'Pilih periode tujuan'**
  String get selectGoalPeriod;

  /// No description provided for @perDayOr.
  ///
  /// In id, this message translates to:
  /// **'per hari atau'**
  String get perDayOr;

  /// No description provided for @addComment.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan Komentar'**
  String get addComment;

  /// No description provided for @recordTransaction.
  ///
  /// In id, this message translates to:
  /// **'Catat Transaksi'**
  String get recordTransaction;

  /// No description provided for @day.
  ///
  /// In id, this message translates to:
  /// **'Hari'**
  String get day;

  /// No description provided for @week.
  ///
  /// In id, this message translates to:
  /// **'Minggu'**
  String get week;

  /// No description provided for @settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// No description provided for @member.
  ///
  /// In id, this message translates to:
  /// **'Anggota'**
  String get member;

  /// No description provided for @financialTracker.
  ///
  /// In id, this message translates to:
  /// **'Pelacak Keuangan'**
  String get financialTracker;

  /// No description provided for @categoryRequired.
  ///
  /// In id, this message translates to:
  /// **'Kategori diperlukan'**
  String get categoryRequired;

  /// No description provided for @accountRequired.
  ///
  /// In id, this message translates to:
  /// **'Akun diperlukan'**
  String get accountRequired;

  /// No description provided for @amountRequired.
  ///
  /// In id, this message translates to:
  /// **'Jumlah diperlukan'**
  String get amountRequired;

  /// No description provided for @at.
  ///
  /// In id, this message translates to:
  /// **'di'**
  String get at;

  /// No description provided for @startBudgeting.
  ///
  /// In id, this message translates to:
  /// **'Mulai Menganggarkan'**
  String get startBudgeting;

  /// No description provided for @startFinancialTracking.
  ///
  /// In id, this message translates to:
  /// **'Mulai Pelacakan Keuangan'**
  String get startFinancialTracking;

  /// No description provided for @systemMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Sistem'**
  String get systemMode;

  /// No description provided for @addAdditionalContext.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan Konteks Tambahan'**
  String get addAdditionalContext;

  /// No description provided for @example.
  ///
  /// In id, this message translates to:
  /// **'Contoh'**
  String get example;

  /// No description provided for @addAdditionalContextDesc.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan konteks tambahan...\nContoh: Saya memiliki hutang 10000, Tujuan saya adalah menyimpan 1200, Saya memiliki 3 anak, Saya memiliki 1 rumah, Saya memiliki 1 hewan peliharaan, Anggaran maksimum untuk makanan adalah 1000'**
  String get addAdditionalContextDesc;

  /// No description provided for @selectBudgetMethod.
  ///
  /// In id, this message translates to:
  /// **'Pilih Metode Anggaran'**
  String get selectBudgetMethod;

  /// No description provided for @networkError.
  ///
  /// In id, this message translates to:
  /// **'Kesalahan jaringan. Silakan periksa koneksi internet Anda dan coba lagi.'**
  String get networkError;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
