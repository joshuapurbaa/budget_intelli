class AppStrings {
  AppStrings._();

  static const String successDeleteBalanceAccount =
      'Account deleted successfully';
  static const String successEditBalanceAccount = 'Account edited successfully';
  static const String user = 'user';
  static const String model = 'model';
  static const String messagesDB = 'messages';
  static const String incomeType = 'income';
  static const String expenseType = 'expense';
  static const String indonesia = 'Indonesia';
  static const String annualSubscription = 'annual_subscription';
  static const String monthlySubscription = 'monthly_subscription';
  static const String incomeInfoID = '''
Berapa banyak uang yang Anda hasilkan? Ini harus mencakup semua pendapatan Anda. Contoh:\n\n- Gaji\n- Bonus\n- Tunjangan\n- Pendapatan sewa\n- Hadiah\n- Uang saku\n- dll.\n\nSatu-satunya hal yang mungkin tidak Anda sertakan di sini adalah uang yang tidak Anda terima secara teratur, seperti dividen dari investasi, karena tidak menambah uang harian Anda yang tersedia.
''';

  static const String expenseInfoID = '''
Berapa banyak uang yang Anda habiskan? Ini harus mencakup semua pengeluaran Anda, baik itu harian, mingguan, dua mingguan, atau bulanan. Contoh:\n\nPerumahan\n- Sewa atau hipotek\n- Pajak properti\n- Asuransi pemilik rumah atau penyewa\n- Pemeliharaan dan perbaikan\n- Utilitas (listrik, air, gas, dll.)\n\nTransportasi\n- Pembayaran mobil\n- Bahan bakar\n- Pemeliharaan dan perbaikan\n- Transportasi umum\n- Asuransi\n- Registrasi dan lisensi\n\nMakanan\n- Belanjaan\n- Makan di luar\n- Makanan ringan dan minuman\n\nPembayaran Utang\n- Pembayaran kartu kredit\n- Pinjaman mahasiswa\n- Pinjaman pribadi\n- Utang lainnya\n\nTabungan dan Investasi\n- Dana darurat\n- Akun pensiun (401(k), IRA, dll.)\n- Tabungan lainnya (liburan, uang muka, dll.)\n- Akun investasi\n\nKesehatan dan Asuransi\n- Asuransi kesehatan\n- Asuransi jiwa\n- Biaya medis (kunjungan dokter, resep, dll.)\n- Perawatan gigi dan mata\n\nPribadi dan Keluarga\n- Pengasuhan anak atau biaya sekolah\n- Pakaian\n- Perawatan pribadi (potong rambut, kosmetik, dll.)\n- Langganan dan keanggotaan (gym, majalah, dll.)\n\nHiburan dan Rekreasi\n- Hobi\n- Perjalanan dan liburan\n- Film, konser, dan acara\n- Layanan streaming dan hiburan lainnya\n\nLain-lain\n- Hadiah dan donasi\n- Perawatan hewan peliharaan\n- Pengeluaran tak terduga\n- Pengeluaran pribadi lainnya\n\nPajak\n- Pajak penghasilan\n- Pajak properti\n- Pajak lainnya
''';

  static const String incomeInfoEN = '''
How much money do you earn? This should include all your income. Example:\n\n- Salary\n- Bonuses\n- Allowances\n- Rent income\n- Gifts\n- Pocket money\n- ext.\n\nThe only thing you might not include here is money you don’t receive regularly, like dividends from investments, because it doesn’t add to your available daily money.
''';

  static const String expenseInfoEN = '''
How much money do you spend? This should include all your expenses, Whether it’s daily, weekly, fortnightly, or monthly include it all. Example:\n\nHousing\n- Rent or mortgage\n- Property taxes\n- Homeowners or renters insurance\n- Maintenance and repairs\n- Utilities (electricity, water, gas, etc.)\n\nTransportation\n- Car payments\n- Fuel\n- Maintenance and repairs\n- Public transportation\n- Insurance\n- Registration and licensing\n\nFood\n- Groceries\n- Dining out\n- Snacks and beverages\n\nDebt Repayment\n- Credit card payments\n- Student loans\n- Personal loans\n- Other debts\n\nSavings and Investments\n- Emergency fund\n- Retirement accounts (401(k), IRA, etc.)\n- Other savings (vacation, down payment, etc.)\n- Investment accounts\n\nHealth and Insurance\n- Health insurance\n- Life insurance\n- Medical expenses (doctor visits, prescriptions, etc.)\n- Dental and vision care\n\nPersonal and Family\n- Childcare or school expenses\n- Clothing\n- Personal care (haircuts, cosmetics, etc.)\n- Subscriptions and memberships (gym, magazines, etc.)\n\nEntertainment and Recreation\n- Hobbies\n- Travel and vacations\n- Movies, concerts, and events\n- Streaming services and other entertainment\n\nMiscellaneous\n- Gifts and donations\n- Pet care\n- Unexpected expenses\n- Miscellaneous personal expenses\n\nTaxes\n- Income taxes\n- Property taxes\n- Other taxes
''';

  static List<String> monthListEn = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static List<String> monthListID = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static List<String> monthListFullEn = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static List<String> monthListFullId = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
}
