#!/usr/bin/env bash
# apply_scaffold.sh
# Creates the Aura Music scaffold files, commits them, creates branch aura/init-scaffold and pushes to origin.
# Run this from the root of your cloned repo (https://github.com/rashithto/Meldo.git).
set -euo pipefail

BRANCH="aura/init-scaffold"
COMMIT_MSG="chore(aura): initial scaffold - app, audio module, spotify import scaffold, theme, CI"

echo "Creating scaffold files..."

# Create directories
mkdir -p app/lib/src/{screens,theme,widgets}
mkdir -p packages/audio/lib
mkdir -p packages/spotify_import/lib
mkdir -p .github/workflows

# Write app/pubspec.yaml
cat > app/pubspec.yaml <<'EOF'
name: aura_music
description: Aura Music — premium cross-platform music app scaffold
publish_to: "none"
version: 0.1.0

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  flutter_riverpod: ^2.3.0
  go_router: ^8.0.2
  just_audio: ^0.9.33
  audio_service: ^0.18.0
  audio_session: ^0.1.6
  firebase_core: ^2.10.0
  firebase_auth: ^4.6.0
  cloud_firestore: ^4.7.0
  firebase_storage: ^11.2.0
  hive: ^2.2.3
  isar: ^4.1.0
  dio: ^5.3.1
  flutter_downloader: ^1.10.2
  cached_network_image: ^3.2.3
  flutter_svg: ^1.1.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.1

flutter:
  uses-material-design: true
EOF

# app main.dart
cat > app/lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase, local DBs, audio session etc. in real app startup
  runApp(const ProviderScope(child: AuraApp()));
}
EOF

# app/src/app.dart
cat > app/lib/src/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/aura_theme.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/library_screen.dart';
import 'screens/downloads_screen.dart';
import 'screens/profile_screen.dart';

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
  GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
  GoRoute(path: '/library', builder: (c, s) => const LibraryScreen()),
  GoRoute(path: '/downloads', builder: (c, s) => const DownloadsScreen()),
  GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
]);

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aura Music',
      theme: AuraTheme.light(),
      darkTheme: AuraTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF

# design tokens
cat > app/lib/src/theme/design_tokens.dart <<'EOF'
import 'package:flutter/material.dart';

class DesignTokens {
  // Colors
  static const Color amoled = Color(0xFF000000);
  static const Color neonGreen = Color(0xFF00E676); // soft neon green accent
  static const Color cardGradientStart = Color(0xFF001010);
  static const Color cardGradientEnd = Color(0xFF002020);

  // Radii
  static const double radiusLarge = 20.0;
  static const double radiusXL = 22.0;

  // Elevation
  static const double cardElevation = 8.0;
}
EOF

# aura_theme
cat > app/lib/src/theme/aura_theme.dart <<'EOF'
import 'package:flutter/material.dart';
import 'design_tokens.dart';

class AuraTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: DesignTokens.amoled,
      colorScheme: ColorScheme.dark(
        primary: DesignTokens.neonGreen,
        secondary: DesignTokens.neonGreen,
        background: DesignTokens.amoled,
        surface: const Color(0xFF0A0A0A),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.white12,
        elevation: DesignTokens.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      colorScheme: ColorScheme.light(
        primary: DesignTokens.neonGreen,
        secondary: DesignTokens.neonGreen,
        background: const Color(0xFFF6F7F9),
        surface: Colors.white,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
    );
  }
}
EOF

# screens
cat > app/lib/src/screens/home_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home — Greeting, Recently Played, Made For You')),
      // floating mini player will be globally positioned in real app
      floatingActionButton: null,
    );
  }
}
EOF

cat > app/lib/src/screens/search_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search — Animated search bar, suggestions, voice')),
    );
  }
}
EOF

cat > app/lib/src/screens/library_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: const Center(child: Text('Library — Liked, Albums, Artists, Playlists')),
    );
  }
}
EOF

cat > app/lib/src/screens/downloads_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: const Center(child: Text('Downloads — Manage background downloads, queued tasks')),
    );
  }
}
EOF

cat > app/lib/src/screens/profile_screen.dart <<'EOF'
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile — Listening stats, account, settings')),
    );
  }
}
EOF

