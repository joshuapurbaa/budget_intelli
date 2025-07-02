part of 'init_dependencies.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load();

  _initAuth();
  _initGemini();
  _initSchedulePayment();
  _initAiAssistant();
  _initSettings();
  _initBudget();
  _initItemCategory();
  _initGroupCategory();
  _transactions();
  _initBudgetFirestore();
  _initTrackingCategories();
  _initInsight();
  _initNetWorth();
  _initAccount();
  _initiGroupCategoryHistry();
  _initItemCategoryHistry();
  _initItemCategoryTransaction();
  _initRepository();
  _initSchedulePaymentDb();
  _initRepetition();
  _initGoal();
  _initMyPortfolio();
  _insertFinancialCategoryDb();
  _insertFinancialCategoryHistoryDb();
  _initFinancialTransactionDb();
  _initFinancialDashboard();
  _initMemberDb();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  // your preferred provider. Choose from:
  // 1. Debug provider
  // 2. Safety Net provider
  // 3. Play Integrity provider
  // androidProvider: AndroidProvider.debug,
  // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  // your preferred provider. Choose from:
  // 1. Debug provider
  // 2. Device Check provider
  // 3. App Attest provider
  // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  // appleProvider: AppleProvider.appAttest,
  // );

  await MobileAds.instance.initialize();

  sl
    ..registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    )
    ..registerFactory(InternetConnection.new)
    ..registerFactory(
      () => GetUserFirestoreUsecase(sl()),
    )
    ..registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(sl()),
    );
}

void _initAuth() {
  sl
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        sl(),
        sl(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        connectionChecker: sl(),
      ),
    )
    ..registerFactory(() => UserSignUpUsecase(sl()))
    ..registerFactory(() => UserSignIn(sl()))
    ..registerFactory(() => UserSignOut(sl()))
    ..registerFactory(() => GetCurrentUserSessionUsecase(sl()))
    ..registerFactory(() => InsertUserFirestoreUsecase(sl()))
    ..registerFactory(() => UpdateUserFirestoreUsecases(sl()))
    ..registerLazySingleton(
      () => AuthBloc(
        // appUserCubit: serviceLocator(),
        userSignUp: sl(),
        userSignIn: sl(),
        userSignOut: sl(),
        getCurrentUser: sl(),
        getUserCubit: sl(),
      ),
    )
    ..registerLazySingleton(
      () => UserFirestoreCubit(
        getUser: sl(),
        updateUser: sl(),
        insertUserDataUsecase: sl(),
      ),
    );
}

void _initSchedulePayment() {
  sl
    ..registerFactory<SchedulePaymentRemoteDataSource>(
      () => SchedulePaymentRemoteDataSourceImpl(
        sl(),
        sl(),
      ),
    )
    ..registerFactory<SchedulePaymentRepoFire>(
      () => SchedulePaymentRepoImplFire(
        remoteDataSource: sl(),
        connectionChecker: sl(),
      ),
    )
    ..registerFactory(() => GetSchedulePayments(sl()))
    ..registerFactory(() => GetSchedulePayment(sl()))
    ..registerFactory(() => UpdateSchedulePayment(sl()))
    ..registerFactory(() => CreateSchedulePaymentFire(sl()))
    ..registerFactory(() => DeleteSchedulePayment(sl()))
    ..registerLazySingleton(
      () => SchedulePaymentBloc(
        getSchedulePayments: sl(),
      ),
    )
    ..registerLazySingleton(
      () => CudSchedulePaymentBloc(
        updateSchedulePayment: sl(),
        createSchedulePayment: sl(),
        deleteSchedulePayment: sl(),
      ),
    )
    ..registerLazySingleton(
      () => GetSchedulePaymentCubit(
        getSchedulePayment: sl(),
      ),
    );
}

void _initAiAssistant() {
  sl.registerLazySingleton(
    ChatCubit.new,
  );
}

