class BudgetMethodModel {
  BudgetMethodModel({
    required this.methodName,
    required this.methodDescription,
  });

  final String methodName;
  final String methodDescription;
}

final listBudgetMethodIndonesia = [
  BudgetMethodModel(
    methodName: '50/30/20',
    methodDescription:
        '50% untuk Kebutuhan: Biaya-biaya yang tidak bisa dihindari seperti sewa rumah, tagihan listrik, makanan, dan transportasi.\n30% untuk Keinginan: Pengeluaran untuk hiburan, makan di luar, hobi, dan lain-lain.\n20% untuk Tabungan dan Pelunasan Utang: Menabung untuk masa depan atau melunasi utang.',
  ),
  BudgetMethodModel(
    methodName: 'Zero-Based Budgeting (ZBB)',
    methodDescription:
        'Setiap pengeluaran harus dibenarkan setiap bulan. Dalam metode ini, pendapatan dikurangi dengan pengeluaran harus mencapai nol, sehingga setiap uang yang masuk memiliki tujuan spesifik.',
  ),
  BudgetMethodModel(
    methodName: 'Pay Yourself First',
    methodDescription:
        'Sebelum membayar tagihan dan kebutuhan lainnya, alokasikan sejumlah uang untuk ditabung atau diinvestasikan terlebih dahulu. Ini memastikan bahwa tabungan menjadi prioritas utama.',
  ),
  BudgetMethodModel(
    methodName: 'Priority-Based Budgeting',
    methodDescription:
        'Fokus pada prioritas utama keluarga. Misalnya, pendidikan anak, perawatan kesehatan, atau investasi. Pengeluaran disesuaikan dengan prioritas yang telah ditentukan.',
  ),
  BudgetMethodModel(
    methodName: 'Reverse Budgeting',
    methodDescription:
        'Memprioritaskan menabung atau investasi terlebih dahulu dan menggunakan sisa uang untuk kebutuhan sehari-hari. Ini memastikan bahwa tujuan finansial jangka panjang tercapai.',
  ),
  BudgetMethodModel(
    methodName: 'Flexible Budgeting',
    methodDescription:
        'Mengalokasikan sejumlah uang untuk kebutuhan dan keinginan, tetapi tetap fleksibel dalam pengeluaran. Ini memungkinkan untuk menyesuaikan anggaran sesuai kebutuhan.',
  ),
  BudgetMethodModel(
      methodName: '60/20/20',
      methodDescription:
          '60% untuk Kebutuhan: Biaya-biaya yang tidak bisa dihindari seperti sewa rumah, tagihan listrik, makanan, dan transportasi.\n20% untuk Keinginan: Pengeluaran untuk hiburan, makan di luar, hobi, dan lain-lain.\n20% untuk Tabungan dan Pelunasan Utang: Menabung untuk masa depan atau melunasi utang.',),
  BudgetMethodModel(
    methodName: '70/20/10',
    methodDescription:
        '70% untuk Kebutuhan: Biaya-biaya yang tidak bisa dihindari seperti sewa rumah, tagihan listrik, makanan, dan transportasi.\n20% untuk Keinginan: Pengeluaran untuk hiburan, makan di luar, hobi, dan lain-lain.\n10% untuk Tabungan dan Pelunasan Utang: Menabung untuk masa depan atau melunasi utang.',
  ),
  BudgetMethodModel(
    methodName: '80/10/10',
    methodDescription:
        '80% untuk Kebutuhan: Biaya-biaya yang tidak bisa dihindari seperti sewa rumah, tagihan listrik, makanan, dan transportasi.\n10% untuk Keinginan: Pengeluaran untuk hiburan, makan di luar, hobi, dan lain-lain.\n10% untuk Tabungan dan Pelunasan Utang: Menabung untuk masa depan atau melunasi utang.',
  ),
  BudgetMethodModel(
    methodName: 'No method',
    methodDescription: 'Tidak menggunakan metode anggaran tertentu.',
  ),
];

final listBudgetMethodEnglish = [
  BudgetMethodModel(
    methodName: '50/30/20',
    methodDescription:
        '50% for Needs: Unavoidable costs such as rent, electricity bills, food, and transportation.\n30% for Wants: Spending on entertainment, eating out, hobbies, and others.\n20% for Savings and Debt Repayment: Saving for the future or paying off debts.',
  ),
  BudgetMethodModel(
    methodName: 'Zero-Based Budgeting (ZBB)',
    methodDescription:
        'Every expense must be justified every month. In this method, income minus expenses must reach zero, so that every incoming money has a specific purpose.',
  ),
  BudgetMethodModel(
    methodName: 'Pay Yourself First',
    methodDescription:
        'Before paying bills and other needs, allocate a sum of money to be saved or invested first. This ensures that savings are the top priority.',
  ),
  BudgetMethodModel(
    methodName: 'Priority-Based Budgeting',
    methodDescription:
        "Focus on the family's top priorities. For example, children's education, healthcare, or investments. Expenses are adjusted to predetermined priorities.",
  ),
  BudgetMethodModel(
    methodName: 'Reverse Budgeting',
    methodDescription:
        'Prioritize saving or investing first and use the remaining money for daily needs. This ensures that long-term financial goals are achieved.',
  ),
  BudgetMethodModel(
    methodName: 'Flexible Budgeting',
    methodDescription:
        'Allocate a sum of money for needs and wants, but remain flexible in spending. This allows for adjusting the budget as needed.',
  ),
  BudgetMethodModel(
      methodName: '60/20/20',
      methodDescription:
          '60% for Needs: Unavoidable costs such as rent, electricity bills, food, and transportation.\n20% for Wants: Spending on entertainment, eating out, hobbies, and others.\n20% for Savings and Debt Repayment: Saving for the future or paying off debts.',),
  BudgetMethodModel(
    methodName: '70/20/10',
    methodDescription:
        '70% for Needs: Unavoidable costs such as rent, electricity bills, food, and transportation.\n20% for Wants: Spending on entertainment, eating out, hobbies, and others.\n10% for Savings and Debt Repayment: Saving for the future or paying off debts.',
  ),
  BudgetMethodModel(
    methodName: '80/10/10',
    methodDescription:
        '80% for Needs: Unavoidable costs such as rent, electricity bills, food, and transportation.\n10% for Wants: Spending on entertainment, eating out, hobbies, and others.\n10% for Savings and Debt Repayment: Saving for the future or paying off debts.',
  ),
  BudgetMethodModel(
    methodName: 'No method',
    methodDescription: 'No specific budgeting method is used.',
  ),
];
