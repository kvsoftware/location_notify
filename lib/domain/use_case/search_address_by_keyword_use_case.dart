import '../../data/repository/map_repository.dart';
import '../entity/address_entity.dart';

class SearchAddressByKeywordUseCase {
  final MapRepository _mapRepository;

  SearchAddressByKeywordUseCase(this._mapRepository);

  Future<List<AddressEntity>> invoke({required String keyword}) async {
    return _mapRepository.searchByKeyword(keyword: keyword);
  }
}
