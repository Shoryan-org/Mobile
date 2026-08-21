import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoryan/core/network/api_client.dart';
import 'package:shoryan/core/network/token_storage.dart';
import 'package:shoryan/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:shoryan/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shoryan/features/auth/domain/repositories/auth_repository.dart';
import 'package:shoryan/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shoryan/features/chatbot/data/datasources/chat_remote_data_source.dart';
import 'package:shoryan/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:shoryan/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:shoryan/features/chatbot/domain/usecases/get_chat_history_usecase.dart';
import 'package:shoryan/features/chatbot/domain/usecases/send_chat_message_usecase.dart';
import 'package:shoryan/features/chatbot/presentation/cubit/chat_cubit.dart';
import 'package:shoryan/splash_screen.dart';
import 'core/theme/app_theme.dart';

import 'package:shoryan/data/datasources/blood_request_remote_data_source.dart';
import 'package:shoryan/data/repositories/blood_request_repository.dart';
import 'package:shoryan/data/repositories/blood_request_repository_impl.dart';
import 'package:shoryan/domain/usecases/blood_request_usecases.dart';
import 'package:shoryan/screens/requests/cubit/requester_blood_requests_cubit.dart';
import 'package:shoryan/screens/requests/cubit/donor_blood_requests_cubit.dart';
import 'package:shoryan/screens/requests/cubit/blood_request_action_cubit.dart';
import 'package:shoryan/screens/requests/cubit/create_request_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables for API
  await dotenv.load(fileName: '.env');

  // Initialize storage
  final prefs = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage(prefs);

  // Configure API client with token storage
  ApiClient.instance.setTokenStorage(tokenStorage);

  runApp(
    ShoryanApp(
      tokenStorage: tokenStorage,
    ),
  );
}

class ShoryanApp extends StatelessWidget {
  final TokenStorage tokenStorage;

  const ShoryanApp({
    super.key,
    required this.tokenStorage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            AuthRemoteDataSource(),
            tokenStorage,
          ),
        ),
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepositoryImpl(
            ChatRemoteDataSource(tokenStorage),
          ),
        ),
        RepositoryProvider<GetChatHistoryUseCase>(
          create: (context) => GetChatHistoryUseCase(
            context.read<ChatRepository>(),
          ),
        ),
        RepositoryProvider<SendChatMessageUseCase>(
          create: (context) => SendChatMessageUseCase(
            context.read<ChatRepository>(),
          ),
        ),
        RepositoryProvider<BloodRequestRemoteDataSource>(
          create: (context) => BloodRequestRemoteDataSource(),
        ),
        RepositoryProvider<BloodRequestRepository>(
          create: (context) => BloodRequestRepositoryImpl(
            remoteDataSource: context.read<BloodRequestRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<GetMyBloodRequestsUseCase>(
          create: (context) => GetMyBloodRequestsUseCase(context.read<BloodRequestRepository>()),
        ),
        RepositoryProvider<GetCompatibleBloodRequestsUseCase>(
          create: (context) => GetCompatibleBloodRequestsUseCase(context.read<BloodRequestRepository>()),
        ),
        RepositoryProvider<GetAcceptedBloodRequestsUseCase>(
          create: (context) => GetAcceptedBloodRequestsUseCase(context.read<BloodRequestRepository>()),
        ),
        RepositoryProvider<CreateBloodRequestUseCase>(
          create: (context) => CreateBloodRequestUseCase(context.read<BloodRequestRepository>()),
        ),
        RepositoryProvider<AcceptBloodRequestUseCase>(
          create: (context) => AcceptBloodRequestUseCase(context.read<BloodRequestRepository>()),
        ),
        RepositoryProvider<RejectBloodRequestUseCase>(
          create: (context) => RejectBloodRequestUseCase(context.read<BloodRequestRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(context.read<AuthRepository>()),
          ),
          BlocProvider<ChatCubit>(
            create: (context) => ChatCubit(
              context.read<GetChatHistoryUseCase>(),
              context.read<SendChatMessageUseCase>(),
            ),
          ),
          BlocProvider<RequesterBloodRequestsCubit>(
            create: (context) => RequesterBloodRequestsCubit(context.read<GetMyBloodRequestsUseCase>()),
          ),
          BlocProvider<DonorBloodRequestsCubit>(
            create: (context) => DonorBloodRequestsCubit(
              context.read<GetCompatibleBloodRequestsUseCase>(),
              context.read<GetAcceptedBloodRequestsUseCase>(),
            ),
          ),
          BlocProvider<BloodRequestActionCubit>(
            create: (context) => BloodRequestActionCubit(
              context.read<AcceptBloodRequestUseCase>(),
              context.read<RejectBloodRequestUseCase>(),
            ),
          ),
          BlocProvider<CreateRequestCubit>(
            create: (context) => CreateRequestCubit(
              createBloodRequest: context.read<CreateBloodRequestUseCase>(),
              bloodRequestRepository: context.read<BloodRequestRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Shoryan',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: SplashScreen(tokenStorage: tokenStorage),
        ),
      ),
    );
  }
}