import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/net_worth/data/datasources/database/net_worth_db.dart';
import 'package:budget_intelli/features/net_worth/data/models/asset_model.dart';
import 'package:budget_intelli/features/net_worth/data/models/liability_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NetWorthLocalApi {
  // assets
  Future<Unit> insertAsset(AssetModel asset);
  Future<Unit> updateAsset(AssetModel asset);
  Future<Unit> deleteAsset(String id);
  Future<List<AssetModel>> assets();

  // liabilities
  Future<Unit> insertLiability(LiabilityModel liability);
  Future<Unit> updateLiability(LiabilityModel liability);
  Future<Unit> deleteLiability(String id);
  Future<List<LiabilityModel>> liabilities();
}

class NetWorthLocalApiImpl implements NetWorthLocalApi {
  NetWorthLocalApiImpl({
    required this.netWorthDatabase,
  });
  final NetWorthDatabase netWorthDatabase;

  @override
  Future<List<AssetModel>> assets() async {
    try {
      final assetList = <AssetModel>[];
      await netWorthDatabase.database;
      final assets = await netWorthDatabase.getAllAssets();
      for (final asset in assets) {
        assetList.add(
          AssetModel.fromMap(asset),
        );
      }
      return assetList;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteAsset(String id) async {
    try {
      await netWorthDatabase.deleteAsset(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> deleteLiability(String id) async {
    try {
      await netWorthDatabase.deleteLiability(id);
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertAsset(AssetModel asset) async {
    try {
      await netWorthDatabase.insertAsset(asset.toMap());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> insertLiability(LiabilityModel liability) async {
    try {
      await netWorthDatabase.insertLiability(liability.toMap());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<List<LiabilityModel>> liabilities() async {
    try {
      final liabilityList = <LiabilityModel>[];
      await netWorthDatabase.database;
      final liabilities = await netWorthDatabase.getAllLiabilities();
      for (final liability in liabilities) {
        liabilityList.add(
          LiabilityModel.fromMap(liability),
        );
      }
      return liabilityList;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateAsset(AssetModel asset) async {
    try {
      await netWorthDatabase.updateAsset(asset.toMap());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }

  @override
  Future<Unit> updateLiability(LiabilityModel liability) async {
    try {
      await netWorthDatabase.updateLiability(liability.toMap());
      return unit;
    } catch (e) {
      throw CustomException('Error: $e');
    }
  }
}