# widgets
cat > app/lib/src/widgets/floating_mini_player.dart <<'EOF'
import 'package:flutter/material.dart';

class FloatingMiniPlayer extends StatelessWidget {
  const FloatingMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Song Title', style: TextStyle(color: Colors.white)),
                      Text('Artist', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
EOF

cat > app/lib/src/widgets/animated_bottom_nav.dart <<'EOF'
import 'package:flutter/material.dart';

class AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AnimatedBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black87,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Downloads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
EOF

# packages/audio
cat > packages/audio/lib/audio_service.dart <<'EOF'
/// Lightweight wrapper and scaffolding for an audio playback service.
/// In the real app this will integrate JustAudio, AudioService, AudioSession,
/// and platform/background handlers.

import 'package:just_audio/just_audio.dart';

class AuraAudioService {
  final AudioPlayer _player = AudioPlayer();

  AuraAudioService._privateConstructor();
  static final AuraAudioService instance = AuraAudioService._privateConstructor();

  Future<void> init() async {
    // Configure audio_session, handle interruptions, audio focus, codecs, etc.
  }

  Future<void> playUrl(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> pause() async => _player.pause();
  Future<void> stop() async => _player.stop();
  Future<void> seek(Duration position) async => _player.seek(position);

  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
}
EOF

# packages/spotify_import
cat > packages/spotify_import/lib/spotify_import_service.dart <<'EOF'
/// Spotify import scaffolding: OAuth flow placeholders and import helpers.
/// NOTE: You must register a Spotify app and provide client id/secret and redirect URIs.

import 'dart:async';

class SpotifyImportService {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  SpotifyImportService({required this.clientId, required this.clientSecret, required this.redirectUri});

  Future<Uri> getAuthorizationUrl() async {
    // Build and return the Spotify authorization URL for the user to visit.
    final scopes = [
      'playlist-read-private',
      'playlist-read-collaborative',
      'user-library-read',
    ];
    final url = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'scope': scopes.join(' '),
    });
    return url;
  }

  Future<void> handleAuthorizationCallback(String code) async {
    // Exchange code for tokens (POST to /api/token). Save refresh token securely.
  }

  Future<List<Map<String, dynamic>>> fetchPlaylists() async {
    // Call Spotify API with access token and list playlists. Return minimal playlist metadata.
    return [];
  }

  Future<void> importPlaylist(String playlistId) async {
    // Fetch playlist tracks, perform ISRC/title matching against Aura catalog, create playlist entries in Firestore/local DB.
  }
}
EOF

# app README
cat > app/README.md <<'EOF'
# Aura Music — App scaffold

This folder contains the Flutter app scaffold for Aura Music.

Setup (local development)

1. Install Flutter (stable channel) and ensure sdk is on PATH.
2. From this folder run: \`flutter pub get\`.
3. Add Firebase config files for Android and iOS to \`app/android/app/google-services.json\` and \`app/ios/GoogleService-Info.plist\` when you create a Firebase project.
4. To enable Spotify playlist import, register an app at https://developer.spotify.com/dashboard and add redirect URIs, then add your client ID/secret to your local environment or CI secrets.

Notes
- This scaffold focuses on architecture, theming, and core player/download/spotify import wiring.
- Do NOT commit client secrets to the repo. Use env vars / GitHub Secrets / platform secret stores.
EOF

# LICENSE
cat > LICENSE <<'EOF'
MIT License

Copyright (c) 2026 rashithto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# GitHub Actions workflow (CI)
cat > .github/workflows/flutter-ci.yml <<'EOF'
name: Flutter CI

on:
  push:
    branches: [ main, aura/init-scaffold ]
  pull_request:
    branches: [ main ]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - name: Install dependencies
        run: |
          cd app
          flutter pub get
      - name: Analyze
        run: |
          cd app
          flutter analyze
      - name: Run tests
        run: |
          cd app
          flutter test --no-pub
EOF

echo "Staging files..."
git add -A

echo "Creating commit..."
# commit if there are changes
if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  git commit -m "$COMMIT_MSG"
fi

echo "Creating/updating local branch $BRANCH..."
git branch -f "$BRANCH"

echo "Pushing branch to origin (this uses your local git auth)..."
git push -u origin "$BRANCH"

echo "Done. Branch $BRANCH pushed. Open a PR to merge or review the files on GitHub."