void _initSettings() {
  sl
    ..registerLazySingleton(
      SettingPreferenceRepo.new,
    )
    ..registerLazySingleton(
      UserPreferenceRepo.new,
    )
    ..registerLazySingleton(
      () => SettingBloc(
        preferenceRepository: sl(),
        userPreferenceRepo: sl(),
        pdfRepository: sl(),
      ),
    );
}

void _initBudget() {
  sl
    ..registerFactory<BudgetLocalApi>(
      () => BudgetLocalApiImpl(
        sl(),
      ),
    )
    ..registerFactory<BudgetRepository>(
      () => BudgetRepositoryImpl(
        localDataApi: sl(),
      ),
    )
    ..registerFactory<GroupCategoryRepository>(
      () => GroupCategoryRepositoryImpl(
        localDataApi: sl(),
      ),
    )
    ..registerFactory<ItemCategoryRepository>(
      () => ItemCategoryRepositoryImpl(
        localDataApi: sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoryById(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => InsertBudgetUsecase(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => GetBudgetsById(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => GetBudgetList(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateBudgetUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteBudgetById(
        sl(),
      ),
    )
    ..registerLazySingleton(
      BudgetDatabase.new,
    )
    ..registerLazySingleton(
      () => BudgetFormBloc(
        preferenceRepository: sl(),
        saveGroupCategory: sl(),
        saveItemCategory: sl(),
        saveBudgetToDB: sl(),
        insertGroupCategoryUsecase: sl(),
        insertItemCategoryUsecase: sl(),
        getItemCategoryHistoriesUsecase: sl(),
      ),
    )
    ..registerLazySingleton(
      () => BudgetBloc(
        getItemCategoryTransactionsByBudgetId: sl(),
        updateBudgetDB: sl(),
        getBudgetsFromDB: sl(),
        getGroupCategoryHistoryUsecase: sl(),
        updateGroupCategoryHistory: sl(),
      ),
    )
    ..registerLazySingleton(
      () => BudgetsCubit(
        getBudgetList: sl(),
      ),
    );
}

void _initBudgetFirestore() {
  sl
    ..registerFactory<BudgetFirestoreApi>(
      () => BudgetFirestoreApiImpl(
        firestore: sl(),
        auth: sl(),
      ),
    )
    ..registerFactory<BudgetFirestoreRepo>(
      () => BudgetFirestoreRepoImpl(
        budgetFirestoreApi: sl(),
      ),
    )
    ..registerFactory<GroupCategoryFirestoreRepo>(
      () => GroupCategoryFirestoreRepoImpl(
        budgetFirestoreApi: sl(),
      ),
    )
    ..registerFactory<ItemCategoryFirestoreRepo>(
      () => ItemCategoryFirestoreRepoImpl(
        budgetFirestoreApi: sl(),
      ),
    )
    ..registerFactory<GroupCategoryHistoryFirestoreRepo>(
      () => GroupCategoryHistoryFirestoreRepoImpl(
        budgetFirestoreApi: sl(),
      ),
    )
    ..registerFactory<ItemCategoryHistoryFirestoreRepo>(
      () => ItemCategoryHistoryFirestoreRepoImpl(
        budgetFirestoreApi: sl(),
      ),
    )
    ..registerFactory<ItemCategoryTransactionFirestoreRepo>(
      () => ItemCategoryTransactionFirestoreRepoImpl(
        budgetFirestoreApi: sl(),
      ),
    )
    ..registerFactory(
      () => GetBudgetsFromFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertBudgetToFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoriesFromFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertGroupCategoryToFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoryFromFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertGroupCategoryHistoryToFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoriesFromFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryToFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoryFromFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryHistoryToFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryTransactionFromFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryTransactionToFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryHistoryFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertAccountHistoryFire(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateAccountFirestore(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertAccountFirestore(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => BudgetFirestoreCubit(
        insertItemCategoryToFirestore: sl(),
        insertItemCategoryHistoryToFirestore: sl(),
        insertGroupCategoryToFirestore: sl(),
        insertGroupCategoryHistoryToFirestore: sl(),
        insertBudgetToFirestore: sl(),
        updateUserFire: sl(),
        updateItemCategoryFirestore: sl(),
        updateItemCategoryHistoryFirestore: sl(),
        // deleteItemCategoryHistoryFirestore: serviceLocator(),
        insertAccountHistoryFirestore: sl(),
        updateAccountFirestore: sl(),
        insertItemCategoryTransactionFirestore: sl(),
        insertAccountFirestore: sl(),
      ),
    );
}

void _initiGroupCategoryHistry() {
  sl
    ..registerFactory<GroupCategoryHistoryRepository>(
      () => GroupCategoryHistoryRepositoryImpl(
        localDataApi: sl(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoriesUsecase(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoryByBudgetId(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertGroupCategoryHistoryUsecase(
        repository: sl(),
      ),
    );
}

void _initItemCategoryHistry() {
  sl
    ..registerFactory<ItemCategoryHistoryRepository>(
      () => ItemCategoryHistoryRepositoryImpl(
        localDataApi: sl(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryHistoriesUsecase(
        repository: sl(),
      ),
    );
}

void _initItemCategoryTransaction() {
  sl
    ..registerFactory<ItemCategoryTransactionRepository>(
      () => ItemCategoryTransactionRepositoryImpl(
        localDataApi: sl(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryTransaction(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryTransactionByItemId(
        sl(),
      ),
    );
}

void _initGroupCategory() {
  sl
    ..registerFactory(
      () => InsertGroupCategoryUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoryById(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteGroupCategoryById(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryById(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryTransactionById(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateGroupCategoryHistoryUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoriesUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateGroupCategoryHistoryNoItemCategory(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateGroupCategoryUsecase(
        sl(),
      ),
    );
}

void _initItemCategory() {
  sl
    ..registerFactory(
      () => UpdateItemCategoryHistoryUsecase(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryTransactionsByItemId(
        repository: sl(),
      ),
    )
    ..registerFactory(
      () => DeleteCategoryTransactionByGroupId(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryByGroupId(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryTransactionByBudgetId(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryByBudgetId(
        sl(),
      ),
    )
    ..registerFactory(
      () => DeleteGroupCategoryByBudgetId(
        sl(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoriesUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => CategoryCubit(
        getItemCategoryTransactions: sl(),
        updateItemCategoryToDB: sl(),
        deleteItemCategoryTransaction: sl(),
        deleteItemCategory: sl(),
        deleteGroupCategory: sl(),
        deleteItemCategoryTransactionByItemId: sl(),
        deleteCategoryTransactionByGroupId: sl(),
        deleteItemCategoryByGroupId: sl(),
        insertGroupCategoryHistory: sl(),
        insertItemCategoryHistory: sl(),
        deleteBudgetById: sl(),
        getItemCategoryHistoriesByBudgetId: sl(),
        getOnlyGroupCategoryById: sl(),
        getItemCategoriesUsecase: sl(),
        getGroupCategoriesUsecase: sl(),
        getGroupCategoryHistoriesUsecase: sl(),
        insertItemCategoryUsecase: sl(),
        getGroupCategoryHistoryByBudgetId: sl(),
        insertGroupCategoryUsecase: sl(),
        updateItemCategoryUsecase: sl(),
        getAccountByIdUsecase: sl(),
        updateGroupCategoryHistoryUsecase: sl(),
        updateGroupCategoryUsecase: sl(),
        updateBudgetUsecase: sl(),
      ),
    );
}

void _transactions() {
  sl
    ..registerFactory(
      () => InsertItemCategoryTransaction(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryTransactionsByBudgetId(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => TransactionsCubit(
        updateItemCategoryTransaction: sl(),
        updateBudgetDB: sl(),
        insertItemCategoryTransaction: sl(),
        getItemCategoryTransactionsByBudgetId: sl(),
        insertAccountHistoryUsecase: sl(),
        updateAccountUsecase: sl(),
      ),
    );
}

void _initTrackingCategories() {
  sl
    ..registerFactory(
      () => GetItemCategoryHistoriesUsecase(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetAllItemCategoryTransactions(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoriesByGroupId(
        sl(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoriesByBudgetId(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => TrackingCubit(
        getItemCategoryTransactionsByBudgetId: sl(),
        getItemCategoriesByGroupId: sl(),
        getItemCategoriesByBudgetId: sl(),
      ),
    );
}

void _initInsight() {
  sl.registerLazySingleton(
    () => InsightCubit(
      getItemCategoryTransactionsByBudgetId: sl(),
      getItemCategoriesByGroupId: sl(),
      getItemCategoriesByBudgetId: sl(),
    ),
  );
}

void _initNetWorth() {
  sl
    ..registerFactory<NetWorthLocalApi>(
      () => NetWorthLocalApiImpl(
        netWorthDatabase: sl(),
      ),
    )
    ..registerFactory<AssetRepository>(
      () => AssetRepositoryImpl(
        netWorthLocalApi: sl(),
      ),
    )
    ..registerFactory<LiabilityRepository>(
      () => LiabilityRepositoryImpl(
        netWorthLocalApi: sl(),
      ),
    )
    ..registerFactory<InsertAssetUsecase>(
      () => InsertAssetUsecase(
        assetRepository: sl(),
      ),
    )
    ..registerFactory<InsertLiabilityUsecase>(
      () => InsertLiabilityUsecase(
        liabilitiesRepository: sl(),
      ),
    )
    ..registerFactory<GetAssetListUsecase>(
      () => GetAssetListUsecase(
        sl(),
      ),
    )
    ..registerFactory<GetLiabilityListUsecase>(
      () => GetLiabilityListUsecase(
        sl(),
      ),
    )
    ..registerFactory<UpdateAssetUsecase>(
      () => UpdateAssetUsecase(
        assetRepository: sl(),
      ),
    )
    ..registerFactory<DeleteAssetUsecase>(
      () => DeleteAssetUsecase(
        assetRepository: sl(),
      ),
    )
    ..registerLazySingleton(
      NetWorthDatabase.new,
    )
    ..registerLazySingleton(
      () => NetWorthBloc(
        insertAsset: sl(),
        insertLiabilities: sl(),
        getAssetList: sl(),
        getLiabilityList: sl(),
        updateAsset: sl(),
        deleteAssetUsecase: sl(),
      ),
    );
}

void _initAccount() {
  sl
    ..registerLazySingleton(
      AccountDatabase.new,
    )
    ..registerFactory<AccountDatabaseApi>(
      () => AccountDatabaseApiImpl(
        sl(),
      ),
    )
    ..registerFactory<AccountRepository>(
      () => AccountRepoImpl(
        accountDatabaseApi: sl(),
      ),
    )
    ..registerFactory<AccountHistoryFirestoreRepo>(
      () => AccountHistoryFirestoreRepoImpl(
        sl(),
      ),
    )
    ..registerFactory<AccountFirestoreRepo>(
      () => AccountFirestoreRepoImpl(
        sl(),
      ),
    )
    ..registerFactory<AccountHistoryRepository>(
      () => AccountHistoryRepoImpl(
        sl(),
      ),
    )
    ..registerFactory<AccountHistoryDatabaseApi>(
      () => AccountHistoryDatabaseApiImpl(
        sl(),
      ),
    )
    ..registerFactory<AccountFirestoreApi>(
      () => AccountFirestoreApiImpl(
        sl(),
        sl(),
      ),
    )
    ..registerFactory<AccountHistoryFirestoreApi>(
      () => AccountHistoryFirestoreApiImpl(
        sl(),
        sl(),
      ),
    )
    ..registerFactory<InsertAccountUsecase>(
      () => InsertAccountUsecase(
        sl(),
      ),
    )
    ..registerFactory<UpdateAccountUsecase>(
      () => UpdateAccountUsecase(
        sl(),
      ),
    )
    ..registerFactory<GetAccountsUsecase>(
      () => GetAccountsUsecase(
        sl(),
      ),
    )
    ..registerFactory<GetAccountHistoriesUsecase>(
      () => GetAccountHistoriesUsecase(
        sl(),
      ),
    )
    ..registerFactory<InsertAccountHistoryUsecase>(
      () => InsertAccountHistoryUsecase(
        sl(),
      ),
    )
    ..registerFactory<GetAccountByIdUsecase>(
      () => GetAccountByIdUsecase(
        sl(),
      ),
    )
    ..registerFactory<DeleteAccountUsecase>(
      () => DeleteAccountUsecase(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => AccountBloc(
        getAccountsUsecase: sl(),
        insertAccountUsecase: sl(),
        settingPreferenceRepo: sl(),
        updateAccountUsecase: sl(),
        getAccountHistoriesUsecase: sl(),
        getAllItemCategoryTransactions: sl(),
        getItemCategoryHistoriesUsecase: sl(),
        deleteAccountUsecase: sl(),
      ),
    );
}

void _initRepository() {
  sl
    ..registerFactory<PdfRepository>(
      PdfRepository.new,
    )
    ..registerLazySingleton(
      () => PreferenceCubit(
        settingRepository: sl(),
        userPreferenceRepo: sl(),
      ),
    );
}

void _initGemini() {
  sl
    ..registerFactory<GeminiRepositoryModel>(
      () => GeminiRepositoryModel.instance,
    )
    ..registerLazySingleton(
      () => PromptCubit(
        geminiModelRepository: sl(),
        settingRepository: sl(),
      ),
    )
    ..registerLazySingleton(
      () => PromptAnalysisCubit(
        geminiModelRepository: sl(),
        settingRepository: sl(),
      ),
    );
}

void _initSchedulePaymentDb() {
  sl
    ..registerLazySingleton(
      SchedulePaymentDatabase.new,
    )
    ..registerFactory<SchedulePaymentDatabaseApi>(
      () => SchedulePaymentDatabaseApiImpl(
        sl(),
      ),
    )
    ..registerFactory<RepetitionRepoDb>(
      () => RepetitionRepoDbImpl(
        sl(),
      ),
    )
    ..registerFactory<InsertSchedulePaymentDb>(
      () => InsertSchedulePaymentDb(
        sl(),
      ),
    )
    ..registerFactory<DeleteSchedulePaymentDbById>(
      () => DeleteSchedulePaymentDbById(
        sl(),
      ),
    )
    ..registerFactory<GetSchedulePaymentDbById>(
      () => GetSchedulePaymentDbById(
        sl(),
      ),
    )
    ..registerFactory<GetSchedulePaymentsDb>(
      () => GetSchedulePaymentsDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateSchedulePaymentDb>(
      () => UpdateSchedulePaymentDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => SchedulePaymentDbBloc(
        insertSchedulePaymentDb: sl(),
        getSchedulePaymentById: sl(),
        getSchedulePaymentDb: sl(),
        getRepetitionListBySchedulePaymentId: sl(),
        insertRepetitionsToDb: sl(),
        updatedRepetitionById: sl(),
        updateSchedulePaymentDb: sl(),
      ),
    );
}

void _initRepetition() {
  sl
    ..registerFactory<RepetitionDatabaseApi>(
      () => RepetitionDatabaseApiImpl(
        sl(),
      ),
    )
    ..registerFactory<SchedulePaymentRepositoryDb>(
      () => SchedulePaymentRepositoryImplDb(
        sl(),
      ),
    )
    ..registerFactory<InsertRepetitionToDb>(
      () => InsertRepetitionToDb(
        sl(),
      ),
    )
    ..registerFactory<InsertRepetitionsToDb>(
      () => InsertRepetitionsToDb(
        sl(),
      ),
    )
    ..registerFactory<GetRepetitionListBySchedulePaymentId>(
      () => GetRepetitionListBySchedulePaymentId(
        sl(),
      ),
    )
    ..registerFactory<UpdateRepetitionById>(
      () => UpdateRepetitionById(
        sl(),
      ),
    )
    ..registerFactory<GetRepetitionById>(
      () => GetRepetitionById(
        sl(),
      ),
    );
}

void _initGoal() {
  sl
    ..registerLazySingleton(GoalDatabase.new)
    ..registerFactory<GoalDatabaseApi>(
      () => GoalDatabaseApiImpl(
        sl(),
      ),
    )
    ..registerFactory<GoalRepository>(
      () => GoalRepositoryImpl(
        sl(),
      ),
    )
    ..registerFactory<DeleteGoalFromDb>(
      () => DeleteGoalFromDb(
        sl(),
      ),
    )
    ..registerFactory<GetGoalFromDbById>(
      () => GetGoalFromDbById(
        sl(),
      ),
    )
    ..registerFactory<GetGoalsFromDb>(
      () => GetGoalsFromDb(
        sl(),
      ),
    )
    ..registerFactory<InsertGoalToDb>(
      () => InsertGoalToDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateGoalFromDb>(
      () => UpdateGoalFromDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => GoalDatabaseBloc(
        insertGoalToDb: sl(),
        updateGoalFromDb: sl(),
        getGoalFromDbById: sl(),
        getGoalsFromDb: sl(),
        deleteGoalFromDb: sl(),
      ),
    );
}

void _initMyPortfolio() {
  sl
    ..registerLazySingleton(MyPortfolioDatabase.new)
    ..registerFactory<MyPortfolioDatabaseApi>(
      () => MyPortfolioDatabaseApiImpl(
        sl(),
      ),
    )
    ..registerFactory<MyPortfolioRepository>(
      () => MyPortfolioRepositoryImpl(
        sl(),
      ),
    )
    ..registerFactory<DeleteMyPortfolioDb>(
      () => DeleteMyPortfolioDb(
        sl(),
      ),
    )
    ..registerFactory<GetMyPortfolioByIdDb>(
      () => GetMyPortfolioByIdDb(
        sl(),
      ),
    )
    ..registerFactory<GetMyPortfolioListDb>(
      () => GetMyPortfolioListDb(
        sl(),
      ),
    )
    ..registerFactory<InsertMyPortfolioDb>(
      () => InsertMyPortfolioDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateMyPortfolioDb>(
      () => UpdateMyPortfolioDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => MyPortfolioDbBloc(
        insertMyPortfolioDb: sl(),
        updateMyPortfolioDb: sl(),
        getMyPortfolioByIdDb: sl(),
        getMyPortfolioListDb: sl(),
        deleteMyPortfolioDb: sl(),
      ),
    );
}

void _insertFinancialCategoryDb() {
  sl
    ..registerLazySingleton(FinancialCategoryDb.new)
    ..registerFactory<FinancialCategoryDbApi>(
      () => FinancialCategoryDbApiImpl(
        sl(),
      ),
    )
    ..registerFactory<FinancialCategoryRepository>(
      () => FinancialCategoryRepositoryImpl(
        sl(),
      ),
    )
    ..registerFactory<InsertFinancialCategoryDb>(
      () => InsertFinancialCategoryDb(
        sl(),
      ),
    )
    ..registerFactory<GetFinancialCategoryDb>(
      () => GetFinancialCategoryDb(
        sl(),
      ),
    )
    ..registerFactory<GetAllFinancialCategoryDb>(
      () => GetAllFinancialCategoryDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateFinancialCategoryDb>(
      () => UpdateFinancialCategoryDb(
        sl(),
      ),
    )
    ..registerFactory<DeleteFinancialCategoryDb>(
      () => DeleteFinancialCategoryDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => FinancialCategoryBloc(
        insertFinancialCategoryDb: sl(),
        updateFinancialCategoryDb: sl(),
        getFinancialCategoryDb: sl(),
        getFinancialCategoriesDb: sl(),
        deleteFinancialCategoryDb: sl(),
      ),
    );
}

void _insertFinancialCategoryHistoryDb() {
  sl
    ..registerFactory<FinancialCategoryHistoryDbApi>(
      () => FinancialCategoryHistoryDbApiImpl(
        sl(),
      ),
    )
    ..registerFactory<FinancialCategoryHistoryRepository>(
      () => FinancialCategoryHistoryRepositoryImpl(
        sl(),
      ),
    )
    ..registerFactory<InsertFinancialCategoryHistoryDb>(
      () => InsertFinancialCategoryHistoryDb(
        sl(),
      ),
    )
    ..registerFactory<GetFinancialCategoryHistoryDb>(
      () => GetFinancialCategoryHistoryDb(
        sl(),
      ),
    )
    ..registerFactory<GetFinancialCategoryHistoriesDb>(
      () => GetFinancialCategoryHistoriesDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateFinancialCategoryHistoryDb>(
      () => UpdateFinancialCategoryHistoryDb(
        sl(),
      ),
    )
    ..registerFactory<DeleteFinancialCategoryHistoryDb>(
      () => DeleteFinancialCategoryHistoryDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => FinancialCategoryHistoryBloc(
        insertFinancialCategoryHistoryDb: sl(),
        updateFinancialCategoryHistoryDb: sl(),
        getFinancialCategoryHistoryDb: sl(),
        getFinancialCategoryHistoriesDb: sl(),
        deleteFinancialCategoryHistoryDb: sl(),
      ),
    );
}

void _initFinancialTransactionDb() {
  sl
    ..registerLazySingleton(FinancialTransactionDb.new)
    ..registerFactory<FinancialTransactionDbApi>(
      () => FinancialTransactionDbApiImpl(
        sl(),
      ),
    )
    ..registerFactory<FinancialTransactionRepository>(
      () => FinancialTransactionRepositoryImpl(
        sl(),
      ),
    )
    ..registerFactory<InsertFinancialTransactionDb>(
      () => InsertFinancialTransactionDb(
        sl(),
      ),
    )
    ..registerFactory<GetFinancialTransactionByIdDb>(
      () => GetFinancialTransactionByIdDb(
        sl(),
      ),
    )
    ..registerFactory<GetAllFinancialTransactionDb>(
      () => GetAllFinancialTransactionDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateFinancialTransactionDb>(
      () => UpdateFinancialTransactionDb(
        sl(),
      ),
    )
    ..registerFactory<DeleteFinancialTransactionDb>(
      () => DeleteFinancialTransactionDb(
        sl(),
      ),
    )
    ..registerFactory<GetAllFinancialTransactionByMonthAndYearDb>(
      () => GetAllFinancialTransactionByMonthAndYearDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => FinancialTransactionBloc(
        insertFinancialTransactionDb: sl(),
        updateFinancialTransactionDb: sl(),
        getFinancialTransactionDb: sl(),
        getAllFinancialTransactionDb: sl(),
        deleteFinancialTransactionDb: sl(),
      ),
    );
}

void _initFinancialDashboard() {
  sl.registerLazySingleton(
    () => FinancialDashboardCubit(
      getAllFinancialTransactionByMonthAndYearDb: sl(),
    ),
  );
}

void _initMemberDb() {
  sl
    ..registerLazySingleton(MemberDb.new)
    ..registerFactory<MemberDbApi>(
      () => MemberDbApiImpl(
        sl(),
      ),
    )
    ..registerFactory<MemberDbRepository>(
      () => MemberDbRepositoryImpl(
        sl(),
      ),
    )
    ..registerFactory<InsertMemberDb>(
      () => InsertMemberDb(
        sl(),
      ),
    )
    ..registerFactory<GetMemberByIdDb>(
      () => GetMemberByIdDb(
        sl(),
      ),
    )
    ..registerFactory<GetAllMemberDb>(
      () => GetAllMemberDb(
        sl(),
      ),
    )
    ..registerFactory<UpdateMemberDb>(
      () => UpdateMemberDb(
        sl(),
      ),
    )
    ..registerFactory<DeleteMemberDb>(
      () => DeleteMemberDb(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => MemberDbBloc(
        insertMemberDb: sl(),
        updateMemberDb: sl(),
        getMemberByIdDb: sl(),
        getAllMemberDb: sl(),
        deleteMemberDb: sl(),
      ),
    );
}
