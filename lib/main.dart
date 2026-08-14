import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_theme.dart';
import 'core/di/injection_container.dart';
import 'presentation/blocs/recent_searches/recent_searches_bloc.dart';
import 'presentation/blocs/repositories/repositories_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/blocs/theme/theme_state.dart';
import 'presentation/screens/search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => sl<SearchBloc>(),
        ),
        BlocProvider<RepositoriesBloc>(
          create: (_) => sl<RepositoriesBloc>(),
        ),
        BlocProvider<RecentSearchesBloc>(
          create: (_) => sl<RecentSearchesBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'GitHub Profile Explorer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            home: const SearchScreen(),
          );
        },
      ),
    );
  }
}
