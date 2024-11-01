part of 'box_category_cubit.dart';

@immutable
sealed class BoxCategoryState {}

final class BoxCategoryInitial extends BoxCategoryState {}

final class HasInitialListCategory extends BoxCategoryState {
  HasInitialListCategory(
    this.categories,
  );

  final ListMap categories;
}

final class HasDataSelected extends BoxCategoryState {
  HasDataSelected(
    this.category,
  );

  final String category;
}
