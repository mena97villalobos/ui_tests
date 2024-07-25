import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as sp;

class SpotifySearchAndAdd extends StatefulWidget {
  SpotifySearchAndAdd({super.key});

  final credentials = sp.SpotifyApiCredentials(
      "1ce228f8946443bba23b32f6ddd45d44", "8779e7368da746b58f584597ff33081a");

  @override
  State<SpotifySearchAndAdd> createState() => _SpotifySearchAndAddState();
}

class _SpotifySearchAndAddState extends State<SpotifySearchAndAdd> {

  List<sp.Track> songList = List.empty(growable: true);

  String _getTrackInfo(sp.Track track) {
    return "${track.name}: ${track.artists?.first.name}, ${track.album?.name}";
  }

  @override
  Widget build(BuildContext context) {
    final spotify = sp.SpotifyApi(widget.credentials);

    return Column(
      children: [
        SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              onSubmitted: (_) async {
                final spotifyResponse = await spotify.search
                    .get(controller.text, types: [sp.SearchType.track]).first();
                final tracks =
                spotifyResponse.first.items?.map((track) => track as sp.Track);
                setState(() {
                  songList.clear();
                  songList.addAll(tracks!);
                });
                controller.closeView(controller.text);
              },
              leading: const Icon(Icons.search),
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) async {
            if (controller.text.isEmpty) {
              return [
                const ListTile(title: Text("Try searching for a song..."))
              ];
            }

            final spotifyResponse = await spotify.search
                .get(controller.text, types: [sp.SearchType.track]).first();
            final tracks =
            spotifyResponse.first.items?.map((track) => track as sp.Track);
            if (tracks == null || tracks.isEmpty) {
              return [
                const ListTile(title: Text("Try searching for a song..."))
              ];
            }

            return tracks
                .map((track) =>
                ListTile(
                  title: Text(_getTrackInfo(track)),
                  onTap: () => {controller.closeView(track.name)},
                ))
                .toList();
          },
        ),
        ListView.builder(
            itemCount: songList.length,
            itemBuilder: (context, index) {
              final sp.Track song = songList[index];
              return SpotifySong(
                  imageUrl: song.album!.images!.first.url!,
                  songName: song.name!,
                  artistName: song.artists!.first.name!,
                  albumName: song.album!.name!,
              );
            }
        ),
      ],
    );
  }
}

class SpotifySong extends StatelessWidget {

  final String imageUrl;
  final String songName;
  final String artistName;
  final String albumName;

  const SpotifySong(
      {super.key, required this.imageUrl, required this.songName, required this.artistName, required this.albumName});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.network(imageUrl),
      Column(children: [
        Text(songName),
        Text(artistName),
        Text(albumName),
      ],),
    ],);
  }
}

