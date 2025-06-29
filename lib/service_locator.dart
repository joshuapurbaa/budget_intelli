part of 'init_dependencies.dart';

final GetIt serviceLocator = GetIt.instance;

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

  serviceLocator
    ..registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    )
    ..registerFactory(InternetConnection.new)
    ..registerFactory(
      () => GetUserFirestoreUsecase(serviceLocator()),
    )
    ..registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()),
    );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignUpUsecase(serviceLocator()))
    ..registerFactory(() => UserSignIn(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    ..registerFactory(() => GetCurrentUserSessionUsecase(serviceLocator()))
    ..registerFactory(() => InsertUserFirestoreUsecase(serviceLocator()))
    ..registerFactory(() => UpdateUserFirestoreUsecases(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        // appUserCubit: serviceLocator(),
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignOut: serviceLocator(),
        getCurrentUser: serviceLocator(),
        getUserCubit: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => UserFirestoreCubit(
        getUser: serviceLocator(),
        updateUser: serviceLocator(),
        insertUserDataUsecase: serviceLocator(),
      ),
    );
}

void _initSchedulePayment() {
  serviceLocator
    ..registerFactory<SchedulePaymentRemoteDataSource>(
      () => SchedulePaymentRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<SchedulePaymentRepoFire>(
      () => SchedulePaymentRepoImplFire(
        remoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(() => GetSchedulePayments(serviceLocator()))
    ..registerFactory(() => GetSchedulePayment(serviceLocator()))
    ..registerFactory(() => UpdateSchedulePayment(serviceLocator()))
    ..registerFactory(() => CreateSchedulePaymentFire(serviceLocator()))
    ..registerFactory(() => DeleteSchedulePayment(serviceLocator()))
    ..registerLazySingleton(
      () => SchedulePaymentBloc(
        getSchedulePayments: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => CudSchedulePaymentBloc(
        updateSchedulePayment: serviceLocator(),
        createSchedulePayment: serviceLocator(),
        deleteSchedulePayment: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GetSchedulePaymentCubit(
        getSchedulePayment: serviceLocator(),
      ),
    );
}

void _initAiAssistant() {
  serviceLocator.registerLazySingleton(
    ChatCubit.new,
  );
}

void _initSettings() {
  serviceLocator
    ..registerLazySingleton(
      SettingPreferenceRepo.new,
    )
    ..registerLazySingleton(
      UserPreferenceRepo.new,
    )
    ..registerLazySingleton(
      () => SettingBloc(
        preferenceRepository: serviceLocator(),
        userPreferenceRepo: serviceLocator(),
        pdfRepository: serviceLocator(),
      ),
    );
}

void _initBudget() {
  serviceLocator
    ..registerFactory<BudgetLocalApi>(
      () => BudgetLocalApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BudgetRepository>(
      () => BudgetRepositoryImpl(
        localDataApi: serviceLocator(),
      ),
    )
    ..registerFactory<GroupCategoryRepository>(
      () => GroupCategoryRepositoryImpl(
        localDataApi: serviceLocator(),
      ),
    )
    ..registerFactory<ItemCategoryRepository>(
      () => ItemCategoryRepositoryImpl(
        localDataApi: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoryById(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertBudgetUsecase(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetBudgetsById(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetBudgetList(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateBudgetUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteBudgetById(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      BudgetDatabase.new,
    )
    ..registerLazySingleton(
      () => BudgetFormBloc(
        preferenceRepository: serviceLocator(),
        saveGroupCategory: serviceLocator(),
        saveItemCategory: serviceLocator(),
        saveBudgetToDB: serviceLocator(),
        insertGroupCategoryUsecase: serviceLocator(),
        insertItemCategoryUsecase: serviceLocator(),
        getItemCategoryHistoriesUsecase: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BudgetBloc(
        getItemCategoryTransactionsByBudgetId: serviceLocator(),
        updateBudgetDB: serviceLocator(),
        getBudgetsFromDB: serviceLocator(),
        getGroupCategoryHistoryUsecase: serviceLocator(),
        updateGroupCategoryHistory: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BudgetsCubit(
        getBudgetList: serviceLocator(),
      ),
    );
}

void _initBudgetFirestore() {
  serviceLocator
    ..registerFactory<BudgetFirestoreApi>(
      () => BudgetFirestoreApiImpl(
        firestore: serviceLocator(),
        auth: serviceLocator(),
      ),
    )
    ..registerFactory<BudgetFirestoreRepo>(
      () => BudgetFirestoreRepoImpl(
        budgetFirestoreApi: serviceLocator(),
      ),
    )
    ..registerFactory<GroupCategoryFirestoreRepo>(
      () => GroupCategoryFirestoreRepoImpl(
        budgetFirestoreApi: serviceLocator(),
      ),
    )
    ..registerFactory<ItemCategoryFirestoreRepo>(
      () => ItemCategoryFirestoreRepoImpl(
        budgetFirestoreApi: serviceLocator(),
      ),
    )
    ..registerFactory<GroupCategoryHistoryFirestoreRepo>(
      () => GroupCategoryHistoryFirestoreRepoImpl(
        budgetFirestoreApi: serviceLocator(),
      ),
    )
    ..registerFactory<ItemCategoryHistoryFirestoreRepo>(
      () => ItemCategoryHistoryFirestoreRepoImpl(
        budgetFirestoreApi: serviceLocator(),
      ),
    )
    ..registerFactory<ItemCategoryTransactionFirestoreRepo>(
      () => ItemCategoryTransactionFirestoreRepoImpl(
        budgetFirestoreApi: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetBudgetsFromFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertBudgetToFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoriesFromFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertGroupCategoryToFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoryFromFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertGroupCategoryHistoryToFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoriesFromFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryToFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoryFromFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryHistoryToFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryTransactionFromFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryTransactionToFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryHistoryFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertAccountHistoryFire(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateAccountFirestore(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertAccountFirestore(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BudgetFirestoreCubit(
        insertItemCategoryToFirestore: serviceLocator(),
        insertItemCategoryHistoryToFirestore: serviceLocator(),
        insertGroupCategoryToFirestore: serviceLocator(),
        insertGroupCategoryHistoryToFirestore: serviceLocator(),
        insertBudgetToFirestore: serviceLocator(),
        updateUserFire: serviceLocator(),
        updateItemCategoryFirestore: serviceLocator(),
        updateItemCategoryHistoryFirestore: serviceLocator(),
        // deleteItemCategoryHistoryFirestore: serviceLocator(),
        insertAccountHistoryFirestore: serviceLocator(),
        updateAccountFirestore: serviceLocator(),
        insertItemCategoryTransactionFirestore: serviceLocator(),
        insertAccountFirestore: serviceLocator(),
      ),
    );
}

void _initiGroupCategoryHistry() {
  serviceLocator
    ..registerFactory<GroupCategoryHistoryRepository>(
      () => GroupCategoryHistoryRepositoryImpl(
        localDataApi: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoriesUsecase(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoryByBudgetId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertGroupCategoryHistoryUsecase(
        repository: serviceLocator(),
      ),
    );
}

void _initItemCategoryHistry() {
  serviceLocator
    ..registerFactory<ItemCategoryHistoryRepository>(
      () => ItemCategoryHistoryRepositoryImpl(
        localDataApi: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryHistoriesUsecase(
        repository: serviceLocator(),
      ),
    );
}

void _initItemCategoryTransaction() {
  serviceLocator
    ..registerFactory<ItemCategoryTransactionRepository>(
      () => ItemCategoryTransactionRepositoryImpl(
        localDataApi: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryTransaction(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryTransactionByItemId(
        serviceLocator(),
      ),
    );
}

void _initGroupCategory() {
  serviceLocator
    ..registerFactory(
      () => InsertGroupCategoryUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoryHistoryById(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteGroupCategoryById(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryById(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryTransactionById(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateGroupCategoryHistoryUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetGroupCategoriesUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateGroupCategoryHistoryNoItemCategory(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateGroupCategoryUsecase(
        serviceLocator(),
      ),
    );
}

void _initItemCategory() {
  serviceLocator
    ..registerFactory(
      () => UpdateItemCategoryHistoryUsecase(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryTransactionsByItemId(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteCategoryTransactionByGroupId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryByGroupId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryTransactionByBudgetId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteItemCategoryHistoryByBudgetId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteGroupCategoryByBudgetId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InsertItemCategoryUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoriesUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateItemCategoryUsecase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => CategoryCubit(
        getItemCategoryTransactions: serviceLocator(),
        updateItemCategoryToDB: serviceLocator(),
        deleteItemCategoryTransaction: serviceLocator(),
        deleteItemCategory: serviceLocator(),
        deleteGroupCategory: serviceLocator(),
        deleteItemCategoryTransactionByItemId: serviceLocator(),
        deleteCategoryTransactionByGroupId: serviceLocator(),
        deleteItemCategoryByGroupId: serviceLocator(),
        insertGroupCategoryHistory: serviceLocator(),
        insertItemCategoryHistory: serviceLocator(),
        deleteBudgetById: serviceLocator(),
        getItemCategoryHistoriesByBudgetId: serviceLocator(),
        getOnlyGroupCategoryById: serviceLocator(),
        getItemCategoriesUsecase: serviceLocator(),
        getGroupCategoriesUsecase: serviceLocator(),
        getGroupCategoryHistoriesUsecase: serviceLocator(),
        insertItemCategoryUsecase: serviceLocator(),
        getGroupCategoryHistoryByBudgetId: serviceLocator(),
        insertGroupCategoryUsecase: serviceLocator(),
        updateItemCategoryUsecase: serviceLocator(),
        getAccountByIdUsecase: serviceLocator(),
        updateGroupCategoryHistoryUsecase: serviceLocator(),
        updateGroupCategoryUsecase: serviceLocator(),
        updateBudgetUsecase: serviceLocator(),
      ),
    );
}

void _transactions() {
  serviceLocator
    ..registerFactory(
      () => InsertItemCategoryTransaction(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryTransactionsByBudgetId(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => TransactionsCubit(
        updateItemCategoryTransaction: serviceLocator(),
        updateBudgetDB: serviceLocator(),
        insertItemCategoryTransaction: serviceLocator(),
        getItemCategoryTransactionsByBudgetId: serviceLocator(),
        insertAccountHistoryUsecase: serviceLocator(),
        updateAccountUsecase: serviceLocator(),
      ),
    );
}

void _initTrackingCategories() {
  serviceLocator
    ..registerFactory(
      () => GetItemCategoryHistoriesUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllItemCategoryTransactions(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoriesByGroupId(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetItemCategoryHistoriesByBudgetId(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => TrackingCubit(
        getItemCategoryTransactionsByBudgetId: serviceLocator(),
        getItemCategoriesByGroupId: serviceLocator(),
        getItemCategoriesByBudgetId: serviceLocator(),
      ),
    );
}

void _initInsight() {
  serviceLocator.registerLazySingleton(
    () => InsightCubit(
      getItemCategoryTransactionsByBudgetId: serviceLocator(),
      getItemCategoriesByGroupId: serviceLocator(),
      getItemCategoriesByBudgetId: serviceLocator(),
    ),
  );
}

void _initNetWorth() {
  serviceLocator
    ..registerFactory<NetWorthLocalApi>(
      () => NetWorthLocalApiImpl(
        netWorthDatabase: serviceLocator(),
      ),
    )
    ..registerFactory<AssetRepository>(
      () => AssetRepositoryImpl(
        netWorthLocalApi: serviceLocator(),
      ),
    )
    ..registerFactory<LiabilityRepository>(
      () => LiabilityRepositoryImpl(
        netWorthLocalApi: serviceLocator(),
      ),
    )
    ..registerFactory<InsertAssetUsecase>(
      () => InsertAssetUsecase(
        assetRepository: serviceLocator(),
      ),
    )
    ..registerFactory<InsertLiabilityUsecase>(
      () => InsertLiabilityUsecase(
        liabilitiesRepository: serviceLocator(),
      ),
    )
    ..registerFactory<GetAssetListUsecase>(
      () => GetAssetListUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetLiabilityListUsecase>(
      () => GetLiabilityListUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateAssetUsecase>(
      () => UpdateAssetUsecase(
        assetRepository: serviceLocator(),
      ),
    )
    ..registerFactory<DeleteAssetUsecase>(
      () => DeleteAssetUsecase(
        assetRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      NetWorthDatabase.new,
    )
    ..registerLazySingleton(
      () => NetWorthBloc(
        insertAsset: serviceLocator(),
        insertLiabilities: serviceLocator(),
        getAssetList: serviceLocator(),
        getLiabilityList: serviceLocator(),
        updateAsset: serviceLocator(),
        deleteAssetUsecase: serviceLocator(),
      ),
    );
}

void _initAccount() {
  serviceLocator
    ..registerLazySingleton(
      AccountDatabase.new,
    )
    ..registerFactory<AccountDatabaseApi>(
      () => AccountDatabaseApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AccountRepository>(
      () => AccountRepoImpl(
        accountDatabaseApi: serviceLocator(),
      ),
    )
    ..registerFactory<AccountHistoryFirestoreRepo>(
      () => AccountHistoryFirestoreRepoImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AccountFirestoreRepo>(
      () => AccountFirestoreRepoImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AccountHistoryRepository>(
      () => AccountHistoryRepoImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AccountHistoryDatabaseApi>(
      () => AccountHistoryDatabaseApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AccountFirestoreApi>(
      () => AccountFirestoreApiImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<AccountHistoryFirestoreApi>(
      () => AccountHistoryFirestoreApiImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertAccountUsecase>(
      () => InsertAccountUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateAccountUsecase>(
      () => UpdateAccountUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAccountsUsecase>(
      () => GetAccountsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAccountHistoriesUsecase>(
      () => GetAccountHistoriesUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertAccountHistoryUsecase>(
      () => InsertAccountHistoryUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAccountByIdUsecase>(
      () => GetAccountByIdUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteAccountUsecase>(
      () => DeleteAccountUsecase(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AccountBloc(
        getAccountsUsecase: serviceLocator(),
        insertAccountUsecase: serviceLocator(),
        settingPreferenceRepo: serviceLocator(),
        updateAccountUsecase: serviceLocator(),
        getAccountHistoriesUsecase: serviceLocator(),
        getAllItemCategoryTransactions: serviceLocator(),
        getItemCategoryHistoriesUsecase: serviceLocator(),
        deleteAccountUsecase: serviceLocator(),
      ),
    );
}

void _initRepository() {
  serviceLocator
    ..registerFactory<PdfRepository>(
      PdfRepository.new,
    )
    ..registerLazySingleton(
      () => PreferenceCubit(
        settingRepository: serviceLocator(),
        userPreferenceRepo: serviceLocator(),
      ),
    );
}

void _initGemini() {
  serviceLocator
    ..registerFactory<GeminiRepositoryModel>(
      () => GeminiRepositoryModel.instance,
    )
    ..registerLazySingleton(
      () => PromptCubit(
        geminiModelRepository: serviceLocator(),
        settingRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => PromptAnalysisCubit(
        geminiModelRepository: serviceLocator(),
        settingRepository: serviceLocator(),
      ),
    );
}

void _initSchedulePaymentDb() {
  serviceLocator
    ..registerLazySingleton(
      SchedulePaymentDatabase.new,
    )
    ..registerFactory<SchedulePaymentDatabaseApi>(
      () => SchedulePaymentDatabaseApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<RepetitionRepoDb>(
      () => RepetitionRepoDbImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertSchedulePaymentDb>(
      () => InsertSchedulePaymentDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteSchedulePaymentDbById>(
      () => DeleteSchedulePaymentDbById(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetSchedulePaymentDbById>(
      () => GetSchedulePaymentDbById(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetSchedulePaymentsDb>(
      () => GetSchedulePaymentsDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateSchedulePaymentDb>(
      () => UpdateSchedulePaymentDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => SchedulePaymentDbBloc(
        insertSchedulePaymentDb: serviceLocator(),
        getSchedulePaymentById: serviceLocator(),
        getSchedulePaymentDb: serviceLocator(),
        getRepetitionListBySchedulePaymentId: serviceLocator(),
        insertRepetitionsToDb: serviceLocator(),
        updatedRepetitionById: serviceLocator(),
        updateSchedulePaymentDb: serviceLocator(),
      ),
    );
}

void _initRepetition() {
  serviceLocator
    ..registerFactory<RepetitionDatabaseApi>(
      () => RepetitionDatabaseApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<SchedulePaymentRepositoryDb>(
      () => SchedulePaymentRepositoryImplDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertRepetitionToDb>(
      () => InsertRepetitionToDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertRepetitionsToDb>(
      () => InsertRepetitionsToDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetRepetitionListBySchedulePaymentId>(
      () => GetRepetitionListBySchedulePaymentId(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateRepetitionById>(
      () => UpdateRepetitionById(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetRepetitionById>(
      () => GetRepetitionById(
        serviceLocator(),
      ),
    );
}

void _initGoal() {
  serviceLocator
    ..registerLazySingleton(GoalDatabase.new)
    ..registerFactory<GoalDatabaseApi>(
      () => GoalDatabaseApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<GoalRepository>(
      () => GoalRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteGoalFromDb>(
      () => DeleteGoalFromDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetGoalFromDbById>(
      () => GetGoalFromDbById(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetGoalsFromDb>(
      () => GetGoalsFromDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertGoalToDb>(
      () => InsertGoalToDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateGoalFromDb>(
      () => UpdateGoalFromDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => GoalDatabaseBloc(
        insertGoalToDb: serviceLocator(),
        updateGoalFromDb: serviceLocator(),
        getGoalFromDbById: serviceLocator(),
        getGoalsFromDb: serviceLocator(),
        deleteGoalFromDb: serviceLocator(),
      ),
    );
}

void _initMyPortfolio() {
  serviceLocator
    ..registerLazySingleton(MyPortfolioDatabase.new)
    ..registerFactory<MyPortfolioDatabaseApi>(
      () => MyPortfolioDatabaseApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<MyPortfolioRepository>(
      () => MyPortfolioRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteMyPortfolioDb>(
      () => DeleteMyPortfolioDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetMyPortfolioByIdDb>(
      () => GetMyPortfolioByIdDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetMyPortfolioListDb>(
      () => GetMyPortfolioListDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertMyPortfolioDb>(
      () => InsertMyPortfolioDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateMyPortfolioDb>(
      () => UpdateMyPortfolioDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => MyPortfolioDbBloc(
        insertMyPortfolioDb: serviceLocator(),
        updateMyPortfolioDb: serviceLocator(),
        getMyPortfolioByIdDb: serviceLocator(),
        getMyPortfolioListDb: serviceLocator(),
        deleteMyPortfolioDb: serviceLocator(),
      ),
    );
}

void _insertFinancialCategoryDb() {
  serviceLocator
    ..registerLazySingleton(FinancialCategoryDb.new)
    ..registerFactory<FinancialCategoryDbApi>(
      () => FinancialCategoryDbApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<FinancialCategoryRepository>(
      () => FinancialCategoryRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertFinancialCategoryDb>(
      () => InsertFinancialCategoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetFinancialCategoryDb>(
      () => GetFinancialCategoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllFinancialCategoryDb>(
      () => GetAllFinancialCategoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateFinancialCategoryDb>(
      () => UpdateFinancialCategoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteFinancialCategoryDb>(
      () => DeleteFinancialCategoryDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => FinancialCategoryBloc(
        insertFinancialCategoryDb: serviceLocator(),
        updateFinancialCategoryDb: serviceLocator(),
        getFinancialCategoryDb: serviceLocator(),
        getFinancialCategoriesDb: serviceLocator(),
        deleteFinancialCategoryDb: serviceLocator(),
      ),
    );
}

void _insertFinancialCategoryHistoryDb() {
  serviceLocator
    ..registerFactory<FinancialCategoryHistoryDbApi>(
      () => FinancialCategoryHistoryDbApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<FinancialCategoryHistoryRepository>(
      () => FinancialCategoryHistoryRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertFinancialCategoryHistoryDb>(
      () => InsertFinancialCategoryHistoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetFinancialCategoryHistoryDb>(
      () => GetFinancialCategoryHistoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetFinancialCategoryHistoriesDb>(
      () => GetFinancialCategoryHistoriesDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateFinancialCategoryHistoryDb>(
      () => UpdateFinancialCategoryHistoryDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteFinancialCategoryHistoryDb>(
      () => DeleteFinancialCategoryHistoryDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => FinancialCategoryHistoryBloc(
        insertFinancialCategoryHistoryDb: serviceLocator(),
        updateFinancialCategoryHistoryDb: serviceLocator(),
        getFinancialCategoryHistoryDb: serviceLocator(),
        getFinancialCategoryHistoriesDb: serviceLocator(),
        deleteFinancialCategoryHistoryDb: serviceLocator(),
      ),
    );
}

void _initFinancialTransactionDb() {
  serviceLocator
    ..registerLazySingleton(FinancialTransactionDb.new)
    ..registerFactory<FinancialTransactionDbApi>(
      () => FinancialTransactionDbApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<FinancialTransactionRepository>(
      () => FinancialTransactionRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertFinancialTransactionDb>(
      () => InsertFinancialTransactionDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetFinancialTransactionByIdDb>(
      () => GetFinancialTransactionByIdDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllFinancialTransactionDb>(
      () => GetAllFinancialTransactionDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateFinancialTransactionDb>(
      () => UpdateFinancialTransactionDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteFinancialTransactionDb>(
      () => DeleteFinancialTransactionDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllFinancialTransactionByMonthAndYearDb>(
      () => GetAllFinancialTransactionByMonthAndYearDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => FinancialTransactionBloc(
        insertFinancialTransactionDb: serviceLocator(),
        updateFinancialTransactionDb: serviceLocator(),
        getFinancialTransactionDb: serviceLocator(),
        getAllFinancialTransactionDb: serviceLocator(),
        deleteFinancialTransactionDb: serviceLocator(),
      ),
    );
}

void _initFinancialDashboard() {
  serviceLocator.registerLazySingleton(
    () => FinancialDashboardCubit(
      getAllFinancialTransactionByMonthAndYearDb: serviceLocator(),
    ),
  );
}

void _initMemberDb() {
  serviceLocator
    ..registerLazySingleton(MemberDb.new)
    ..registerFactory<MemberDbApi>(
      () => MemberDbApiImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<MemberDbRepository>(
      () => MemberDbRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<InsertMemberDb>(
      () => InsertMemberDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetMemberByIdDb>(
      () => GetMemberByIdDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<GetAllMemberDb>(
      () => GetAllMemberDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<UpdateMemberDb>(
      () => UpdateMemberDb(
        serviceLocator(),
      ),
    )
    ..registerFactory<DeleteMemberDb>(
      () => DeleteMemberDb(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => MemberDbBloc(
        insertMemberDb: serviceLocator(),
        updateMemberDb: serviceLocator(),
        getMemberByIdDb: serviceLocator(),
        getAllMemberDb: serviceLocator(),
        deleteMemberDb: serviceLocator(),
      ),
    );
}
