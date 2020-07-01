import 'package:equatable/equatable.dart';

class Id extends Equatable {
  final String kind;
  final String videoId;
  final String channelId;

  const Id({this.kind, this.videoId, this.channelId});

  @override
  List<Object> get props => [kind, videoId, channelId];

  factory Id.fromJson(Map<String, dynamic> parsedJson){
    return Id(
        kind: parsedJson['kind'],
        videoId: parsedJson['videoId'],
        channelId: parsedJson['channelId'],
    );
  }

  @override
  String toString() {
    return 'Id{kind: $kind, videoId: $videoId, channelId: $channelId}';
  }

}
