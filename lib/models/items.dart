import 'package:equatable/equatable.dart';
import 'package:ft_infinite_list/models/id.dart';

class Item extends Equatable {
  final String kind;
  final Id id;

  const Item({this.kind, this.id});

  @override
  List<Object> get props => [kind, id];

  factory Item.fromJson(Map<String, dynamic> parsedJson){
    return Item(
        kind: parsedJson['kind'],
        id: Id.fromJson(parsedJson['id'])
    );
  }

  @override
  String toString() {
    return 'Item{kind: $kind, id: $id}';
  }
}
