import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:ft_infinite_list/models/items.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:ft_infinite_list/bloc/bloc.dart';
import 'package:ft_infinite_list/models/models.dart';
import 'package:rxdart/rxdart.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({@required this.httpClient});

  @override
  // TODO: implement initialState
  PostState get initialState => PostInitial();

  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(
      Stream<PostEvent> events,
      TransitionFunction<PostEvent, PostState> transitionFn,
      ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    if(event is PostFetched && !_hasReachedMax(currentState)) {
      try {
        if(currentState is PostInitial) {
          final posts = await _fetchPosts(0, 20);
          print('posts.length=${posts.length}');
//          final items = await _fetchYoutubeVideos();
//          print('items.length=${items.length}');

          yield PostSuccess(posts: posts, hasReachedMax: false);
          return;
        }

        if (currentState is PostSuccess) {
          final posts = await _fetchPosts(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostSuccess(
                posts: currentState.posts + posts,
                hasReachedMax: false,
              );
        }
      } catch(_) {
        yield PostFailure();
      }

    }
    yield null;
  }

  bool _hasReachedMax(PostState state) =>
    state is PostSuccess && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }

  Future<List<Item>> _fetchYoutubeVideos() async {
    String srcUrl = 'https://s3-ap-southeast-1.amazonaws.com/ysetter/media/video-search.json';
    final response = await httpClient.get(srcUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
//      return data?.map<Item>((rawPost) => new Item.fromJson(rawPost))?.toList() ?? [];
//      {
//        return Item(
//          kind: rawPost['kind'],
//          id: rawPost['id'],
//        );
//      }).toList();
      return data?.map((rawPost) {
        return Item(
          kind: rawPost['kind'],
//          id: rawPost['id'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
